import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './constants.dart';
import './todos_model.dart';

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
          TextButton(
            onPressed: () {
              setState(() {
                _todoList.updateFilter(0);
              });
            },
            child: const Text('All'),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                  _todoList.filter == 0
                      ? materialColor.shade900
                      : kLightThemeDarkGrayishBlue),
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _todoList.updateFilter(1);
              });
            },
            child: const Text('Active'),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                  _todoList.filter == 1
                      ? materialColor.shade900
                      : kLightThemeDarkGrayishBlue),
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _todoList.updateFilter(2);
              });
            },
            child: const Text('Completed'),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                  _todoList.filter == 2
                      ? materialColor.shade900
                      : kLightThemeDarkGrayishBlue),
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}
