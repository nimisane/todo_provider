// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:flutter_state_notifier/flutter_state_notifier.dart';

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

class TodoList extends StateNotifier<TodoListState> {
  

  TodoList():super(TodoListState.initial());

 

  void addTodo(String todoDesc) {
    final newTodo = Todo(desc: todoDesc);

    final newTodos = [...state.todos, newTodo];

    state = state.copyWith(
      todos: newTodos,
    );

 
  }

  void editTodo(String id, String todoDesc) {
    final newTodos = state.todos.map((Todo todo) {
      if (todo.id == id) {
        return Todo(id: id, desc: todoDesc, completed: todo.completed);
      }
      return todo;
    }).toList();

    state = state.copyWith(todos: newTodos);

  
  }

  void toggleTodo(
    String id,
  ) {
    final newTodos = state.todos.map((Todo todo) {
      if (todo.id == id) {
        return Todo(id: id, desc: todo.desc, completed: !todo.completed);
      }
      return todo;
    }).toList();

    state = state.copyWith(todos: newTodos);

   
  }

  void removeTodo(Todo todo) {
    // final newTodos = state.todos;

    // newTodos.removeWhere((element) => element.id == id);

    // state = state.copyWith(todos: newTodos);

    final newTodos = state.todos.where((Todo t) => t.id != todo.id).toList();

    state = state.copyWith(todos: newTodos);
 
  }
}
