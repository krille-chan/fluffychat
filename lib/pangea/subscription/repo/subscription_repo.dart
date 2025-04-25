import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/subscription/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/subscription/utils/subscription_app_id.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../common/network/urls.dart';

class SubscriptionRepo {
  static Future<SubscriptionAppIds?> getAppIds() async {
    try {
      final Requests req = Requests(
        choreoApiKey: Environment.choreoApiKey,
        accessToken: MatrixState.pangeaController.userController.accessToken,
      );
      final http.Response res = await req.get(
        url: PApiUrls.rcAppsChoreo,
      );

      return SubscriptionAppIds.fromJson(
        jsonDecode(res.body),
      );
    } catch (err) {
      ErrorHandler.logError(
        m: "Failed to fetch app information for revenuecat API",
        s: StackTrace.current,
        data: {},
      );
      return null;
    }
  }

  static Future<List<SubscriptionDetails>?> getAllProducts() async {
    try {
      final Requests req = Requests(
        choreoApiKey: Environment.choreoApiKey,
        accessToken: MatrixState.pangeaController.userController.accessToken,
      );
      final http.Response res = await req.get(
        url: PApiUrls.rcProductsChoreo,
      );
      final Map<String, dynamic> json = jsonDecode(res.body);
      final RCProductsResponseModel resp =
          RCProductsResponseModel.fromJson(json);
      return resp.allProducts;
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {},
      );
      return null;
    }
  }

  static Future<bool> activateFreeTrial() async {
    try {
      final Requests req = Requests(
        choreoApiKey: Environment.choreoApiKey,
        accessToken: MatrixState.pangeaController.userController.accessToken,
      );
      final http.Response res = await req.get(
        url: PApiUrls.rcProductsTrial,
      );

      if (res.statusCode != 201) {
        ErrorHandler.logError(
          e: res.body,
          data: {},
        );
        return false;
      } else {
        return true;
      }
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {},
      );
      return false;
    }
  }

  static Future<RCSubscriptionResponseModel> getCurrentSubscriptionInfo(
    String? userId,
    List<SubscriptionDetails>? allProducts,
  ) async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: MatrixState.pangeaController.userController.accessToken,
    );

    final http.Response res = await req.get(url: PApiUrls.rcSubscription);
    final Map<String, dynamic> json = jsonDecode(res.body);
    final RCSubscriptionResponseModel resp =
        RCSubscriptionResponseModel.fromJson(
      json,
      allProducts,
    );
    return resp;
  }
}

class RCProductsResponseModel {
  List<SubscriptionDetails> allProducts;

  RCProductsResponseModel({
    required this.allProducts,
  });

  factory RCProductsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final List<dynamic> offerings = json["items"] as List<dynamic>;
    final res = offerings
        .map((offering) => SubscriptionDetails.fromJson(offering))
        .toList()
        .cast<SubscriptionDetails>();
    return RCProductsResponseModel(allProducts: res);
  }

  static List<SubscriptionDetails> productsFromPackageDetails(
    Map<String, dynamic> packageDetails,
    String packageId,
    Map<String, dynamic> metadata,
  ) {
    return packageDetails['products']['items']
        .map(
          (productDetails) => SubscriptionDetails(
            price: double.parse(metadata['$packageId.price']),
            duration: SubscriptionDuration.values.firstWhereOrNull(
              (duration) => duration.value == metadata['$packageId.duration'],
            ),
            id: productDetails['product']['store_identifier'],
            appId: productDetails['product']['app_id'],
          ),
        )
        .toList()
        .cast<SubscriptionDetails>();
  }
}

class RCSubscriptionResponseModel {
  String? currentSubscriptionId;
  SubscriptionDetails? currentSubscription;
  DateTime? expirationDate;
  List<String>? allEntitlements;
  Map<String, RCSubscription>? allSubscriptions;

  RCSubscriptionResponseModel({
    this.currentSubscriptionId,
    this.currentSubscription,
    this.allEntitlements,
    this.expirationDate,
    this.allSubscriptions,
  });

  factory RCSubscriptionResponseModel.fromJson(
    Map<String, dynamic> json,
    List<SubscriptionDetails>? allProducts,
  ) {
    final List<String> activeEntitlements =
        RCSubscriptionResponseModel.getActiveEntitlements(json);

    if (activeEntitlements.length > 1) {
      debugPrint(
        "User has more than one active entitlement. This shouldn't happen",
      );
    }

    final history = (json['subscriptions'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, RCSubscription.fromJson(value)),
    );

    if (activeEntitlements.isEmpty) {
      debugPrint("User has no active entitlements");
      return RCSubscriptionResponseModel(
        allSubscriptions: history,
      );
    }

    final String currentSubscriptionId = activeEntitlements[0];

    final Map<String, dynamic> currentSubscriptionMetadata =
        json['subscriptions'][currentSubscriptionId];

    final DateTime expirationDate = DateTime.parse(
      currentSubscriptionMetadata['expires_date'],
    );

    final SubscriptionDetails? currentSubscription =
        allProducts?.firstWhereOrNull(
      (SubscriptionDetails sub) =>
          sub.id.contains(currentSubscriptionId) ||
          currentSubscriptionId.contains(sub.id),
    );

    return RCSubscriptionResponseModel(
      currentSubscription: currentSubscription,
      currentSubscriptionId: currentSubscriptionId,
      expirationDate: expirationDate,
      allEntitlements: activeEntitlements,
      allSubscriptions: history,
    );
  }

  static List<String> getActiveEntitlements(Map<String, dynamic> json) {
    return json['entitlements']
        .entries
        .where(
          (MapEntry<String, dynamic> entitlement) => DateTime.parse(
            entitlement.value['expires_date'],
          ).isAfter(DateTime.now()),
        )
        .map(
          (MapEntry<String, dynamic> entitlement) =>
              entitlement.value['product_identifier'],
        )
        .cast<String>()
        .toList();
  }

  static List<String> getAllEntitlements(Map<String, dynamic> json) {
    return json['entitlements']
        .entries
        .map(
          (MapEntry<String, dynamic> entitlement) =>
              entitlement.value['product_identifier'],
        )
        .cast<String>()
        .toList();
  }
}

class RCSubscription {
  final String? autoResumeDate;
  final String? billingIssuesDetectedAt;
  final String expiresDate;
  final String? gracePeriodExpiresDate;
  final bool isSandbox;
  final String originalPurchaseDate;
  final String periodType;
  final String purchaseDate;
  final String? refundedAt;
  final String store;
  final String storeTransactionId;
  final String? unsubscribeDetectedAt;

  RCSubscription({
    required this.autoResumeDate,
    required this.billingIssuesDetectedAt,
    required this.expiresDate,
    required this.gracePeriodExpiresDate,
    required this.isSandbox,
    required this.originalPurchaseDate,
    required this.periodType,
    required this.purchaseDate,
    required this.refundedAt,
    required this.store,
    required this.storeTransactionId,
    required this.unsubscribeDetectedAt,
  });

  factory RCSubscription.fromJson(Map<String, dynamic> json) {
    return RCSubscription(
      autoResumeDate: json['auto_resume_date'],
      billingIssuesDetectedAt: json['billing_issues_detected_at'],
      expiresDate: json['expires_date'],
      gracePeriodExpiresDate: json['grace_period_expires_date'],
      isSandbox: json['is_sandbox'],
      originalPurchaseDate: json['original_purchase_date'],
      periodType: json['period_type'],
      purchaseDate: json['purchase_date'],
      refundedAt: json['refunded_at'],
      store: json['store'],
      storeTransactionId: json['store_transaction_id'],
      unsubscribeDetectedAt: json['unsubscribe_detected_at'],
    );
  }
}
