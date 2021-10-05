import 'dart:convert';

import 'package:http/http.dart';

class NetworkService {
  final headers = {
    "Accept": "application/json",
    "Access-Control-Allow-Origin": "*"
  };

  final baseUrl = "http://localhost:3001";
  Future<List<dynamic>?> fetchTodos() async {
    try {
      final response =
          await get(Uri.parse(baseUrl + "/todo"), headers: headers);
      print(response.body);
      return jsonDecode(response.body) as List;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> patchTodo(Map<String, String> patchObj, String id) async {
    try {
      await patch(Uri.parse(baseUrl + "/todo/$id"),
          body: patchObj, headers: headers);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map?> addTodo(Map<String, Object?> todoObj) async {
    print(todoObj);
    try {
      final response = await post(Uri.parse(baseUrl + "/todo"),
          body: todoObj, headers: headers);

      print(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> deleteTodo(String id) async {
    try {
      await delete(Uri.parse(baseUrl + "/todo/$id"), headers: headers);
      return true;
    } catch (e) {
      return false;
    }
  }
}
