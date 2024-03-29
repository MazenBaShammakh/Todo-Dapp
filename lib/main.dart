import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './constants.dart';
import 'screens/auth/auth_screen.dart';
import './screens/todos/todos_screen.dart';
import 'models/ethaddress_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EthAddress(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todos',
        theme: ThemeData(
          primarySwatch: materialColor,
        ),
        initialRoute: AuthScreen.routeName,
        routes: {
          AuthScreen.routeName: (_) => const AuthScreen(),
          TodosScreen.routeName: (_) => const TodosScreen(),
        },
      ),
    );
  }
}
