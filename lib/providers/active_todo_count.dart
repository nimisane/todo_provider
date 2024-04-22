// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:todo_provider/providers/todo_list.dart';

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

class ActiveTodoCount with ChangeNotifier {
  late ActiveTodoCountState _state; //= ActiveTodoCountState.initial();

  final int initialCount;
  ActiveTodoCount({
    required this.initialCount,
  }) {
    _state = ActiveTodoCountState(activeTodoCount: initialCount);
  }

  ActiveTodoCountState get state => _state;

  void update(TodoList todoList) {
    final int activeCount = todoList.state.todos
        .where((element) => !element.completed)
        .toList()
        .length;

    _state = _state.copyWith(activeTodoCount: activeCount);

    notifyListeners();
  }
}
