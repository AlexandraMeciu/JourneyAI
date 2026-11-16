import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String todoName;
  final bool? todoComplete;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;

  const ToDoTile(
      {super.key,
      required this.todoName,
      required this.todoComplete,
      this.onChanged,
      this.settingsTapped,
      this.deleteTapped});

  bool checkBox() {
    bool? checkStatus = todoComplete;
    if (checkStatus != null) {
      return checkStatus;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
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
            onChanged?.call(!(todoComplete ?? false));
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withAlpha(145),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Checkbox(value: todoComplete, onChanged: onChanged),
                Flexible(
                  child: Text(
                    todoName,
                    style: TextStyle(
                      fontSize: 20,
                      decoration: checkBox()
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
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
