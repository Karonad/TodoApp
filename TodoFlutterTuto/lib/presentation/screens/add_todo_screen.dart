import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/cubit/add_todo_cubit.dart';

class AddTodoScreen extends StatelessWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add todo"),
        ),
        body: BlocListener<AddTodoCubit, AddTodoState>(
          listener: (context, state) {
            if (state is TodoAdded) {
              Navigator.pop(context);
              return;
            } else if (state is AddTodoError) {
              Fluttertoast.showToast(
                msg: state.error,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red,
                gravity: ToastGravity.CENTER,
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: _body(context),
          ),
        ));
  }
}

Widget _body(context) {
  final controller = TextEditingController();
  return Column(
    children: [
      TextField(
          autofocus: true,
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter todo message",
          )),
      const SizedBox(
        height: 10.0,
      ),
      InkWell(
          onTap: () {
            final message = controller.text;
            BlocProvider.of<AddTodoCubit>(context).addTodo(message);
          },
          child: _addBtn(context))
    ],
  );
}

Widget _addBtn(context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50.0,
    decoration: BoxDecoration(
        color: Colors.black, borderRadius: BorderRadius.circular(10.0)),
    child: Center(child: BlocBuilder<AddTodoCubit, AddTodoState>(
      builder: (context, state) {
        if (state is AddingTodo) {
          return const CircularProgressIndicator();
        }
        return const Text("Add todo", style: TextStyle(color: Colors.white));
      },
    )),
  );
}
