import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/config/environment.dart';
import 'package:fluffychat/pangea/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/network/requests.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/subscription_app_id.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../network/urls.dart';

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

  static Future<RCSubscriptionResponseModel> getCurrentSubscriptionInfo(
    String? userId,
    List<SubscriptionDetails>? allProducts,
  ) async {
    final Map<String, String> stripeHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Environment.rcStripeKey}',
    };
    final String url = "${PApiUrls.rcSubscription}/$userId";
    final http.Response res = await http.get(
      Uri.parse(url),
      headers: stripeHeaders,
    );
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

  RCSubscriptionResponseModel({
    this.currentSubscriptionId,
    this.currentSubscription,
    this.allEntitlements,
    this.expirationDate,
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
    if (activeEntitlements.isEmpty) {
      debugPrint("User has no active entitlements");
      return RCSubscriptionResponseModel();
    }

    final String currentSubscriptionId = activeEntitlements[0];

    final Map<String, dynamic> currentSubscriptionMetadata =
        json['subscriber']['subscriptions'][currentSubscriptionId];

    final DateTime expirationDate = DateTime.parse(
      currentSubscriptionMetadata['expires_date'],
    );

    final String currentSubscriptionPeriodType =
        currentSubscriptionMetadata['period_type'] ?? "";

    final SubscriptionDetails? currentSubscription =
        allProducts?.firstWhereOrNull(
      (SubscriptionDetails sub) =>
          sub.id.contains(currentSubscriptionId) ||
          currentSubscriptionId.contains(sub.id),
    );

    if (currentSubscriptionPeriodType == "trial") {
      currentSubscription?.makeTrial();
    }

    return RCSubscriptionResponseModel(
      currentSubscription: currentSubscription,
      currentSubscriptionId: currentSubscriptionId,
      expirationDate: expirationDate,
      allEntitlements: activeEntitlements,
    );
  }

  static List<String> getActiveEntitlements(Map<String, dynamic> json) {
    return json['subscriber']['entitlements']
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
    return json['subscriber']['entitlements']
        .entries
        .map(
          (MapEntry<String, dynamic> entitlement) =>
              entitlement.value['product_identifier'],
        )
        .cast<String>()
        .toList();
  }
}
