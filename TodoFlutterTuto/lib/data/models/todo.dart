class Todo {
  String todoMessage;
  bool isCompleted;
  String id;

  Todo.fromJson(Map json)
      : todoMessage = json["title"],
        isCompleted = json["isCompleted"],
        id = json["_id"] as String;
}
