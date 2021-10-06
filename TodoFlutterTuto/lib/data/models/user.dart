class User {
  String id;
  String username;
  String password;
  String token;
  User.fromJson(Map json)
      : id = json["_id"],
        username = json["username"],
        password = json["password"],
        token = json["token"];
}
