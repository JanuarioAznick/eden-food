import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class EditarContaPage extends StatefulWidget {
   final Map<String, dynamic> dados;

  const EditarContaPage({super.key, required this.dados});

  @override
  State<EditarContaPage> createState() => _EditarContaPageState();
}

class _EditarContaPageState extends State<EditarContaPage> {
  late TextEditingController _nomeController;
  late TextEditingController _roleController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.dados['name']);
    _roleController = TextEditingController(text: widget.dados['role'] ?? 'usuario');
    _phoneController = TextEditingController(text: widget.dados['phone'] ?? '');
    print(_phoneController.text);
  }

  Future<void> _atualizar() async {
    await FirebaseFirestore.instance.collection('users').doc(widget.dados['uid']).update({
      'name': _nomeController.text.trim(),
      'role': _roleController.text.trim(),
      'phone': _phoneController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Utilizador atualizado")));
    context.pop(); // Voltar para a lista
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Utilizador", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF8B4C39),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: "Nome"),
            ),
            const SizedBox(height: 16),
            TextField(
              enabled: false,
              decoration: InputDecoration(labelText: "Email", hintText: widget.dados['email']),
            ),
            const SizedBox(height: 16),
             TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Contacto"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _roleController,
              decoration: InputDecoration(labelText: "Função"),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _atualizar,
              icon: const Icon(Icons.save),
              label: const Text("Salvar alterações"),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4C39)),
            ),
          ],
        ),
      ),
    );
  }
}
