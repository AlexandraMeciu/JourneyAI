import 'package:flutter/material.dart';

void showTopSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Container(
      padding: const EdgeInsets.all(8),
      height: 40,
      decoration: const BoxDecoration(
        color: Color.fromARGB(197, 167, 64, 251),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    dismissDirection: DismissDirection.up,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 3,
    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 80),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        padding: const EdgeInsets.all(8),
        height: 40,
        decoration: const BoxDecoration(
          color: Color.fromARGB(197, 83, 64, 251),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
