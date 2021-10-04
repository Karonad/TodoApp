import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/data/network_service.dart';

class Repository {
  final NetworkService networkService;

  Repository({required this.networkService});

  Future<List<Todo>> fetchTodos() async {
    final todosRaw = await networkService.fetchTodos();
    return todosRaw!.map((e) => Todo.fromJson(e)).toList();
  }

  Future<bool> changeCompletion(bool isCompleted, String id) async {
    final patchObj = {"isCompleted": isCompleted.toString()};
    return await networkService.patchTodo(patchObj, id);
  }

  Future<Todo?> addTodo(String message) async {
    final todoObj = {"title": message, "isCompleted": "false"};

    final todoMap = await networkService.addTodo(todoObj);
    if (todoMap == null) {
      return null;
    }

    return Todo.fromJson(todoMap);
  }

  Future<bool> deleteTodo(String id) async {
    return await networkService.deleteTodo(id);
  }

  Future<bool> updateTodo(String message, String id) async {
    final patchObj = {"title": message};
    return await networkService.patchTodo(patchObj, id);
  }
}
