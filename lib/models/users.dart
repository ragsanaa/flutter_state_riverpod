import 'dart:convert';

List<Users> usersFromJson(String str) =>
    List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String usersToJson(List<Users> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;

  Users({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
      id: json["id"],
      name: json["name"],
      username: json["username"],
      email: json["email"],
      phone: json["phone"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "phone": phone
      };
}
