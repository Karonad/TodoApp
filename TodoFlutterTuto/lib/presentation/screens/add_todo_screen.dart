import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/cubit/add_todo_cubit.dart';
import 'package:todo_app/data/models/todo.dart';
import 'package:path/path.dart';

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
  XFile? image;
  return Column(
    children: [
      TextField(
          autofocus: true,
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter todo message",
          )),
      _image(context),
      InkWell(
          onTap: () async {
            image = await pickImage();
            if (image != null) {
              BlocProvider.of<AddTodoCubit>(context).addImage(image!);
            }
          },
          child: _addBtn(context, "Add Picture")),
      const SizedBox(
        height: 10.0,
      ),
      InkWell(
          onTap: () {
            final path = basename(image!.path);
            final body = Todo(controller.text, path, false);
            print(body);
            BlocProvider.of<AddTodoCubit>(context).addTodo(body, image!);
          },
          child: _addBtn(context, "Add Todo"))
    ],
  );
}

Widget _addBtn(context, message) {
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
        return Text(message, style: const TextStyle(color: Colors.white));
      },
    )),
  );
}

Widget _image(context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      child: Center(child: BlocBuilder<AddTodoCubit, AddTodoState>(
        builder: (context, state) {
          if (state is ImageAdded) {
            return Image.memory(state.image);
          }
          return const Text("ajoutez une image",
              style: TextStyle(color: Colors.white));
        },
      )),
    ),
  );
}

Future<XFile?> pickImage() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  return image;
}
