import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:todo/models/task.dart';
import 'package:todo/repos/task/task_repository.dart';
import 'package:uuid/uuid.dart';

part 'task_event.dart';
part 'task_state.dart';

class AllTaskBloc extends TaskBloc {
  AllTaskBloc({required ITaskRepository taskRepository})
      : super(taskRepository: taskRepository);
}

class CompleteTaskBloc extends TaskBloc {
  CompleteTaskBloc({required ITaskRepository taskRepository})
      : super(taskRepository: taskRepository);
}

class IncompleteTaskBloc extends TaskBloc {
  IncompleteTaskBloc({required ITaskRepository taskRepository})
      : super(taskRepository: taskRepository);
}

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final ITaskRepository _taskRepository;

  TaskBloc({required ITaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(const TaskInitial()) {
    on<TaskFetched>(_onTaskFetched);
    on<TaskCreated>(_onTaskCreated);
    on<TaskUpdated>(_onTaskUpdated);
    on<TaskDeleted>(_onTaskDeleted);
  }

  Future<void> _onTaskFetched(TaskFetched event, Emitter<TaskState> emit) async {
    emit(const TaskFetchedInProgress());

    final result = await _taskRepository.getTasks(isDone: event.isDone);

    result.when(
      success: (tasks) {
        tasks.sort(
              (a, b) {
            if (a.createdAt != null && b.createdAt != null) {
              return b.createdAt!.compareTo(a.createdAt!);
            }
            return 0;
          },
        );
        emit(TaskFetchedSuccess(tasks: tasks));
      },
      failure: (failure) => emit(TaskFetchedFailure(message: failure.message)),
    );
  }

  Future<void> _onTaskCreated(TaskCreated event, Emitter<TaskState> emit) async {
    emit(const TaskCreatedInProgress());

    final task = Task(
      id: const Uuid().v1(),
      content: event.content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await _taskRepository.createTask(task: task);

    result.when(
      success: (success) => emit(TaskCreatedSuccess(task: success)),
      failure: (failure) => emit(TaskCreatedFailure(message: failure.message)),
    );
  }

  Future<void> _onTaskUpdated(TaskUpdated event, Emitter<TaskState> emit) async {
    emit(const TaskUpdatedInProgress());

    final getTaskResult = await _taskRepository.getTask(id: event.id);

    await getTaskResult.when(
      success: (task) async {
        final updatedTask = task.copyWith(
          content: event.content,
          isDone: event.isDone,
          updatedAt: DateTime.now(),
        );

        final updateTaskResult = await _taskRepository.updateTask(task: updatedTask);

        updateTaskResult.when(
          success: (success) => emit(TaskUpdatedSuccess(task: success)),
          failure: (updateTaskFailure) => emit(TaskUpdatedFailure(message: updateTaskFailure.message)),
        );
      },
      failure: (getTaskFailure) {
        emit(TaskUpdatedFailure(message: getTaskFailure.message));
      },
    );
  }

  Future<void> _onTaskDeleted(TaskDeleted event, Emitter<TaskState> emit) async {
    emit(const TaskDeletedInProgress());

    final deleteTaskResult = await _taskRepository.deleteTask(id: event.taskId);

    deleteTaskResult.when(
      success: (_) => emit(const TaskDeletedSuccess()),
      failure: (failure) => emit(TaskDeletedFailure(message: failure.message)),
    );
  }

}
