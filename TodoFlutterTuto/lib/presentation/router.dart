import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/constants/strings.dart';
import 'package:todo_app/cubit/add_todo_cubit.dart';
import 'package:todo_app/cubit/edit_todo_cubit.dart';
import 'package:todo_app/cubit/login_cubit.dart';
import 'package:todo_app/cubit/todoscubit_cubit.dart';
import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/data/network_service.dart';
import 'package:todo_app/data/repository.dart';
import 'package:todo_app/presentation/screens/add_todo_screen.dart';
import 'package:todo_app/presentation/screens/edit_todo_screen.dart';
import 'package:todo_app/presentation/screens/login_screen.dart';
import 'package:todo_app/presentation/screens/todos_screen.dart';

class AppRouter {
  late Repository repository;
  late TodoscubitCubit todoscubitCubit;

  AppRouter() {
    repository = Repository(networkService: NetworkService());
    todoscubitCubit = TodoscubitCubit(repository: repository);
  }

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: todoscubitCubit, child: const TodosScreen()));
      case loginRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (BuildContext context) =>
                    LoginCubit(repository: repository),
                child: LoginScreen()));
      case editTodoRoute:
        final todo = settings.arguments as Todo;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (BuildContext context) => EditTodoCubit(
                    repository: repository, todoscubitCubit: todoscubitCubit),
                child: EditTodoList(
                  todo: todo,
                )));
      case addTodoRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (BuildContext context) => AddTodoCubit(
                    repository: repository, todoscubitCubit: todoscubitCubit),
                child: const AddTodoScreen()));
      default:
        return MaterialPageRoute(builder: (_) => const TodosScreen());
    }
  }
}
