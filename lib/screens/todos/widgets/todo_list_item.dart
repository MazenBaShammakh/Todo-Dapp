import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import '../../../models/todo_model.dart';
import '../../../models/todolist_model.dart';
import '../../../models/ethaddress_model.dart';

class TodoListItem extends StatefulWidget {
  const TodoListItem({
    Key? key,
    required this.todoList,
    required List<Todo> todos,
    required this.index,
  })  : _todos = todos,
        super(key: key);

  final TodoList todoList;
  final List<Todo> _todos;
  final int index;

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Consumer<Todo>(
        builder: (_, todo, ch) => GestureDetector(
          onTap: () => toggleCompletion(todo),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(64),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: widget._todos[widget.index].isCompleted
                    ? null
                    : Border.all(
                        width: .5,
                        color: kLightThemeDarkGrayishBlue,
                      ),
                borderRadius: BorderRadius.circular(64),
                gradient: widget._todos[widget.index].isCompleted
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
              child: widget._todos[widget.index].isCompleted
                  ? Padding(
                      padding: const EdgeInsets.all(4),
                      child: SvgPicture.asset(
                        'assets/images/icon-check.svg',
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
      title: Text(
        widget._todos[widget.index].title,
        style: GoogleFonts.josefinSans(
          fontWeight: FontWeight.w700,
          height: 1.25,
          decoration: widget._todos[widget.index].isCompleted
              ? TextDecoration.lineThrough
              : null,
          decorationColor: kLightThemeDarkGrayishBlue,
          color: widget._todos[widget.index].isCompleted
              ? kLightThemeDarkGrayishBlue
              : null,
        ),
      ),
      trailing: Consumer<Todo>(
        builder: (_, todo, ch) => IconButton(
          onPressed: () => deleteTodo(todo),
          icon: SvgPicture.asset(
            'assets/images/icon-cross.svg',
          ),
          padding: const EdgeInsets.all(0),
        ),
      ),
    );
  }

  void deleteTodo(Todo todo) {
    final ethAddress = Provider.of<EthAddress>(context, listen: false);
    widget.todoList.deleteTodoFunc(
      ethAddress.cred,
      ethAddress.ethAddress,
      BigInt.from(todo.id),
    );

    widget._todos.removeWhere((td) => td.id == todo.id);
  }

  void toggleCompletion(Todo todo) {
    final ethAddress = Provider.of<EthAddress>(context, listen: false);
    widget.todoList.toggleIsCompletedFunc(
        ethAddress.cred, ethAddress.ethAddress, BigInt.from(todo.id));
    setState(() {
      widget._todos[widget.index].isCompleted =
          !widget._todos[widget.index].isCompleted;
    });
  }
}
