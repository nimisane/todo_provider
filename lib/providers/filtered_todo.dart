// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:todo_provider/providers/todo_filter.dart';
import 'package:todo_provider/providers/todo_list.dart';
import 'package:todo_provider/providers/todo_search.dart';

import '../models/todo_model.dart';

class FilteredTodoState extends Equatable {
  final List<Todo> filteredTodos;
  const FilteredTodoState({
    required this.filteredTodos,
  });

  factory FilteredTodoState.initial() {
    return const FilteredTodoState(filteredTodos: []);
  }

  @override
  String toString() => 'FilteredTodoState(filteredTodos: $filteredTodos)';

  FilteredTodoState copyWith({
    List<Todo>? filteredTodos,
  }) {
    return FilteredTodoState(
      filteredTodos: filteredTodos ?? this.filteredTodos,
    );
  }

  @override
  List<Object> get props => [filteredTodos];
}

class FilteredTodos with ChangeNotifier {
  late FilteredTodoState _state; //= FilteredTodoState.initial();

  FilteredTodoState get state => _state;

  final List<Todo> todoList;
  FilteredTodos({
    required this.todoList,
  }) {
    _state = FilteredTodoState(filteredTodos: todoList);
  }

  void updateTodos(
      {required TodoFilter todoFilter,
      required TodoSearch todoSearch,
      required TodoList todoList}) {
    // ignore: no_leading_underscores_for_local_identifiers
    List<Todo> _filteredTodo = [];

    switch (todoFilter.state.filter) {
      case Filter.active:
        _filteredTodo = todoList.state.todos
            .where((Todo element) => !element.completed)
            .toList();

      case Filter.completed:
        _filteredTodo = todoList.state.todos
            .where((Todo element) => element.completed)
            .toList();

      case Filter.all:
      default:
        _filteredTodo = todoList.state.todos;
    }

    if (todoSearch.state.searchTerm.isNotEmpty) {
      _filteredTodo = todoList.state.todos
          .where((Todo element) => element.desc
              .toLowerCase()
              .contains(todoSearch.state.searchTerm.toLowerCase()))
          .toList();
    }

    _state = _state.copyWith(filteredTodos: _filteredTodo);
    notifyListeners();
  }
}
