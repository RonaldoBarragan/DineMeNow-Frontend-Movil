class UserModel {

  String id;
  String username;
  String nombre;
  String? token;
  String? role;
  bool mustChangePassword;


  UserModel({
    required this.id,
    required this.username,
    required this.nombre,
    this.token,
    this.role,
    required this.mustChangePassword,
  });


  factory UserModel.fromJson(Map<String,dynamic> json){

    return UserModel(
      id: json["id"] ?? "",
      username: json["username"] ?? "",
      nombre: json["nombre"] ?? "",
      token: json["token"],
      role: json["role"],
      mustChangePassword: json["mustChangePassword"] ?? false,
    );

  }


  Map<String,dynamic> toJson(){

    return {
      "id": id,
      "username": username,
      "nombre": nombre,
      "token": token,
      "role": role,
      "mustChangePassword": mustChangePassword
    };

  }

}