import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/cubit/todoscubit_cubit.dart';
import 'package:todo_app/data/repository.dart';

part 'add_todo_state.dart';

class AddTodoCubit extends Cubit<AddTodoState> {
  final Repository? repository;
  final TodoscubitCubit? todoscubitCubit;

  AddTodoCubit({required this.repository, required this.todoscubitCubit})
      : super(AddTodoInitial());
  void addTodo(String message) {
    if (message.isEmpty) {
      emit(AddTodoError(error: "todo message is empty"));
      return;
    }
    emit(AddingTodo());
    Timer(const Duration(seconds: 2), () {
      repository!.addTodo(message).then((todo) {
        if (todo != null) {
          todoscubitCubit!.addTodo(todo);
          emit(TodoAdded());
        }
      });
    });
  }
}
