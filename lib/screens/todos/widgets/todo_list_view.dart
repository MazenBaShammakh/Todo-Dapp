import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import '../../../models/todo_model.dart';
import '../../../models/todolist_model.dart';
import './todo_list_item.dart';

class TodoListView extends StatefulWidget {
  const TodoListView({
    Key? key,
  }) : super(key: key);

  @override
  State<TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  @override
  Widget build(BuildContext context) {
    final todoList = Provider.of<TodoList>(context);
    List<Todo> _todos =
        filterTodos(todoList.todosList, todoList.filter) as List<Todo>;
    // print(_todos.length);
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * .5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultSpacing),
        color: kLightThemeVeryLightGrayishBlue,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: todoList.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                // : todoList.todosCounter == 0
                : _todos.isEmpty
                    ? illustrationPlaceholder()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _todos.length,
                        itemBuilder: (_, index) => ChangeNotifierProvider(
                          create: (_) => Todo(
                            id: _todos[index].id,
                            title: _todos[index].title,
                            isCompleted: _todos[index].isCompleted,
                          ),
                          child: TodoListItem(
                            todoList: todoList,
                            todos: _todos,
                            index: index,
                          ),
                        ),
                      ),
          ),
          listInfo(todoList),
        ],
      ),
    );
  }

  Padding listInfo(TodoList todoList) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultSpacing * 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${incompleteTodosCount(filterTodos(todoList.todosList, 0) as List<Todo>)} todos left',
            style: GoogleFonts.josefinSans(
              color: kLightThemeDarkGrayishBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
          // Text(
          //   'Clear Completed',
          //   style: GoogleFonts.josefinSans(
          //     color: kLightThemeDarkGrayishBlue,
          //     fontWeight: FontWeight.w700,
          //   ),
          // ),
        ],
      ),
    );
  }

  Padding illustrationPlaceholder() {
    return Padding(
      padding: const EdgeInsets.all(kDefaultSpacing * 4),
      child: Center(
        child: SvgPicture.asset('assets/images/illustration-todo.svg'),
      ),
    );
  }

  List<Todo>? filterTodos(List<Todo> todos, int filter) {
    if (filter == 0) {
      // print('filter 0');
      return todos;
    } else if (filter == 1) {
      // print('filter 1');
      return todos.where((todo) => !todo.isCompleted).toList();
    } else if (filter == 2) {
      // print('filter 2');
      return todos.where((todo) => todo.isCompleted).toList();
    }
    return null;
  }

  int incompleteTodosCount(List<Todo> todos) {
    int count = todos.where((todo) => !todo.isCompleted).length;
    return count;
  }
}
