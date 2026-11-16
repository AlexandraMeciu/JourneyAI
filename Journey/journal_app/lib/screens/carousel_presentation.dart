import 'package:flutter/material.dart';
import 'package:journal_app/intro/page1.dart';
import 'package:journal_app/intro/page2.dart';
import 'package:journal_app/intro/page3.dart';
import 'package:journal_app/screens/welcome_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PresentationScreen extends StatefulWidget {
  const PresentationScreen({super.key});

  @override
  State<PresentationScreen> createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> {
  final PageController _pageController = PageController();
  String buttonText = "Skip";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 2, 0, 8),
      body: Stack(children: [
        PageView(
          controller: _pageController,
          onPageChanged: (index) {
            index == 2 ? buttonText = "Start" : buttonText = "Skip";
            setState(() {});
          },
          children: [
            Screen1(),
            Screen2(),
            Screen3(),
          ],
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SmoothPageIndicator(controller: _pageController, count: 3),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (e) => WelcomeScreen()));
                },
                child: Text(
                  buttonText,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
