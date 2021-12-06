import 'package:flutter/material.dart';

class Todo extends ChangeNotifier {
  final int id;
  final String title;
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.isCompleted,
  });
}
