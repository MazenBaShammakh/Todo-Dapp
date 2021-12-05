import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import './constants.dart';
import './todos_model.dart';

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
    // print(todoList.todosCounter);
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
                : todoList.todosCounter == 0
                    ? Padding(
                        padding: const EdgeInsets.all(kDefaultSpacing * 4),
                        child: Center(
                          child: SvgPicture.asset(
                              'assets/images/illustration-todo.svg'),
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _todos.length,
                        itemBuilder: (_, index) => ChangeNotifierProvider(
                          create: (_) => Todo(
                            id: _todos[index].id,
                            title: _todos[index].title,
                            isCompleted: _todos[index].isCompleted,
                          ),
                          child: ListTile(
                            leading: Consumer<Todo>(
                              builder: (_, todo, ch) => GestureDetector(
                                onTap: () {
                                  todoList.toggleIsCompletedFunc(
                                      BigInt.from(todo.id));
                                  setState(() {
                                    _todos[index].isCompleted =
                                        !_todos[index].isCompleted;
                                  });
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(64),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      border: _todos[index].isCompleted
                                          ? null
                                          : Border.all(
                                              width: .5,
                                              color: kLightThemeDarkGrayishBlue,
                                            ),
                                      borderRadius: BorderRadius.circular(64),
                                      gradient: _todos[index].isCompleted
                                          ? const LinearGradient(
                                              colors: [
                                                kLinearBlue,
                                                kLinearPurple,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                          : null,
                                    ),
                                    child: _todos[index].isCompleted
                                        ? Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: SvgPicture.asset(
                                              'assets/images/icon-check.svg',
                                            ),
                                          )
                                        // ? const Icon(
                                        //     Icons.done,
                                        //     size: 16,
                                        //     color: kLightThemeLightGrayishBlue,
                                        //   )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              _todos[index].title,
                              style: GoogleFonts.josefinSans(
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                                decoration: _todos[index].isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationColor: kLightThemeDarkGrayishBlue,
                                color: _todos[index].isCompleted
                                    ? kLightThemeDarkGrayishBlue
                                    : null,
                              ),
                            ),
                            trailing: Consumer<Todo>(
                              builder: (_, todo, ch) => IconButton(
                                onPressed: () {
                                  todoList.deleteTodoFunc(
                                    BigInt.from(todo.id),
                                  );
                                  setState(() {
                                    _todos
                                        .removeWhere((td) => td.id == todo.id);
                                  });
                                },
                                icon: SvgPicture.asset(
                                  'assets/images/icon-cross.svg',
                                ),
                                padding: const EdgeInsets.all(0),
                              ),
                            ),
                          ),
                        ),
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(kDefaultSpacing * 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${incompleteTodosCount(filterTodos(todoList.todosList, 0) as List<Todo>)} items left',
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
          ),
        ],
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
