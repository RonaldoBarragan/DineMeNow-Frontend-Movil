class UserModel {
  String id;
  String username; // almacena el correo
  String nombre;
  String? apellido;
  String? token;
  String? role;
  bool mustChangePassword;

  UserModel({
    required this.id,
    required this.username,
    required this.nombre,
    this.apellido,
    this.token,
    this.role,
    required this.mustChangePassword,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:       json["id"]       ?? "",
      // El backend manda "correo", SharedPreferences guarda "username"
      // Buscamos ambos para cubrir los dos casos
      username: json["username"] ?? json["correo"] ?? "",
      nombre:   json["nombre"]   ?? "",
      apellido: json["apellido"],
      token:    json["token"],
      role:     json["role"],
      mustChangePassword: json["mustChangePassword"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id":                 id,
      "username":           username,
      "nombre":             nombre,
      "apellido":           apellido,
      "token":              token,
      "role":               role,
      "mustChangePassword": mustChangePassword,
    };
  }

  // Nombre completo para mostrar en UI
  String get nombreCompleto {
    if (apellido != null && apellido!.isNotEmpty) {
      return "$nombre $apellido";
    }
    return nombre;
  }
}