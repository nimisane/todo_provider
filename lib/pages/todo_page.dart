import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider/models/todo_model.dart';
import 'package:todo_provider/providers/providers.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              TodoHeader(),
              CreateTodo(),
              SizedBox(
                height: 20,
              ),
              SearchAndFilterTodo(),
            ],
          ),
        ),
      ),
    );
  }
}

class TodoHeader extends StatelessWidget {
  const TodoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Todo",
          style: TextStyle(fontSize: 40),
        ),
        Text(
          "${context.watch<ActiveTodoCountState>().activeTodoCount} itmes left",
          style: const TextStyle(fontSize: 20, color: Colors.redAccent),
        ),
      ],
    );
  }
}

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: const InputDecoration(
        labelText: "What to do?",
      ),
      onSubmitted: (String? value) {
        if (value != null && value.trim().isNotEmpty) {
          context.read<TodoList>().addTodo(value);
          textEditingController.clear();
        }
      },
    );
  }
}

class SearchAndFilterTodo extends StatelessWidget {
  const SearchAndFilterTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: "Search todos",
            border: InputBorder.none,
            filled: true,
            prefix: Icon(Icons.search),
          ),
          onChanged: (String value) {
            Future.delayed(const Duration(milliseconds: 500), () {
              context.read<TodoSearch>().setSearchTerm(value);
            });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            filterButton(context, Filter.all),
            filterButton(context, Filter.active),
            filterButton(context, Filter.completed),
          ],
        ),
        const ShowTodos()
      ],
    );
  }

  Widget filterButton(BuildContext context, Filter filter) {
    return TextButton(
      onPressed: () {
        context.read<TodoFilter>().changeFilter(filter);
      },
      child: Text(
        filter == Filter.all
            ? "All"
            : filter == Filter.active
                ? "Active"
                : "Completed",
        style: TextStyle(
          fontSize: 18,
          color: textColor(context, filter),
        ),
      ),
    );
  }

  Color textColor(BuildContext context, Filter filter) {
    final currentFilter = context.watch<TodoFilterState>().filter;

    return currentFilter == filter ? Colors.blue : Colors.grey;
  }
}

class ShowTodos extends StatelessWidget {
  const ShowTodos({super.key});

  Widget showBackground(int direction) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      color: Colors.red,
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<FilteredTodoState>().filteredTodos;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: todos.length,
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.grey,
        );
      },
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(todos[index].id),
          background: showBackground(0),
          secondaryBackground: showBackground(1),
          onDismissed: (_) {
            context.read<TodoList>().removeTodo(todos[index]);
          },
          confirmDismiss: (direction) {
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Are you sure?"),
                    content: const Text("Do you really want to delete?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  );
                });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TodoItem(
              todos: todos[index],
            ),
          ),
        );
      },
    );
  }
}

class TodoItem extends StatefulWidget {
  final Todo todos;
  const TodoItem({super.key, required this.todos});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.text = widget.todos.desc;

    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              // ignore: no_leading_underscores_for_local_identifiers
              bool _error = false;
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: const Text("Edit Todo"),
                  content: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                        errorText: _error ? "Value cannot be empty" : null),
                    controller: textEditingController,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        if (textEditingController.text.isNotEmpty) {
                          setState(() {
                            _error = false;
                          });
                          context.read<TodoList>().editTodo(
                              widget.todos.id, textEditingController.text);
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            _error = true;
                          });
                        }
                      },
                      child: const Text("Submit"),
                    ),
                  ],
                );
              });
            });
      },
      leading: Checkbox(
        value: widget.todos.completed,
        onChanged: (value) {
          context.read<TodoList>().toggleTodo(widget.todos.id);
        },
      ),
      title: Text(widget.todos.desc),
    );
  }
}
