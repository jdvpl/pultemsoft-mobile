import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String id;
  String name;
  String phone;
  String email;
  // ignore: non_constant_identifier_names
  String Hr;
  // ignore: non_constant_identifier_names
  String Ir;
  // ignore: non_constant_identifier_names
  String SPO2;
  String distance;
  String document;
  String eps;
  String illnesses;
  String temp;
  User(
      {this.id,
      this.name,
      this.phone,
      this.email,
      // ignore: non_constant_identifier_names
      this.Hr,
      // ignore: non_constant_identifier_names
      this.Ir,
      // ignore: non_constant_identifier_names
      this.SPO2,
      this.distance,
      this.document,
      this.eps,
      this.illnesses,
      this.temp});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        Hr: json["Hr"],
        Ir: json["Ir"],
        SPO2: json["SPO2"],
        distance: json["distance"],
        document: json["document"],
        eps: json["eps"],
        illnesses: json["illnesses"],
        temp: json["temp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        // con este guarda la contrasena
        "Hr": Hr,
        "Ir": Ir,
        "SPO2": SPO2,
        "distance": distance,
        "document": document,
        "eps": eps,
        "illnesses": illnesses,
        "temp": temp,
      };
}
