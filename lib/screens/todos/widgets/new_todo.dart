import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/todolist_model.dart';
import '../../../models/ethaddress_model.dart';

class NewTodo extends StatefulWidget {
  const NewTodo({
    Key? key,
  }) : super(key: key);

  @override
  State<NewTodo> createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  final TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultSpacing),
        color: kLightThemeVeryLightGrayishBlue,
      ),
      child: Row(
        children: [
          const SizedBox(width: kDefaultSpacing),
          Expanded(
            child: TextField(
              controller: _todoController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                hintText: 'Creat a new todo..',
                hintStyle: GoogleFonts.josefinSans(
                  fontSize: 18,
                ),
                contentPadding: const EdgeInsets.all(0),
              ),
              style: GoogleFonts.josefinSans(
                fontSize: 18,
              ),
            ),
          ),
          IconButton(
            onPressed: _addTodo,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _addTodo() {
    final todoList = Provider.of<TodoList>(context, listen: false);
    final ethAddress = Provider.of<EthAddress>(context, listen: false);
    todoList.addTodo(
        ethAddress.cred, ethAddress.ethAddress, _todoController.text);
    _todoController.clear();
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
