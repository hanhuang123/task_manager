import 'package:flutter/material.dart';
import 'package:todo/features/task/widgets/task_tile.dart';
import 'package:todo/models/task.dart';

class ListTask extends StatelessWidget {
  final List<Task> tasks;
  final void Function(String id, bool value)? onCheckBoxTap;
  final void Function(String taskId)? onDeleteTap;

  const ListTask({
    Key? key,
    required this.tasks,
    this.onCheckBoxTap,
    this.onDeleteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskTile(
          key: UniqueKey(),
          task: task,
          onCheckBoxTap: (value) => onCheckBoxTap?.call(task.id, value),
          onDeleteTap: () => onDeleteTap?.call(task.id),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 4.0),
      itemCount: tasks.length,
    );
  }
}

