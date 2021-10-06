import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/cubit/todoscubit_cubit.dart';
import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/data/repository.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

part 'add_todo_state.dart';

class AddTodoCubit extends Cubit<AddTodoState> {
  final Repository? repository;
  final TodoscubitCubit? todoscubitCubit;

  AddTodoCubit({required this.repository, required this.todoscubitCubit})
      : super(AddTodoInitial());
  void addTodo(Todo body, XFile image) {
    print(body);
    if (body.todoMessage.isEmpty) {
      emit(AddTodoError(error: "todo message is empty"));
      return;
    }
    emit(AddingTodo());
    upload(image);
    Timer(const Duration(seconds: 2), () {
      repository!.addTodo(body).then((todo) {
        if (todo != null) {
          todoscubitCubit!.addTodo(todo);
          emit(TodoAdded());
        }
      });
    });
  }

  void getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      print("AZERTYUIOPQSDFGHJKLMWXCVBN");
      print(position);
      emit(LocationLoaded(location: position));
    }).catchError((e) {
      print(e);
    });
  }

  getAddressFromLatLng(position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      position = "${place.locality}, ${place.postalCode}, ${place.country}";
      emit(LocationLoaded(location: position));
    } catch (e) {
      print(e);
    }
  }

  void upload(XFile imageFile) async {
    // open a bytestream
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("http://localhost:3001/todo");

    // create multipart request
    var request = http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = http.MultipartFile('myFile', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
}
