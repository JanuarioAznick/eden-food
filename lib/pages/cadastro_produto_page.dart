import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({super.key});

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _salvarProduto() {
    final name = _nomeController.text.trim();
    final price = int.tryParse(_precoController.text.trim());
    final category = _categoriaController.text.trim();
    final imageUrl = _imageController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty || price == null || category.isEmpty) return;

    final data = {
      'name': name,
      'price': price,
      'category': category,
      'image': imageUrl,
      'description': description,
      'createdBy': FirebaseAuth.instance.currentUser?.uid,
      'createdAt': FieldValue.serverTimestamp(),
    };

    FirebaseFirestore.instance.collection('produtos').add(data);

    Navigator.pop(context); // voltar pra listagem
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType:
          isNumber ? TextInputType.number : TextInputType.multiline,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF8B4C39), width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Produto", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF8B4C39),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildTextField(_nomeController, "Nome"),
            SizedBox(height: 8),
            _buildTextField(_precoController, "Preço (MT)", isNumber: true),
            SizedBox(height: 8),
            _buildTextField(_categoriaController, "Categoria"),
            SizedBox(height: 8),
            _buildTextField(_imageController, "Imagem URL"),
            SizedBox(height: 8),
            _buildTextField(_descriptionController, "Descrição do produto",
                maxLines: 4),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _salvarProduto,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8B4C39),
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Salvar", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
       bottomNavigationBar: _buildFooter(context),
    );
  }
}

Widget _buildFooter(BuildContext context) {
  final currentLocation = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
  final currentPath = currentLocation.split('?').first; // remove query params if any

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    color: const Color(0xFF8B4C39),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavIcon(context, '/home', Icons.home, currentPath),
        _buildNavIcon(context, '/categorias', Icons.category, currentPath),
        _buildNavIcon(context, '/carrinho', Icons.shopping_cart, currentPath),
        _buildNavIcon(context, '/perfil', Icons.person, currentPath),
        _buildNavIcon(context, '/admin-dashboard', Icons.dashboard_customize, currentPath),
      ],
    ),
  );
}

Widget _buildNavIcon(BuildContext context, String route, IconData icon, String currentPath) {
  final isActive = currentPath.startsWith(route); // match current route

  return IconButton(
    onPressed: () => context.go(route),
    icon: Icon(
      icon,
      color: isActive ? Colors.yellowAccent : Colors.white, // highlight active
      size: isActive ? 30 : 26,
    ),
    tooltip: route.replaceAll('/', '').toUpperCase(),
  );
}
