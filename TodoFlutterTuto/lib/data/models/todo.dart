import 'package:image_picker/image_picker.dart';

class Todo {
  String todoMessage;
  String? image;
  bool isCompleted;
  String? id;

  Todo(this.todoMessage, this.image, this.isCompleted);
  Todo.fromJson(Map json)
      : todoMessage = json["title"],
        image = json["image"],
        isCompleted = json["isCompleted"],
        id = json["_id"] as String;
}
