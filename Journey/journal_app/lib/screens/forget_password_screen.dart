import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:journal_app/utilities/snack_bar.dart';
import 'package:journal_app/widgets/pin_widget.dart';
import 'package:journal_app/widgets/ultra_background.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController clueController = TextEditingController();
  final TextEditingController passCodeController = TextEditingController();
  final TextEditingController passCodeConfirmationController =
      TextEditingController();
  bool _isVisible = false;
  final passBox = Hive.box('dataBox');
  final key = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: UltraBackground(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'Reset PIN',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          extendBodyBehindAppBar: false,
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 7),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  TextFormField(
                    controller: clueController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter the clue word to reset your passcode';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        labelText: 'Clue',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        labelStyle: const TextStyle(color: Colors.white),
                        hintText: 'Enter the Clue',
                        hintStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        )),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: passCodeController,
                    obscureText: !_isVisible,
                    obscuringCharacter: '*',
                    maxLength: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the new PIN';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'PIN - 6 digits',
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isVisible = !_isVisible;
                          });
                        },
                        icon: _isVisible
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        color: Colors.grey,
                      ),
                      labelStyle: const TextStyle(color: Colors.white),
                      hintText: 'Enter new PIN',
                      hintStyle: const TextStyle(color: Colors.white),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: passCodeConfirmationController,
                    obscureText: !_isVisible,
                    obscuringCharacter: '*',
                    maxLength: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm  PIN';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'PIN Confirmation - 6 digits',
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isVisible = !_isVisible;
                          });
                        },
                        icon: _isVisible
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        color: Colors.grey,
                      ),
                      labelStyle: const TextStyle(color: Colors.white),
                      hintText: 'Enter PIN',
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (passCodeController.text.length == 6 &&
                          passCodeConfirmationController.text.length == 6) {
                        if (md5
                                .convert(utf8.encode(clueController.text))
                                .toString() ==
                            passBox.get(1)) {
                          if (passCodeController.text !=
                              passCodeConfirmationController.text) {
                            showSnackBar(context,
                                "The PIN confirmation is different from the PIN");
                            return;
                          } else {
                            passBox.put(
                                0,
                                md5
                                    .convert(
                                        utf8.encode(passCodeController.text))
                                    .toString());
                            showSnackBar(context, "PIN changed");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (e) => const PinCodeW(),
                              ),
                            );
                          }
                        } else {
                          showSnackBar(context, "Wrong clue");
                          return;
                        }
                      } else {
                        showSnackBar(context, "The PIN doesn't have 6 digits");
                        return;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.withAlpha(145),
                      foregroundColor: Colors.blueGrey,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text(
                      'Reset PIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
