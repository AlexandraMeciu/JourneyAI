import 'package:flutter/material.dart';

class AlertBox extends StatelessWidget {
  final VoidCallback onClose;
  const AlertBox({super.key, required this.onClose});

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
          content: SizedBox(
            width: constrain.maxWidth * 0.8,
            child: const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'No data at this date',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: MaterialButton(
                  onPressed: onClose,
                  color: Color.fromARGB(255, 103, 79, 255).withAlpha(200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minWidth: screenWidth * 0.25,
                  child: const Text(
                    "Close",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
