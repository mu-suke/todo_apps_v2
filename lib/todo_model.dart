import 'package:flutter/material.dart';

class Todo {
  String title;
  bool isDone;
  Todo({this.title, this.isDone});
}



class TodosNotifier with ChangeNotifier {
  List<Todo> _todos = [];
  List<Todo> get todos => _todos;
  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void removeTodo(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }

  void switchDone(int index) {
    _todos[index].isDone = !_todos[index].isDone;
    notifyListeners();
  }
}