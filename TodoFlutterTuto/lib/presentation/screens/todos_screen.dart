import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app/constants/strings.dart';
import 'package:todo_app/cubit/todoscubit_cubit.dart';
import 'package:todo_app/data/models/screen_arguments.dart';
import 'package:todo_app/data/models/todo.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TodoscubitCubit>(context).fetchTodos();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Todos"),
          actions: [
            InkWell(
              onTap: () => Navigator.pushNamed(context, addTodoRoute),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
        body: BlocBuilder<TodoscubitCubit, TodoscubitState>(
          builder: (context, state) {
            if (state is! TodosLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            final todos = (state).todos;
            return SingleChildScrollView(
              child: Column(
                children: todos.map((e) => _todo(e, context)).toList(),
              ),
            );
          },
        ));
  }
}

Widget _todo(Todo todo, context) {
  final storage = GetStorage();
  return InkWell(
    onTap: () => Navigator.pushNamed(context, editTodoRoute,
        arguments: ScreenArguments(
          todo,
          storage.read("user"),
        )),
    child: Dismissible(
      key: Key("${todo.id}"),
      child: _todoTile(todo, context),
      confirmDismiss: (_) async {
        BlocProvider.of<TodoscubitCubit>(context).changeCompletion(todo);
        return false;
      },
      background: Container(
        color: Colors.indigo,
      ),
    ),
  );
}

Widget _todoTile(Todo todo, context) {
  return Column(children: [
    todo.image != null
        ? SizedBox(
            height: 100,
            child: Image.network('http://localhost:3001/images/' + todo.image!))
        : const Text("pas d'image disponible"),
    Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(todo.todoMessage), _completionIndicator(todo)],
      ),
    )
  ]);
}

Widget _completionIndicator(Todo todo) {
  return Container(
    width: 20.0,
    height: 20.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(
            width: 4.0, color: todo.isCompleted ? Colors.green : Colors.red)),
  );
}
