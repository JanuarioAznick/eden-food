class UserModel {
  final String uid;
  final String email;
  final String role;
  final String senha; // ⚠️ usar com cuidado!

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.senha,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'senha': senha, // ⚠️ Evita salvar isso no Firestore em produção!
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
      senha: map['senha'] ?? '',
    );
  }
}
