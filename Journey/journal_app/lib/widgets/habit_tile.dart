import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;

  const HabitTile(
      {super.key,
      required this.habitName,
      required this.habitCompleted,
      this.onChanged,
      this.settingsTapped,
      this.deleteTapped});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SizedBox(
              width: 7,
            ),
            CustomSlidableAction(
              onPressed: settingsTapped,
              backgroundColor: Colors.blueGrey.withAlpha(145),
              borderRadius: BorderRadius.circular(12),
              child: Icon(
                Icons.drive_file_rename_outline,
                size: 28,
              ),
            ),
            SizedBox(
              width: 7,
            ),
            CustomSlidableAction(
              onPressed: deleteTapped,
              backgroundColor: Colors.blueGrey.withAlpha(145),
              borderRadius: BorderRadius.circular(12),
              child: Icon(
                Icons.delete,
                size: 28,
                color: Colors.redAccent,
              ),
            )
          ],
        ),
        child: GestureDetector(
          onTap: () {
            onChanged?.call(!habitCompleted);
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withAlpha(145),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Checkbox(value: habitCompleted, onChanged: onChanged),
                Flexible(
                  child: Text(
                    habitName,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
