import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginScreen({Key? key}) : super(key: key);

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text("Log In")),
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoggedIn) {
            Navigator.pushNamed(context, '/');
            return;
          } else if (state is LoginError) {
            Fluttertoast.showToast(
              msg: state.error,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.red,
              gravity: ToastGravity.CENTER,
            );
          }
        },
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              InkWell(
                  onTap: () {
                    var username = _usernameController.text;
                    var password = _passwordController.text;
                    BlocProvider.of<LoginCubit>(context)
                        .login(username, password);
                  },
                  child: _button(context, "sign in")),
              InkWell(
                  onTap: () {
                    var username = _usernameController.text;
                    var password = _passwordController.text;
                    BlocProvider.of<LoginCubit>(context)
                        .signIn(username, password);
                  },
                  child: _button(context, "sign up"))
            ])),
      ));
}

Widget _button(context, String text) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50.0,
    decoration: BoxDecoration(
        color: Colors.black, borderRadius: BorderRadius.circular(10.0)),
    child: Center(child: BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        if (state is LoggingIn) {
          return const CircularProgressIndicator();
        }
        return Text(text, style: const TextStyle(color: Colors.white));
      },
    )),
  );
}
