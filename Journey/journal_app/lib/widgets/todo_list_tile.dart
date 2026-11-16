import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:journal_app/utilities/app_colors.dart';

class ToDoListTile extends StatelessWidget {
  final String toDoListName;

  final Function()? onTap;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;
  final double? percent;

  const ToDoListTile(
      {super.key,
      required this.toDoListName,
      this.settingsTapped,
      this.deleteTapped,
      required this.onTap,
      this.percent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
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
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withAlpha(145),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    toDoListName,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                CircularProgressIndicator(
                  value: percent,
                  backgroundColor: Colors.grey,
                  valueColor: const AlwaysStoppedAnimation(
                    AppColors.primaryColor,
                  ),
                  strokeWidth: 4,
                  strokeAlign: 4,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
