// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:journal_app/datetime/date_time.dart';
import 'package:journal_app/revenuecat/constant.dart';
import 'package:journal_app/revenuecat/paywall_screen.dart';
import 'package:journal_app/widgets/native_dialog.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class WelcomeButtons extends StatefulWidget {
  const WelcomeButtons(
      {super.key,
      this.buttonText,
      this.onTap,
      this.color,
      this.textColor,
      this.icon});
  final String? buttonText;
  final Widget? onTap;
  final Color? color;
  final Color? textColor;
  final Icon? icon;

  @override
  State<WelcomeButtons> createState() => _WelcomeButtonsState();
}

class _WelcomeButtonsState extends State<WelcomeButtons> {
  final TextEditingController passController = TextEditingController();

  bool remeberPassword = true;
  bool isConnectedToTheInternet = true;

  StreamSubscription? _internetConnectionSubscription;

  @override
  void initState() {
    super.initState();
    checkForInternetConnection();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      isAllowed ? notifications = true : notifications = false;
    });
  }

  @override
  void dispose() {
    _internetConnectionSubscription?.cancel();
    super.dispose();
  }

  void checkForInternetConnection() {
    _internetConnectionSubscription =
        InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isConnectedToTheInternet = true;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnectedToTheInternet = false;
          });
          break;
        // ignore: unreachable_switch_default
        default:
          setState(() {
            isConnectedToTheInternet = false;
          });
          break;
      }
    });
  }

  /* Future<void> _showSubscriptionExpiredDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => ShowDialogToDismiss(
        title: 'Subscription Expired',
        content:
            'If you want to enjoy the premium features renew your subscription.',
        buttonText: 'OK',
      ),
    );
  }*/

  void startApp() async {
    if (!isConnectedToTheInternet) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => ShowDialogToDismiss(
          title: 'No Internet Connection',
          content: 'Check your internet connection.',
          buttonText: 'OK',
        ),
      );
      checkForInternetConnection();
    } else {
      performMagic();
    }
  }

  void performMagic() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    customerInfo.entitlements.all[entitlementID];

    if (customerInfo.entitlements.all[entitlementID] != null &&
        customerInfo.entitlements.all[entitlementID]?.isActive == true) {
      /*    DateTime expirationDate = DateTime.parse(customerInfo
          .entitlements.all[entitlementID]!.expirationDate
          .toString());
      DateTime now = DateTime.now().toUtc();
      if (!isConnectedToTheInternet && now.isAfter(expirationDate)) {
        await _showSubscriptionExpiredDialog();
        return;
      }*/
      isPremium = true;
      Navigator.push(context, MaterialPageRoute(builder: (e) => widget.onTap!));
    } else {
      Offerings? offerings;

      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {
        await showDialog(
            context: context,
            builder: (BuildContext context) => ShowDialogToDismiss(
                  title: 'Error',
                  content: e.message ?? "Offerings error",
                  buttonText: 'OK',
                ));
      }

      if (offerings == null || offerings.current == null) {
        if (kDebugMode) {
          print('No offerings');
        }
      } else {
        await showModalBottomSheet(
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          backgroundColor: Colors.black,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return PaywallScreen(offering: offerings!.current!);
            });
          },
        );
      }
    }
  }

  void checkPremium() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    customerInfo.entitlements.all[entitlementID];

    if (customerInfo.entitlements.all[entitlementID] != null &&
        customerInfo.entitlements.all[entitlementID]?.isActive == true) {
      isPremium = true;
    }
    Navigator.push(context, MaterialPageRoute(builder: (e) => widget.onTap!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: IconButton(
          icon: widget.icon!,
          iconSize: 50.0,
          alignment: Alignment.center,
          color: widget.color!,
          onPressed: () async {
            /* Navigator.push(
                context, MaterialPageRoute(builder: (e) => widget.onTap!));*/
            firstUse ? startApp() : checkPremium();
          },
        ),
      ),
    );
  }
}
