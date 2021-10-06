import 'dart:convert';

import 'package:http/http.dart';

class NetworkService {
  final Map<String, String> headers = {
    "Accept": "application/json",
    "Access-Control-Allow-Origin": "*"
  };

  final baseUrl = "http://localhost:3001";
  Future<List<dynamic>?> fetchTodos(String? token) async {
    try {
      if (token == null) {
        return [];
      } else {
        headers["x-access-token"] = token;
      }
      final response =
          await get(Uri.parse(baseUrl + "/todo"), headers: headers);
      print(response.body);
      return jsonDecode(response.body) as List;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> patchTodo(
      Map<String, String> patchObj, String id, String? token) async {
    try {
      if (token == null) {
        return false;
      } else {
        headers["x-access-token"] = token;
      }
      await patch(Uri.parse(baseUrl + "/todo/$id"),
          body: patchObj, headers: headers);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map?> addTodo(Map<String, String> todoObj, String? token) async {
    try {
      if (token == null) {
        return {};
      } else {
        headers["x-access-token"] = token;
      }
      final response = await post(Uri.parse(baseUrl + "/todo"),
          body: todoObj, headers: headers);

      print(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteTodo(String id, String? token) async {
    try {
      if (token == null) {
        return false;
      } else {
        headers["x-access-token"] = token;
      }
      await delete(Uri.parse(baseUrl + "/todo/$id"), headers: headers);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> attemptLogIn(String username, String password) async {
    try {
      print('hi mark');
      final response = await post(Uri.parse(baseUrl + "/login"),
          body: {"username": username, "password": password}, headers: headers);
      print(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<int> attemptSignUp(String username, String password) async {
    final response = await post(Uri.parse(baseUrl + "/signup"),
        body: {"username": username, "password": password}, headers: headers);
    return response.statusCode;
  }
}
