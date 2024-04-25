// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:todo_provider/providers/providers.dart';

import '../models/todo_model.dart';

class ActiveTodoCountState extends Equatable {
  final int activeTodoCount;
  const ActiveTodoCountState({
    required this.activeTodoCount,
  });

  factory ActiveTodoCountState.initial() {
    return const ActiveTodoCountState(activeTodoCount: 0);
  }

  @override
  String toString() =>
      'ActiveTodoCountState(activeTodoCount: $activeTodoCount)';

  ActiveTodoCountState copyWith({
    int? activeTodoCount,
  }) {
    return ActiveTodoCountState(
      activeTodoCount: activeTodoCount ?? this.activeTodoCount,
    );
  }

  @override
  List<Object> get props => [activeTodoCount];
}

class ActiveTodoCount extends StateNotifier<ActiveTodoCountState>
    with LocatorMixin {
  ActiveTodoCount() : super(ActiveTodoCountState.initial());

  @override
  void update(Locator watch) {
    final List<Todo> todoList = watch<TodoListState>().todos;

    state = state.copyWith(
        activeTodoCount:
            todoList.where((element) => !element.completed).toList().length);
    super.update(watch);
  }
  // final TodoList todoList;

  // ActiveTodoCount({required this.todoList});

  // ActiveTodoCountState get state => ActiveTodoCountState(
  //     activeTodoCount:
  //         todoList.state.todos.where((element) => !element.completed).toList().length);
}
