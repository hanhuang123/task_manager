import 'package:flutter/material.dart';
import 'package:todo/gen/colors.gen.dart';
import 'package:todo/models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final void Function(bool value)? onCheckBoxTap;
  final void Function()? onDeleteTap; // 修改刪除按鈕的回呼函式類型

  const TaskTile({
    Key? key,
    required this.task,
    this.onCheckBoxTap,
    this.onDeleteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 16.0, 12.0),
      decoration: BoxDecoration(
        color: ColorName.card,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.0,
            child: Checkbox(
              value: task.isDone,
              activeColor: ColorName.primary,
              checkColor: ColorName.background,
              side: const BorderSide(width: 2.0, color: ColorName.secondaryText),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const CircleBorder(),
              onChanged: (value) => onCheckBoxTap?.call(value ?? false),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              task.content,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDeleteTap,
          ),
        ],
      ),
    );
  }
}
