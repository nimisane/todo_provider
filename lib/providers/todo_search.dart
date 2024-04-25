// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_state_notifier/flutter_state_notifier.dart';

class TodoSearchState {
  final String searchTerm;
  TodoSearchState({
    required this.searchTerm,
  });

  factory TodoSearchState.initial() {
    return TodoSearchState(searchTerm: '');
  }

  @override
  String toString() => 'TodoSearchState(searchTerm: $searchTerm)';

  TodoSearchState copyWith({
    String? searchTerm,
  }) {
    return TodoSearchState(
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }
}

class TodoSearch extends StateNotifier<TodoSearchState> {


  TodoSearch():super(TodoSearchState.initial());

 

  void setSearchTerm(String searchTerm) {
    state = state.copyWith(searchTerm: searchTerm);

  }
}
