import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eden_food/models/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsuarioService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 📝 Registro de usuário
  Future<UserModel> registrarUsuario(String email, String senha, String role) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: senha);
    final uid = userCredential.user!.uid;

    final usuario = UserModel(
      uid: uid,
      email: email,
      role: role,
      senha: senha, // ⚠️ apenas se estiveres usando a senha na model
    );

    print(usuario.toMap());

    await _firestore.collection('users').doc(uid).set(usuario.toMap());

    return usuario;
  }

  // 🔐 Login do usuário
  Future<UserModel?> login(String email, String senha) async {
    final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: senha);
    final uid = userCredential.user!.uid;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data()!);
  }

  // 📄 Buscar perfil atual
  Future<UserModel?> getPerfilAtual() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data()!);
  }

  // 🚪 Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // 🔍 Verifica se é admin
  Future<bool> isAdmin() async {
    final perfil = await getPerfilAtual();
    return perfil?.role == 'admin';
  }
}
