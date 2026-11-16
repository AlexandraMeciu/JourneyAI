import 'package:flutter/material.dart';
import 'package:journal_app/datetime/date_time.dart';
import 'package:journal_app/widgets/custom_scaffold.dart';
import 'package:journal_app/widgets/pin_widget.dart';
import 'package:journal_app/widgets/welcome_buttons.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 7,
            fit: FlexFit.loose,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 115,
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
                child: Text(
                  firstUse ? 'Press on the lock to unlock your journey' : '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Expanded(
                    child: WelcomeButtons(
                      buttonText: '',
                      onTap: PinCodeW(),
                      color: Color.fromARGB(255, 168, 117, 185),
                      textColor: Color.fromARGB(255, 248, 248, 246),
                      icon: Icon(Icons.lock),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
