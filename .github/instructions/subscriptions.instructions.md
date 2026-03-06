---
applyTo: "lib/pangea/subscription/**"
---

# Subscription Module — Client

Client-side subscription UI, platform branching, and payment flows. For the cross-repo architecture (service roles, price configuration, entitlement flow), see [subscriptions.instructions.md](../../../.github/instructions/subscriptions.instructions.md). For group subscription design, see [group-subscriptions.instructions.md](../../../.github/instructions/group-subscriptions.instructions.md).

## Table of Contents

1. [Platform Branching](#platform-branching)
2. [Key Files](#key-files)
3. [Initialization Flow](#initialization-flow)
4. [Price Display](#price-display)
5. [Web Payment Flow](#web-payment-flow)
6. [Environment Configuration](#environment-configuration)
7. [Discount Codes on Mobile](#discount-codes-on-mobile)
8. [Group Plans](#group-plans)
   - [Group Management Page](#group-management-page)
   - [Sponsored User Indicator](#sponsored-user-indicator)
   - [Navigation & Entry Points](#navigation--entry-points)
   - [Choreo API Integration](#choreo-api-integration)
9. [Future Work](#future-work)

## Platform Branching

The subscription system splits by platform at initialization:

| Platform | Subscription info class | How purchases work | How prices are displayed |
|----------|------------------------|--------------------|------------------------|
| **Web** | [`WebSubscriptionInfo`](../../../lib/pangea/subscription/models/web_subscriptions.dart) | Choreographer generates a Stripe PaymentLink; user completes checkout in browser | `localizedPrice` is null → falls back to `"$${price.toStringAsFixed(2)}"` using price from RC metadata via choreographer |
| **Mobile** | [`MobileSubscriptionInfo`](../../../lib/pangea/subscription/models/mobile_subscriptions.dart) | RevenueCat SDK handles native store purchase via `Purchases.purchasePackage()` | `localizedPrice` set from `package.storeProduct.priceString` (locale-aware, from the store) |

Both extend [`CurrentSubscriptionInfo`](../../../lib/pangea/subscription/models/base_subscription_info.dart).

## Key Files

| File | Role |
|------|------|
| [`subscription_controller.dart`](../../../lib/pangea/subscription/controllers/subscription_controller.dart) | Main controller — initialization, purchase submission, paywall display, payment link generation |
| [`base_subscription_info.dart`](../../../lib/pangea/subscription/models/base_subscription_info.dart) | `CurrentSubscriptionInfo` base class, `AvailableSubscriptionsInfo` |
| [`mobile_subscriptions.dart`](../../../lib/pangea/subscription/models/mobile_subscriptions.dart) | Mobile: configures RC SDK, merges store packages with product list |
| [`web_subscriptions.dart`](../../../lib/pangea/subscription/models/web_subscriptions.dart) | Web: queries choreographer for current subscription status |
| [`subscription_repo.dart`](../../../lib/pangea/subscription/repo/subscription_repo.dart) | API calls to choreographer: `getAppIds`, `getAllProducts`, `activateFreeTrial`, `getCurrentSubscriptionInfo` |
| [`subscription_app_id.dart`](../../../lib/pangea/subscription/utils/subscription_app_id.dart) | `SubscriptionAppIds` model and `RCPlatform` enum for platform discrimination |
| [`subscription_management_repo.dart`](../../../lib/pangea/subscription/repo/subscription_management_repo.dart) | Local persistence (GetStorage) — caches `AvailableSubscriptionsInfo`, tracks paywall dismissal with exponential backoff, and tracks `beganWebPayment` flag |

## Initialization Flow

1. `SubscriptionController.initialize()` waits for user controller
2. `AvailableSubscriptionsInfo.setAvailableSubscriptions()` reads from the local GetStorage cache first (`SubscriptionManagementRepo`); only hits choreographer (`/subscription/all_products`, `/subscription/app_ids`) if the cache is empty. Product/pricing data can therefore be stale across app relaunches.
3. Platform-specific `CurrentSubscriptionInfo` is created (Web or Mobile)
4. `configure()` → on mobile, initializes RevenueCat SDK with platform API key
5. `setCurrentSubscription()` → on mobile, queries RC SDK; on web, queries choreographer (`/subscription`)
6. If no active subscription and user is in trial window, activates free trial

**Pending-seat activation hook:** Between steps 5 and 6, if `currentSubscriptionId == null`, the client calls `GET /subscription/check_pending_seats`. If the choreo finds and activates a pending seat, the user gets an entitlement without entering the trial flow. This runs on every startup/login, identically on web and mobile. See [choreo pending-email activation](../../../2-step-choreographer/.github/instructions/subscriptions.instructions.md#pending-email-activation).

## Price Display

[`SubscriptionDetails.displayPrice()`](../../../lib/pangea/subscription/controllers/subscription_controller.dart) resolves display price:

- Trial → localized "Free Trial" string
- Mobile → `localizedPrice` (set by RevenueCat SDK from App Store / Play Store — locale-aware, store-canonical)
- Web → `localizedPrice` is null, so falls back to `"$${price.toStringAsFixed(2)}"` using the `price` float from RevenueCat Offering metadata

This means **web users see the price from RC metadata**, not from Stripe directly. If RC metadata and the Stripe Price object disagree, users will see one price in the subscription page and a different price at Stripe checkout.

## Web Payment Flow

1. User selects a plan → `submitSubscriptionChange()` → `getPaymentLink(duration)`
2. Client calls choreographer `GET /subscription/payment_link?pangea_user_id=...&duration=month`
3. Choreographer creates a Stripe PaymentLink and returns the URL
4. Client launches the URL in-browser (`launchUrlString`)
5. After checkout, Stripe redirects to `STRIPE_REDIRECT_URL`; user returns to app
6. On next load, `WebSubscriptionInfo.setCurrentSubscription()` calls choreographer `GET /subscription`, which queries RC and returns updated entitlement status (the client never contacts RC directly on web)

## Environment Configuration

Key env values in [`assets/.env`](../../../assets/.env):

| Key | Purpose |
|-----|---------|
| `RC_GOOGLE_KEY` | RevenueCat Android SDK key |
| `RC_IOS_KEY` | RevenueCat iOS SDK key |
| `RC_STRIPE_KEY` | RevenueCat Stripe public key (used for web app ID resolution) |
| `RC_OFFERING_NAME` | RevenueCat offering identifier |
| `STRIPE_MANAGEMENT_LINK` | URL for Stripe billing portal (subscription management on web) |

## Discount Codes on Mobile

Stripe promo codes (from conferences, LCB promotions, Google Form webhooks) only work at Stripe Checkout — they cannot be applied to native App Store / Play Store purchases. This is a known friction point.

**Current approach**: Keep native IAP as the default mobile purchase path (higher conversion, 1-tap with Face ID/biometrics). For discount codes, add a "Have a discount code?" link on the mobile subscription paywall that opens the Stripe web checkout in an in-app browser via `getPaymentLink()`. The PaymentLink already has `allow_promotion_codes: True`.

**Why not web-only checkout on mobile**: Native IAP conversion rates are significantly higher than browser redirects. RevenueCat already abstracts the multi-platform complexity. Removing native IAP would also lose access to App Store / Play Store promotional pricing and subscription offer codes.

**Possible future alternative**: Apple Subscription Offer Codes (iOS 14+) and Google Play promo codes allow native discount redemption without Stripe. RevenueCat supports both. This would require creating codes in each store's console instead of just Stripe, but would eliminate the web checkout redirect for discount users.

## Group Plans

Group plans let a buyer (teacher or admin) purchase a bundle of seats and assign them to learners. The buyer interacts with group management entirely on **web** — mobile users who receive a sponsored seat simply see their entitlement activate. For design decisions and cross-repo contracts, see [group-subscriptions.instructions.md](../../../.github/instructions/group-subscriptions.instructions.md).

### Group Management Page

A new page accessible to any logged-in user (web only) for buying and managing group seats:

- **Purchase flow**: Seat count selector with sliding discount preview → Stripe Checkout (via `POST /subscription/seat_checkout`) → return to management page
- **Seat roster**: Table of assignments per subscription — shows user display name, email, status (`active` / `pending`), assigned date
- **Assign seats**: Bulk email input (comma/newline separated) → `POST /subscription/seats/assign_emails`. Individual Matrix-ID-based assignment for users already on platform → `POST /subscription/seats/assign`
- **Revoke seats**: Per-row action that calls `POST /subscription/seats/revoke` and updates the roster
- **Subscription summary**: Shows seat utilization (assigned/total), next renewal date, link to Stripe billing portal for cancellation

This page is **web-only** because group purchases use Stripe Checkout, which requires a browser redirect.

### Sponsored User Indicator

Users who have an active entitlement from a seat assignment (rather than their own purchase) see a visual indicator in the same placement as the free trial indicator (for users in the trial window):
- Who is sponsoring them (buyer display name)
- That their subscription is managed externally (they cannot cancel — the buyer controls it)
- Expiration date of the sponsored seat

This data comes from `GET /subscription/my_seats` (not from RC, which has no sponsor metadata).

### Navigation & Entry Points

- **Pricing page** (website, not in-app): "Group" tier card → links to group checkout flow
- **App subscription settings**: Link to group management page for users with active group subscriptions
- **Invitation email**: Learner receives email with link to sign up with the invited email address. Seat activates automatically on account creation.

### Choreo API Integration

New repo methods for the group endpoints listed in the [choreo subscription doc](../../../2-step-choreographer/.github/instructions/subscriptions.instructions.md#new-endpoints):

- `getGroupCheckoutUrl(seatCount)` → POST `/subscription/seat_checkout`
- `getSeatPurchases()` → GET `/subscription/seat_purchases`
- `getSeatAssignments(purchaseId)` → GET `/subscription/seat_purchases/{id}/assignments`
- `assignSeatsByEmail(purchaseId, emails)` → POST `/subscription/seats/assign_emails`
- `assignSeat(purchaseId, userMatrixId)` → POST `/subscription/seats/assign`
- `revokeSeat(assignmentId)` → POST `/subscription/seats/revoke`
- `getMySeats()` → GET `/subscription/my_seats`
- `checkPendingSeats()` → GET `/subscription/check_pending_seats`

These follow the same pattern as existing `subscription_repo.dart` methods — authenticated via Matrix token.

## Future Work

- [pangeachat/client#4977](https://github.com/pangeachat/client/issues/4977) — Move entering of discount code to subscription page
- [pangeachat/marketing-and-sales-strategy#34](https://github.com/pangeachat/marketing-and-sales-strategy/issues/34) — Lock down v2 pricing and apply across website + app
