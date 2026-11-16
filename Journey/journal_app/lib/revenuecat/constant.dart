import 'package:purchases_flutter/purchases_flutter.dart';

const entitlementID = 'pro';

const footerText =
    'Free trial for 14 days and then you will be charged.\n All subscriotions renew automaticaly.\n Biled yearly\n Cancel anytime, no penalties or fees.';

const appleApiKey = 'apple_api_key';

const googleApiKey = 'goog_TKVVNHQaLguVWEmNaYoGHSGccdq';

const amazonApiKey = 'amazon_api_key';

const entitlementKey = 'pro';

bool isPremium = false;

Future<bool> checkSubscriptionStatus() async {
  try {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    final entitlement = customerInfo.entitlements.all[entitlementID];
    return entitlement != null && entitlement.isActive;
  } catch (e) {
    return false;
  }
}
