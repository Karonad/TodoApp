part of 'add_todo_cubit.dart';

@immutable
abstract class AddTodoState {}

class AddTodoInitial extends AddTodoState {}

class AddTodoError extends AddTodoState {
  final String error;

  AddTodoError({required this.error});
}

class AddingTodo extends AddTodoState {}

class TodoAdded extends AddTodoState {}

class LocationLoaded extends AddTodoState {
  final String location;

  LocationLoaded({required this.location});
}
