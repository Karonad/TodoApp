part of 'add_todo_cubit.dart';

@immutable
abstract class AddTodoState {}

class AddTodoInitial extends AddTodoState {}

class AddTodoError extends AddTodoState {
  final String error;

  AddTodoError({required this.error});
}

class AddingTodo extends AddTodoState {}

class ImageAdded extends AddTodoState {
  final Uint8List image;

  ImageAdded({required this.image});
}

class TodoAdded extends AddTodoState {}
