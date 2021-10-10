import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:todo_app/data/models/todo.dart';

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
          await http.get(Uri.parse(baseUrl + "/todo"), headers: headers);
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
      await http.patch(Uri.parse(baseUrl + "/todo/$id"),
          body: patchObj, headers: headers);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map?> addTodo(Todo todo, XFile? image, String? token) async {
    try {
      if (token == null) {
        return {};
      } else {
        headers["x-access-token"] = token;
      }
      PickedFile imageFile = PickedFile(image!.path);
      var stream = http.ByteStream(imageFile.openRead());
      stream.cast();
      int length = await image.length();

      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + '/todo'))
        ..headers.addAll(headers)
        ..fields['todoMessage'] = todo.todoMessage
        ..fields['isCompleted'] = 'false'
        ..fields['location'] = todo.position
        ..files.add(http.MultipartFile('image', stream, length,
            filename: basename(imageFile.path),
            contentType: MediaType('image', 'png')));
      var response = await request.send();
      final stringedres = await response.stream.bytesToString();
      return jsonDecode(stringedres);
    } catch (e) {
      print(e);
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
      await http.delete(Uri.parse(baseUrl + "/todo/$id"), headers: headers);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> attemptLogIn(String username, String password) async {
    try {
      final response = await http.post(Uri.parse(baseUrl + "/login"),
          body: {"username": username, "password": password}, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<int> attemptSignUp(String username, String password) async {
    final response = await http.post(Uri.parse(baseUrl + "/signup"),
        body: {"username": username, "password": password}, headers: headers);
    return response.statusCode;
  }
}
