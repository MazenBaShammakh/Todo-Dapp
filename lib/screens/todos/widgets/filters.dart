import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/todolist_model.dart';

class Filters extends StatefulWidget {
  const Filters({
    Key? key,
  }) : super(key: key);

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  @override
  Widget build(BuildContext context) {
    final _todoList = Provider.of<TodoList>(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultSpacing),
        color: kLightThemeVeryLightGrayishBlue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          filterButton(_todoList, 'All', 0),
          filterButton(_todoList, 'Active', 1),
          filterButton(_todoList, 'Completed', 2),
        ],
      ),
    );
  }

  TextButton filterButton(TodoList _todoList, String title, int _filterId) {
    return TextButton(
      onPressed: () {
        setState(() {
          _todoList.updateFilter(_filterId);
        });
      },
      child: Text(title),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(
            _todoList.filter == _filterId
                ? materialColor.shade900
                : kLightThemeDarkGrayishBlue),
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
    );
  }
}
