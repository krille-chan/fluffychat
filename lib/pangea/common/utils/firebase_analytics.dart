import 'package:flutter/widgets.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:fluffychat/pangea/subscription/controllers/subscription_controller.dart';
import '../../../config/firebase_options.dart';

// PageRoute import

// Add import:
// import 'package:fluffychat/pangea/utils/firebase_analytics.dart';
// Call method: GoogleAnalytics.logout()

class GoogleAnalytics {
  static FirebaseAnalytics? analytics;

  GoogleAnalytics();

  static Future<void> initialize() async {
    FirebaseApp app;
    try {
      app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } on Exception {
      app = Firebase.app();
    }

    analytics = FirebaseAnalytics.instanceFor(app: app);
  }

  static analyticsUserUpdate(String? userID) {
    debugPrint("user update $userID");
    analytics?.setUserId(id: userID);
  }

  static updateUserSubscriptionStatus(bool subscribed) {
    analytics?.setUserProperty(
      name: 'subscribed',
      value: "$subscribed",
    );
  }

  static logEvent(String name, {parameters}) {
    debugPrint("event: $name - parameters: $parameters");
    analytics?.logEvent(name: name, parameters: parameters);
  }

  static login(String type, String? userID) {
    logEvent('login', parameters: {'method': type});
    analyticsUserUpdate(userID);
  }

  static signUp(String type) {
    logEvent('sign_up', parameters: {'method': type});
  }

  static logout() {
    logEvent('logout');
    analyticsUserUpdate(null);
  }

  static createClass(String className, String classCode) {
    logEvent(
      'create_class',
      parameters: {'name': className, 'group_id': classCode},
    );
  }

  static createChat(String newChatRoomId) {
    logEvent('create_chat', parameters: {"chat_id": newChatRoomId});
  }

  static addParent(String chatRoomId, String classCode) {
    logEvent(
      'add_room_to_class',
      parameters: {"chat_id": chatRoomId, 'group_id': classCode},
    );
  }

  static removeChatFromClass(String chatRoomId, String classCode) {
    logEvent(
      'remove_room_from_class',
      parameters: {"chat_id": chatRoomId, 'group_id': classCode},
    );
  }

  static joinClass(String classCode) {
    logEvent('join_group', parameters: {'group_id': classCode});
  }

  static sendMessage(String chatRoomId, String classCode) {
    logEvent(
      'sent_message',
      parameters: {
        "chat_id": chatRoomId,
        'group_id': classCode,
      },
    );
  }

  static contextualRequest() {
    logEvent('context_request');
  }

  static messageTranslate() {
    logEvent('message_translate');
  }

  static beginPurchaseSubscription(
    SubscriptionDetails details,
    BuildContext context,
  ) {
    logEvent(
      'begin_checkout',
      parameters: {
        "currency": "USD",
        'value': details.price,
        'transaction_id': details.id,
        'items': [
          {
            'item_id': details.package!.identifier,
            'item_name': details.displayName(context),
            'price': details.price,
            'item_category': "subscription",
            'quantity': 1,
          }
        ],
      },
    );
  }

  static FirebaseAnalyticsObserver getAnalyticsObserver() {
    if (analytics == null) {
      throw Exception("Firebase Analytics not initialized");
    }
    return FirebaseAnalyticsObserver(
      analytics: analytics!,
      routeFilter: (route) {
        // By default firebase only tracks page routes
        if (route is! PageRoute ||
            // No user logged in, so we dont track
            route.settings.name == "login" ||
            route.settings.name == "/home" ||
            route.settings.name == "connect" ||
            route.settings.name == "signup") {
          return false;
        }
        final String? name = route.settings.name;
        debugPrint("navigating to route: $name");
        return true;
      },
    );
  }
}
