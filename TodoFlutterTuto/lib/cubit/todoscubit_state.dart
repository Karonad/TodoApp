part of 'todoscubit_cubit.dart';

@immutable
abstract class TodoscubitState {}

class TodoscubitInitial extends TodoscubitState {}

class TodosLoaded extends TodoscubitState {
  final List<Todo> todos;
  TodosLoaded({required this.todos});
}
