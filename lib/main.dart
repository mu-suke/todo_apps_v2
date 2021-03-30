// import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_apps_v2/todo_model.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewMyHomePage(),
    );
  }
}

final todosProvider = ChangeNotifierProvider((ref) => TodosNotifier());

class NewMyHomePage extends HookWidget {
  final _linearGradient = LinearGradient(
      colors: [Color(0xfffc00ff), Color(0xff00dbde)], stops: [0.0, 0.7]);
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final List<Todo> todos = [];
  final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final List<Todo> todos = useProvider(todosProvider).todos;

    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(DateTime.now());
    String time = timeOfDay.format(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('What to Do!'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: _linearGradient),
        ),
        leading: Icon(Icons.work),
        elevation: 0.0,
      ),
      backgroundColor: Colors.deepPurple,
      body: Container(
        decoration: BoxDecoration(gradient: _linearGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 70,
              child: Column(
                children: [
                  Text(
                    time,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    date,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )
                ],
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
                color: Color(0xffececec),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffececec),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(10, 10),
                                color: Colors.black38,
                                blurRadius: 20),
                            BoxShadow(
                                offset: Offset(-10, -10),
                                color: Colors.white.withOpacity(0.85),
                                blurRadius: 20),
                          ],
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.arrow_right,
                            color: Colors.blue,
                          ),
                          title: Text(
                            todos[index].title,
                            style: TextStyle(
                                decoration: todos[index].isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          ),
                          trailing: ButtonBar(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Tooltip(
                                  message: 'Done',
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.check_box,
                                        color: todos[index].isDone
                                            ? Colors.green
                                            : Colors.blue,
                                      ),
                                      onPressed: () {
                                        context
                                            .read(todosProvider)
                                            .switchDone(index);
                                      })),
                              Tooltip(
                                  message: 'Delete',
                                  child: IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        context
                                            .read(todosProvider)
                                            .removeTodo(index);
                                      })),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: todos.length,
                ),
              ),
            ))
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showTaskDialog(context);
        },
        tooltip: 'Add item to ToDo list',
        label: Text('Add'),
        backgroundColor: Color(0xfffc00ff),
        icon: Icon(Icons.add),
      ),
    );
  }

  void showTaskDialog(BuildContext context) {
    var alert = AlertDialog(
      title: Text('Today\'s list'),
      content: SizedBox(
        child: Form(
          key: _formKey,
          child: TextFormField(
            validator: (value) =>
                value.isEmpty ? 'Entry cannot be empty' : null,
            cursorColor: Colors.deepPurple,
            controller: _controller,
            decoration: InputDecoration(
                labelText: 'TODO',
                hintText: 'what to do today',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                prefixIcon: Icon(Icons.work)),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                context.read(todosProvider).addTodo(Todo(title: _controller.text, isDone: false));
                _controller.clear();
                Navigator.pop(context);
              }
            },
            child: Text('Add'))
      ],
    );
    showDialog(context: context, builder: (BuildContext builder) => alert);
  }
}
