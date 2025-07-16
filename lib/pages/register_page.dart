import 'package:eden_food/models/usuario.dart';
import 'package:eden_food/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  final String? previousPath;

  const RegisterPage({super.key, this.previousPath});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}



class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  String _perfilSelecionado = 'cliente'; // valor padrão

  bool _isLoading = false;
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  UsuarioService usuarioService = UsuarioService();

  void _registrarUsuario() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final usuario = await usuarioService.registrarUsuario(email, senha, _perfilSelecionado);

      final destino = usuario.role == 'admin' ? '/admin-dashboard' : (widget.previousPath ?? '/loja');
      context.go(destino);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Cadastro realizado com perfil ${usuario.role}!'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
         print("🔥 Exceção lançada: $e"); 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao registar: ${e.toString()}'),
        backgroundColor: Colors.red,
      ));
    }

    setState(() => _isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro de Utilizador")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _senhaController,
              decoration: InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Text("Perfil:"),
                SizedBox(width: 12),
                DropdownButton<String>(
                  value: _perfilSelecionado,
                  items: [
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                    DropdownMenuItem(value: 'cliente', child: Text('Cliente')),
                  ],
                  onChanged: (value) => setState(() {
                    _perfilSelecionado = value!;
                  }),
                ),
              ],
            ),
            SizedBox(height: 24),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _registrarUsuario,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text("Registar utilizador", style: TextStyle(color: Colors.white)),
                  ),
          ],
        ),
      ),
    );
  }
}
