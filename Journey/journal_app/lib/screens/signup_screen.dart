import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:journal_app/utilities/snack_bar.dart';
import 'package:journal_app/widgets/pin_widget.dart';
import 'package:journal_app/widgets/ultra_background.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool agreePersonalData = true;
  bool _isVisible = false;
  final passBox = Hive.box('dataBox');

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passConfirmController = TextEditingController();
  final TextEditingController clueController = TextEditingController();

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
              'Set PIN',
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
                    keyboardType: TextInputType.number,
                    controller: passwordController,
                    obscureText: !_isVisible,
                    obscuringCharacter: '*',
                    maxLength: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter PIN';
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
                      labelStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      hintText: 'EnterPIN',
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: passConfirmController,
                    obscureText: !_isVisible,
                    obscuringCharacter: '*',
                    maxLength: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm PIN';
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
                      labelStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      hintText: 'Enter PIN',
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: clueController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a clue to don\'t lose your access';
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
                      labelStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      hintText: 'EnterClue',
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (passBox.get(1) != null || passBox.get(0) != null) {
                        showSnackBar(context, "There is a PIN already set");

                        return;
                      } else if (passwordController.text.length == 6 &&
                          passConfirmController.text.length == 6) {
                        if (passwordController.text !=
                            passConfirmController.text) {
                          showSnackBar(context, "PIN don't match");

                          return;
                        } else {
                          passBox.put(
                              0,
                              md5
                                  .convert(utf8.encode(passwordController.text))
                                  .toString());
                          passBox.put(
                              1,
                              md5
                                  .convert(utf8.encode(clueController.text))
                                  .toString());

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (e) => const PinCodeW(),
                            ),
                          );
                        }
                      } else {
                        showSnackBar(context,
                            "PIN or PIN confirmation does not have 6 digits");

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
                      "Sign up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  /*  const SizedBox(
                    height: 10,
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
