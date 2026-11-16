import 'package:flutter/material.dart';

class MyAlertBox extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const MyAlertBox({
    super.key,
    this.controller,
    required this.hintText,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constrain) {
        return AlertDialog(
          backgroundColor:
              const Color.fromARGB(255, 51, 39, 156).withAlpha(200),
          elevation: 3,
          shadowColor: const Color.fromARGB(255, 5, 0, 57),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              width: 6,
              color: const Color.fromARGB(255, 42, 32, 129).withAlpha(250),
            ),
          ),
          alignment: Alignment.center,
          actionsPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
          content: SizedBox(
            width: constrain.maxWidth * 0.9,
            child: TextField(
              textAlign: TextAlign.center,
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.white),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: MaterialButton(
                    onPressed: onSave,
                    color:
                        const Color.fromARGB(255, 103, 79, 255).withAlpha(200),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minWidth: screenWidth * 0.3,
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: MaterialButton(
                    onPressed: onCancel,
                    color:
                        const Color.fromARGB(255, 103, 79, 255).withAlpha(200),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minWidth: screenWidth * 0.3,
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
