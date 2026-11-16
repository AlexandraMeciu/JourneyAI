import 'package:journal_app/revenuecat/constant.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

DateTime nowTime = DateTime.now();
int selectionIndex = 0;
bool firstUse = true;
bool notifications = false;

String todaysDateFormatted() {
  var dateTimeObject = DateTime.now();

  String year = dateTimeObject.year.toString();

  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  String yyyymmdd = year + month + day;
  return yyyymmdd;
}

DateTime createDateTimeObjet(String yyyymmdd) {
  int yyyy = int.parse(yyyymmdd.substring(0, 4));
  int mm = int.parse(yyyymmdd.substring(4, 6));
  int dd = int.parse(yyyymmdd.substring(6, 8));

  DateTime dateTimeObject = DateTime(yyyy, mm, dd);
  return dateTimeObject;
}

String convertDateTimeToString(DateTime dateTime) {
  String year = dateTime.year.toString();

  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  String yyyymmdd = year + month + day;
  return yyyymmdd;
}

void checkPremium() async {
  CustomerInfo customerInfo = await Purchases.getCustomerInfo();
  customerInfo.entitlements.all[entitlementID];
  if (customerInfo.entitlements.all[entitlementID] != null &&
      customerInfo.entitlements.all[entitlementID]?.isActive == true) {
    isPremium = true;
  }
}
