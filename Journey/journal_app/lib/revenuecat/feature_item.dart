import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FeatureItem extends StatelessWidget {
  String text;
  FeatureItem(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: TextStyle(fontSize: 16),
          ),
          Expanded(
              child: Text(
            text,
            style: TextStyle(fontSize: 14),
          ))
        ],
      ),
    );
  }
}
