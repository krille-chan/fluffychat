---
applyTo: "lib/pangea/subscription/**"
---

# Subscription Module — Client

Client-side subscription UI, platform branching, and payment flows. For the cross-repo architecture (service roles, price configuration, entitlement flow), see [subscriptions.instructions.md](../../../.github/instructions/subscriptions.instructions.md).

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

## Future Work

- [pangeachat/client#4977](https://github.com/pangeachat/client/issues/4977) — Move entering of discount code to subscription page
- [pangeachat/marketing-and-sales-strategy#34](https://github.com/pangeachat/marketing-and-sales-strategy/issues/34) — Lock down v2 pricing and apply across website + app
