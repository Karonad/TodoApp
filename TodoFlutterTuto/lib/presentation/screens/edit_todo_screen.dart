import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/cubit/edit_todo_cubit.dart';
import 'package:todo_app/data/models/todo.dart';

class EditTodoList extends StatelessWidget {
  final Todo todo;
  final controller = TextEditingController();

  EditTodoList({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.text = todo.todoMessage;
    return BlocListener<EditTodoCubit, EditTodoState>(
      listener: (context, state) {
        if (state is TodoEdited) {
          Navigator.pop(context);
        } else if (state is EditTodoError) {
          Fluttertoast.showToast(
            msg: state.error,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER,
          );
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Edit Todo"),
            actions: [
              InkWell(
                onTap: () {
                  BlocProvider.of<EditTodoCubit>(context).deleteTodo(todo);
                },
                child: const Padding(
                    padding: EdgeInsets.all(10.0), child: Icon(Icons.delete)),
              )
            ],
          ),
          body: _body(context, controller, todo)),
    );
  }
}

Widget _body(context, controller, todo) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      children: [
        TextField(
          controller: controller,
          autocorrect: true,
          decoration: const InputDecoration(hintText: "Enter todo message..."),
        ),
        const SizedBox(
          height: 10.0,
        ),
        InkWell(
            onTap: () {
              BlocProvider.of<EditTodoCubit>(context)
                  .updateTodo(todo, controller.text);
            },
            child: _updateBtn(context))
      ],
    ),
  );
}

Widget _updateBtn(context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50.0,
    decoration: BoxDecoration(
        color: Colors.black, borderRadius: BorderRadius.circular(10.0)),
    child: const Center(
      child: Text(
        "Update Todo",
        style: TextStyle(fontSize: 15.0, color: Colors.white),
      ),
    ),
  );
}
