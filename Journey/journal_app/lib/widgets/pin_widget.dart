import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:journal_app/datetime/date_time.dart';
import 'package:journal_app/screens/forget_password_screen.dart';
import 'package:journal_app/screens/main_screen.dart';
import 'package:journal_app/screens/signup_screen.dart';
import 'package:journal_app/utilities/snack_bar.dart';
import 'package:journal_app/widgets/ultra_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinCodeW extends StatefulWidget {
  const PinCodeW({super.key});

  @override
  State<PinCodeW> createState() => _PinCodeWState();
}

class _PinCodeWState extends State<PinCodeW> {
  String enteredPin = '';
  bool isPinVisible = false;
  final _myPass = Hive.box('dataBox');
  Color buttonsBackgroundColors = Colors.blueGrey.withAlpha(145);

  void changeIntroStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro_status', false);
    firstUse = false;
  }

  Widget numButtons(int number) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonsBackgroundColors,
          fixedSize: Size.fromWidth(70),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          setState(() {
            if (enteredPin.length < 6) {
              enteredPin += number.toString();
            }
            if (enteredPin.length == 6) {
              if (md5.convert(utf8.encode(enteredPin)).toString() ==
                  _myPass.get(0)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (e) => const MainScreen(),
                  ),
                );
                enteredPin = '';
              } else {
                showSnackBar(context, "Wrong Password");
                enteredPin = '';
              }
            }
          });
        },
        child: Text(
          number.toString(),
          style: const TextStyle(
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UltraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Enter your PIN',
            style: TextStyle(fontSize: 40),
          ),
        ),
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              "",
              style: TextStyle(
                fontSize: 38,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  //pin code area
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        margin: const EdgeInsets.all(4),
                        width: 39, //isPinVisible ? 38 : 28,
                        height: 39, //isPinVisible ? 38 : 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 2, color: Colors.grey),
                          color: buttonsBackgroundColors,
                        ),
                        child: index < enteredPin.length
                            ? isPinVisible
                                ? Center(
                                    child: Text(
                                      enteredPin[index],
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      '*',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        height: 1.5,
                                      ),
                                    ),
                                  )
                            : null,
                      );
                    }),
                  ),
                  //visibility toggle button
                  IconButton(
                    iconSize: 30,
                    onPressed: () {
                      setState(() {
                        isPinVisible = !isPinVisible;
                      });
                    },
                    icon: Icon(
                      isPinVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),

                  SizedBox(
                    height: 25,
                    //isPinVisible ? 35 : 25,
                  ),

                  //digits
                  for (var i = 0; i < 3; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          3,
                          (index) => numButtons(1 + 3 * i + index),
                        ).toList(),
                      ),
                    ),
                  // 0 digits with back remove
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TextButton(onPressed: null, child: SizedBox()),
                        numButtons(0),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                //backgroundColor: buttonsBackgroundColors,
                                //fixedSize: Size(65, 55),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            onPressed: () {
                              setState(() {
                                if (enteredPin.isNotEmpty) {
                                  enteredPin = enteredPin.substring(
                                      0, enteredPin.length - 1);
                                }
                              });
                            },
                            child: const Icon(
                              Icons.backspace,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // reset button
                  if (_myPass.get(0) != null)
                    Column(
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const ForgetPasswordScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: buttonsBackgroundColors,
                                foregroundColor: Colors.blueGrey,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30),
                                //EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            child: Text(
                              'Reset Passcode',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )),
                      ],
                    ),

                  if (_myPass.get(0) == null)
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (firstUse == true) {
                                changeIntroStatus();
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SignUpScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: buttonsBackgroundColors,
                                foregroundColor: Colors.blueGrey,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            child: Text(
                              'Add Passcode',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        if (_myPass.get(0) == null)
                          ElevatedButton(
                              onPressed: () {
                                if (firstUse == true) {
                                  changeIntroStatus();
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (e) => const MainScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonsBackgroundColors,
                                  foregroundColor: Colors.blueGrey,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 40),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              child: Text(
                                'Skip for now',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
