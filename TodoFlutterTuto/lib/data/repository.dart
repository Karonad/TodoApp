import 'package:get_storage/get_storage.dart';
import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/data/network_service.dart';

import 'models/user.dart';

class Repository {
  final NetworkService networkService;

  final storage = GetStorage();
  Repository({required this.networkService});

  Future<List<Todo>> fetchTodos() async {
    final token = await jwtOrEmpty;
    final todosRaw = await networkService.fetchTodos(token);
    return todosRaw!.map((e) => Todo.fromJson(e)).toList();
  }

  Future<bool> changeCompletion(bool isCompleted, String id) async {
    final token = await jwtOrEmpty;
    final patchObj = {"isCompleted": isCompleted.toString()};
    return await networkService.patchTodo(patchObj, id, token);
  }

  Future<Todo?> addTodo(String message) async {
    final token = await jwtOrEmpty;
    final todoObj = {"title": message, "isCompleted": "false"};

    final todoMap = await networkService.addTodo(todoObj, token);
    if (todoMap == null) {
      return null;
    }

    return Todo.fromJson(todoMap);
  }

  Future<bool> deleteTodo(String id) async {
    final token = await jwtOrEmpty;
    return await networkService.deleteTodo(id, token);
  }

  Future<bool> updateTodo(String message, String id) async {
    final token = await jwtOrEmpty;
    final patchObj = {"title": message};
    return await networkService.patchTodo(patchObj, id, token);
  }

  Future<String?> login(String username, String password) async {
    final userRaw = await networkService.attemptLogIn(username, password);
    print(userRaw);
    final userObj = User.fromJson(userRaw);
    return userObj.token;
  }

  Future<int?> signup(String username, String password) async {
    return await networkService.attemptSignUp(username, password);
  }

  Future<String?> get jwtOrEmpty async {
    var jwt = await storage.read("jwt");
    if (jwt == null) return "";
    return jwt;
  }
}
