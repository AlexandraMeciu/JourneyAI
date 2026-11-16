import 'package:flutter/material.dart';
import 'package:journal_app/screens/priorities_screen.dart';

class ActionButtons extends StatefulWidget {
  final Function change;
  const ActionButtons({super.key, required this.change});

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  bool isFront = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => PriorityScreen()));
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color.fromARGB(214, 124, 77, 255),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.note_alt_outlined,
                color: Colors.white,
                size: 27,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              widget.change();
              setState(() {
                isFront = !isFront;
              });
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color.fromARGB(214, 124, 77, 255),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFront ? Icons.calendar_month_rounded : Icons.undo_rounded,
                color: Colors.white,
                size: 27,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
