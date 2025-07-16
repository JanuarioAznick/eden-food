import 'package:eden_food/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final void Function(User user) onLogin;

  const LoginPage({required this.onLogin, super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final senhaCtrl = TextEditingController();
  final auth = FirebaseAuth.instance;
  String? erro;

  UsuarioService usuarioService = UsuarioService();

  Future<void> login() async {
    try {
      final userCred = await auth.signInWithEmailAndPassword(
        email: emailCtrl.text,
        password: senhaCtrl.text,
      );
      final perfil = await usuarioService.login(emailCtrl.text, senhaCtrl.text);
      widget.onLogin(userCred.user!);
    } catch (e) {
      setState(() => erro = 'Erro no login. Verifique os dados.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (erro != null) Text(erro!, style: const TextStyle(color: Colors.red)),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: senhaCtrl, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: login, child: const Text('Entrar')),
          ],
        ),
      ),
    );
  }
}
