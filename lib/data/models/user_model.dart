// Modelo de usuário do sistema de registro de ponto.
class UserModel {
  final String id;
  final String name;
  final String email;
  final String nif;
  final String role;
  final bool biometricsEnabled;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.nif,
    required this.role,
    this.biometricsEnabled = true,
  });

  // Converte o modelo para mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'nif': nif,
      'role': role,
      'biometricsEnabled': biometricsEnabled,
    };
  }

  // Cria uma instância de UserModel a partir de um mapa JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      nif: json['nif'] as String,
      role: json['role'] as String? ?? 'Funcionário',
      biometricsEnabled: json['biometricsEnabled'] as bool? ?? true,
    );
  }

  // Cria uma cópia com campos modificados.
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? nif,
    String? role,
    bool? biometricsEnabled,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      nif: nif ?? this.nif,
      role: role ?? this.role,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
    );
  }
}
