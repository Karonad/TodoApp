import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/cubit/todoscubit_cubit.dart';
import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/data/repository.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

part 'add_todo_state.dart';

class AddTodoCubit extends Cubit<AddTodoState> {
  final Repository? repository;
  final TodoscubitCubit? todoscubitCubit;

  AddTodoCubit({required this.repository, required this.todoscubitCubit})
      : super(AddTodoInitial());
  void addTodo(Todo body, XFile image) {
    if (body.todoMessage.isEmpty) {
      emit(AddTodoError(error: "todo message is empty"));
      return;
    }
    emit(AddingTodo());
    Timer(const Duration(seconds: 2), () {
      repository!.addTodo(body, image).then((todo) {
        if (todo != null) {
          todoscubitCubit!.addTodo(todo);
          emit(TodoAdded());
        }
      });
    });
  }

  void addImage(XFile image) async {
    final res = await image.readAsBytes();
    emit(ImageAdded(image: res));
  }

  void getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      emit(LocationLoaded(location: position));
    }).catchError((e) {
      print(e);
    });
  }
}
