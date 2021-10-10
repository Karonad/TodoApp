import 'dart:convert';

class Message {
  String username;
  String message;
  Message({
    required this.username,
    required this.message,
  });

  Message copyWith({
    required String username,
    required String message,
  }) {
    return Message(
      username: username,
      message: message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'message': message,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      username: map['username'],
      message: map['message'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() => '$username: $message';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Message && o.username == username && o.message == message;
  }

  @override
  int get hashCode => username.hashCode ^ message.hashCode;
}
