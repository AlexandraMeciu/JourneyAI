import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:journal_app/datetime/date_time.dart';
import 'package:journal_app/revenuecat/feature_item.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:journal_app/revenuecat/constant.dart';
import 'package:journal_app/revenuecat/singletons_data.dart';

import '../widgets/pin_widget.dart';

class PaywallScreen extends StatefulWidget {
  final Offering offering;

  const PaywallScreen({super.key, required this.offering});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
          child: Wrap(
        children: <Widget>[
          Container(
            height: 70,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: const Center(
              child: Text(
                'Upgrade to Premium',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ),
          ListView.builder(
            itemCount: widget.offering.availablePackages.length,
            itemBuilder: (BuildContext context, int index) {
              var myProductList = widget.offering.availablePackages;
              return Card(
                color: const Color.fromARGB(148, 76, 175, 79),
                child: ListTile(
                  onTap: () async {
                    try {
                      CustomerInfo customerInfo =
                          (await Purchases.purchasePackage(
                              myProductList[index])) as CustomerInfo;

                      EntitlementInfo? entitlement =
                          customerInfo.entitlements.all[entitlementID];
                      appData.entitlementIsActive =
                          entitlement?.isActive ?? false;
                    } catch (e) {
                      debugPrint('error: $e');
                    }

                    setState(() {});
                    Navigator.pop(context);
                  },
                  title: Text(
                    myProductList[index].storeProduct.title,
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    myProductList[index].storeProduct.description,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  trailing: Text(
                    myProductList[index].storeProduct.priceString,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  color: const Color.fromARGB(122, 66, 66, 66),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(16)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Freemium Version (Basic)",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        FeatureItem(
                            "Guided Journaling - All prompts available."),
                        FeatureItem("Habit Tracker - Up to 3 active habits."),
                        FeatureItem("Daily Priorities - Up to 5 per day."),
                        FeatureItem("Goal Planner - 1 active goal plan."),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Card(
                  color: Color.fromARGB(122, 66, 66, 66),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Premium Version",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.orange[800]),
                        ),
                        SizedBox(height: 8),
                        FeatureItem("Guided Journaling."),
                        FeatureItem("Unlimited habits."),
                        FeatureItem("Unlimited priorities."),
                        FeatureItem("Unlimited goals."),
                        FeatureItem("Export your journals to PDF."),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    footerText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          if (firstUse)
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    isPremium = false;
                    Navigator.push(
                        context, MaterialPageRoute(builder: (e) => PinCodeW()));
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                        const Color.fromARGB(108, 158, 158, 158)),
                  ),
                  child: Text(
                    'Use Basic Version',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  )),
            ),
          SizedBox(
            height: 20,
          )
        ],
      )),
    );
  }
}
