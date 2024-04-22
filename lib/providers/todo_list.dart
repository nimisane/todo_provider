// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../models/todo_model.dart';

class TodoListState extends Equatable {
  final List<Todo> todos;
  const TodoListState({
    required this.todos,
  });

  factory TodoListState.initial() {
    return TodoListState(todos: [
      Todo(id: "1", desc: "Read a book"),
      Todo(id: "2", desc: "Go for a walk"),
      Todo(id: "3", desc: "Study something new"),
    ]);
  }

  TodoListState copyWith({
    List<Todo>? todos,
  }) {
    return TodoListState(
      todos: todos ?? this.todos,
    );
  }

  @override
  String toString() => 'TodoListState(todo: $todos)';

  @override
  List<Object> get props => [todos];
}

class TodoList with ChangeNotifier {
  TodoListState _state = TodoListState.initial();

  TodoListState get state => _state;

  void addTodo(String todoDesc) {
    final newTodo = Todo(desc: todoDesc);

    final newTodos = [..._state.todos, newTodo];

    _state = _state.copyWith(
      todos: newTodos,
    );

    notifyListeners();
  }

  void editTodo(String id, String todoDesc) {
    final newTodos = _state.todos.map((Todo todo) {
      if (todo.id == id) {
        return Todo(id: id, desc: todoDesc, completed: todo.completed);
      }
      return todo;
    }).toList();

    _state = _state.copyWith(todos: newTodos);

    notifyListeners();
  }

  void toggleTodo(
    String id,
  ) {
    final newTodos = _state.todos.map((Todo todo) {
      if (todo.id == id) {
        return Todo(id: id, desc: todo.desc, completed: !todo.completed);
      }
      return todo;
    }).toList();

    _state = _state.copyWith(todos: newTodos);

    notifyListeners();
  }

  void removeTodo(String id) {
    final newTodos = _state.todos;

    newTodos.removeWhere((element) => element.id == id);

    _state = _state.copyWith(todos: newTodos);
    notifyListeners();
  }
}
