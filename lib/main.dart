import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './constants.dart';
import './auth_screen.dart';
import './todos_screen.dart';
import './todos_model.dart';

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
        // home: const TodosScreen(),
        initialRoute: AuthScreen.routeName,
        routes: {
          AuthScreen.routeName: (_) => const AuthScreen(),
          TodosScreen.routeName: (_) => const TodosScreen(),
        },
      ),
    );
  }
}
