import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class Todo {
  String todoMessage;
  String? image;
  String position;
  bool isCompleted;
  String? id;

  Todo(this.todoMessage, this.image, this.isCompleted, this.position);
  Todo.fromJson(Map json)
      : todoMessage = json["title"],
        image = json["image"],
        isCompleted = json["isCompleted"],
        position = json["position"],
        id = json["_id"] as String;
}
