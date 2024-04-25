// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:flutter_state_notifier/flutter_state_notifier.dart';

import 'package:todo_provider/models/todo_model.dart';

class TodoFilterState extends Equatable {
  final Filter filter;

  const TodoFilterState({required this.filter});

  factory TodoFilterState.initial() {
    return const TodoFilterState(filter: Filter.all);
  }

  TodoFilterState copyWith({
    Filter? filter,
  }) {
    return TodoFilterState(
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object> get props => [filter];

  @override
  bool get stringify => true;
}

class TodoFilter extends StateNotifier<TodoFilterState> {
 

  TodoFilter():super(TodoFilterState.initial());

  

  void changeFilter(Filter newFilter) {
    state = state.copyWith(filter: newFilter);


  }
}
