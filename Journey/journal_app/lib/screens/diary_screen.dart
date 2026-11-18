import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:journal_app/chat_managers/chat_manager.dart';
import 'package:journal_app/utilities/data_saved.dart';
import 'package:journal_app/widgets/actions_buttons.dart';
import 'package:journal_app/widgets/ultra_background.dart';

import '../widgets/back_view.dart';
import '../widgets/front_view.dart';

class DiaryMain extends StatefulWidget {
  const DiaryMain({super.key});

  @override
  State<DiaryMain> createState() => _DiaryMainState();
}

class _DiaryMainState extends State<DiaryMain> with TickerProviderStateMixin {
  DateTime today = DateTime.now();

  late AnimationController controller;

  bool isFrontView = true;
  switchView() {
    setState(() {
      if (isFrontView) {
        controller.forward();
      } else {
        controller.reverse();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    DataSaved().loadDate();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return UltraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: const Icon(
            Icons.auto_stories,
            size: 30,
          ),
          title: const Text(
            'Diary',
            style: TextStyle(
              fontSize: 32,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Expanded(
                  child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 38),
                child: PageView(
                  controller: PageController(
                    initialPage: 0,
                    viewportFraction: .9,
                  ),
                  scrollDirection: Axis.horizontal,
                  children: [
                    AnimatedBuilder(
                        animation: controller,
                        builder: (_, child) {
                          if (controller.value >= 0.5) {
                            isFrontView = false;
                          } else {
                            isFrontView = true;
                          }

                          return Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(controller.value * pi),
                            alignment: Alignment.center,
                            child: isFrontView
                                ? FrontView()
                                : Transform(
                                    transform: Matrix4.rotationY(pi),
                                    alignment: Alignment.center,
                                    child: BackView(
                                      today: today,
                                      chatManager: context.read<ChatManager>(),
                                    )),
                          );
                        }),
                  ],
                ),
              )),
              const SizedBox(
                height: 10,
              ),
              ActionButtons(change: switchView),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
