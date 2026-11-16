import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:journal_app/revenuecat/paywall_screen.dart';
import 'package:journal_app/revenuecat/store_config.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static Future<void> configureSDK() async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration;
    if (StoreConfig.isForAmazonAppstore()) {
      configuration = AmazonConfiguration(StoreConfig.instance.apiKey);
    } else {
      configuration = PurchasesConfiguration(StoreConfig.instance.apiKey);
    }

    configuration.entitlementVerificationMode =
        EntitlementVerificationMode.informational;
    configuration.pendingTransactionsForPrepaidPlansEnabled = true;
    await Purchases.configure(configuration);
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;

      return current == null ? [] : [current];
    } on PlatformException catch (e) {
      debugPrint('error: $e');
      return [];
    }
  }

  static Future<void> showPurchasePanel(BuildContext context) async {
    Offerings? offerings;
    try {
      offerings = await Purchases.getOfferings();
    } catch (e) {
      debugPrint('Error fetching offerings: $e');
    }

    if (offerings != null && offerings.current != null) {
      await showModalBottomSheet(
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return PaywallScreen(offering: offerings!.current!);
          });
    }
  }
/*
  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(packageToPurchase);

      return true;
    } catch (e) {
      return false;
    }
  }*/
}
