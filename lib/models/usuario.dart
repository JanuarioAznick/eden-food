class UserModel {
  final String uid;
  final String email;
  final String role;
  final String name;
  final String phone;
  final String senha; // ⚠️ usar com cuidado!

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.senha,
    this.name = '',
    this.phone = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'senha': senha,
      'name': name,
      'phone': phone,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
      senha: map['senha'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}
