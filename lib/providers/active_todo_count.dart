// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:todo_provider/providers/providers.dart';

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

class ActiveTodoCount {
  final TodoList todoList;

  ActiveTodoCount({required this.todoList});

  ActiveTodoCountState get state => ActiveTodoCountState(
      activeTodoCount:
          todoList.state.todos.where((element) => !element.completed).toList().length);
}
