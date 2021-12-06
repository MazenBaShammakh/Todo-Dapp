import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../../models/todos_model.dart';
import './new_todo.dart';
import './todo_list_view.dart';
import 'filters.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({Key? key}) : super(key: key);

  static const routeName = '/todos';

  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  @override
  Widget build(BuildContext context) {
    final ethAddress = Provider.of<EthAddress>(
      context,
      listen: false,
    );
    // List<Todo> _todos = todoList.todosList;
    const sizedBox = SizedBox(height: kDefaultSpacing * 4);
    return ChangeNotifierProvider(
      create: (_) => TodoList(ethAddress.ethAddress),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            // print('tapped');
          },
          child: Container(
            padding: EdgeInsets.only(
              right: kDefaultSpacing * 4,
              left: kDefaultSpacing * 4,
              top: kDefaultSpacing * 6 + MediaQuery.of(context).viewPadding.top,
            ),
            width: double.infinity,
            height: double.infinity,
            decoration: decorationBodyContainer(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  title(),
                  sizedBox,
                  NewTodo(),
                  sizedBox,
                  TodoListView(),
                  sizedBox,
                  Filters(),
                  sizedBox,
                  dragDropNote(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container dragDropNote() {
    return Container(
      width: double.infinity,
      child: Text(
        'Drag and drop to reorder list',
        textAlign: TextAlign.center,
        style: GoogleFonts.josefinSans(
          color: kLightThemeDarkGrayishBlue,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  SizedBox title() {
    return SizedBox(
      width: double.infinity,
      child: Text(
        'todo'.toUpperCase(),
        textAlign: TextAlign.left,
        style: GoogleFonts.josefinSans(
          color: kLightThemeLightGrayishBlue,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: kDefaultSpacing,
        ),
      ),
    );
  }

  BoxDecoration decorationBodyContainer() {
    return BoxDecoration(
      color: kLightThemeLightGrayishBlue,
      image: DecorationImage(
        image: Image.asset('assets/images/bg-mobile-light.jpg').image,
        fit: BoxFit.contain,
        alignment: Alignment.topCenter,
      ),
    );
  }
}
