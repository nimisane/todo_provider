// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:state_notifier/state_notifier.dart';
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

class FilteredTodos extends StateNotifier<FilteredTodoState> with LocatorMixin {
  // final TodoFilter todoFilter;
  // final TodoSearch todoSearch;
  // final TodoList todoList;
  // FilteredTodos({
  //   required this.todoFilter,
  //   required this.todoSearch,
  //   required this.todoList,
  // });
  FilteredTodos() : super(FilteredTodoState.initial());

  @override
  void update(Locator watch) {
    List<Todo> _filteredTodo = [];

    final Filter todoFilter = watch<TodoFilterState>().filter;
    final String todoSearch = watch<TodoSearchState>().searchTerm;
    final List<Todo> todoList = watch<TodoListState>().todos;

    switch (todoFilter) {
      case Filter.active:
        _filteredTodo =
            todoList.where((Todo element) => !element.completed).toList();

      case Filter.completed:
        _filteredTodo =
            todoList.where((Todo element) => element.completed).toList();

      case Filter.all:
      default:
        _filteredTodo = todoList;
    }

    if (todoSearch.isNotEmpty) {
      _filteredTodo = todoList
          .where((Todo element) =>
              element.desc.toLowerCase().contains(todoSearch.toLowerCase()))
          .toList();
    }

    state = state.copyWith(filteredTodos: _filteredTodo);

    super.update(watch);
  }

  // FilteredTodoState get state {
  //   // ignore: no_leading_underscores_for_local_identifiers
  //   List<Todo> _filteredTodo = [];

  //   switch (todoFilter.state.filter) {
  //     case Filter.active:
  //       _filteredTodo = todoList.state.todos
  //           .where((Todo element) => !element.completed)
  //           .toList();

  //     case Filter.completed:
  //       _filteredTodo = todoList.state.todos
  //           .where((Todo element) => element.completed)
  //           .toList();

  //     case Filter.all:
  //     default:
  //       _filteredTodo = todoList.state.todos;
  //   }

  //   if (todoSearch.state.searchTerm.isNotEmpty) {
  //     _filteredTodo = todoList.state.todos
  //         .where((Todo element) => element.desc
  //             .toLowerCase()
  //             .contains(todoSearch.state.searchTerm.toLowerCase()))
  //         .toList();
  //   }

  //   return FilteredTodoState(filteredTodos: _filteredTodo);
  // }
}
