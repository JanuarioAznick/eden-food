import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final CollectionReference produtos = FirebaseFirestore.instance.collection('produtos');

  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _editingId;

  void _limparCampos() {
    _nomeController.clear();
    _precoController.clear();
    _categoriaController.clear();
    _imageController.clear();
    _descriptionController.clear();
    _editingId = null;
  }

  void _salvarOuAtualizarProduto() {
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
      'role': 'admin', // default role for products
      'createdBy': FirebaseAuth.instance.currentUser?.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (_editingId != null) {
      produtos.doc(_editingId!).update(data);
    } else {
      produtos.add(data);
    }

    _limparCampos();
  }

  void _carregarParaEdicao(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    _nomeController.text = data['name'];
    _precoController.text = data['price'].toString();
    _categoriaController.text = data['category'];
    _imageController.text = data['image'] ?? '';
    _descriptionController.text = data['description'] ?? '';
    
    setState(() => _editingId = doc.id);
  }

  void _excluirProduto(String id) {
    produtos.doc(id).delete();
  }

  Widget _buildTextField(TextEditingController controller, String label, [bool isNumber = false]) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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

  Widget _buildProductCard(Map<String, dynamic> data, DocumentSnapshot doc) {
  final imageUrl = data['image']?.toString() ?? '';
  final description = data['description']?.toString() ?? 'Sem descrição';

  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.broken_image, size: 60, color: Colors.grey),
              ),
            )
          else
            Icon(Icons.fastfood, size: 60, color: Color(0xFF8B4C39)),

          SizedBox(height: 8),
          Text(data['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text("Preço: ${data['price']} MT", style: TextStyle(color: Colors.green[700])),

          Text("Categoria: ${data['category']}", style: TextStyle(color: Colors.grey[600])),
          
          // 💬 Descrição visível no card
          Text(
            description,
            style: TextStyle(color: Colors.grey[800], fontSize: 13),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _carregarParaEdicao(doc)),
              IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _excluirProduto(doc.id)),
            ],
          ),
        ],
      ),
    ),
  );
}


 

 @override
Widget build(BuildContext context) {
  final isWideScreen = MediaQuery.of(context).size.width > 800;

  return Scaffold(
    appBar: AppBar(
      title: const Text("Cadastro de Produtos", style: TextStyle(color: Colors.white)),
      backgroundColor: const Color(0xFF8B4C39),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    body: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  isWideScreen
                      ? Row(
                          children: [
                            Expanded(child: _buildTextField(_nomeController, "Nome")),
                            SizedBox(width: 8),
                            Expanded(child: _buildTextField(_precoController, "Preço (MT)", true)),
                            SizedBox(width: 8),
                            Expanded(child: _buildTextField(_categoriaController, "Categoria")),
                            SizedBox(width: 8),
                            Expanded(child: _buildTextField(_imageController, "Imagem URL")),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _salvarOuAtualizarProduto,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8B4C39),
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                _editingId == null ? "Adicionar" : "Atualizar",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildTextField(_nomeController, "Nome"),
                            SizedBox(height: 8),
                            _buildTextField(_precoController, "Preço (MT)", true),
                            SizedBox(height: 8),
                            _buildTextField(_categoriaController, "Categoria"),
                            SizedBox(height: 8),
                            _buildTextField(_imageController, "Imagem URL"),
                            SizedBox(height: 8),
                            TextField(
                              controller: _descriptionController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: "Descrição do produto",
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Color(0xFF8B4C39), width: 2),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _salvarOuAtualizarProduto,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8B4C39),
                                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                _editingId == null ? "Adicionar" : "Atualizar",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(height: 16),
                  StreamBuilder<QuerySnapshot>(
                    stream: produtos.orderBy('name').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                      final docs = snapshot.data!.docs;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isWideScreen ? 4 : 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final doc = docs[index];
                          final data = doc.data() as Map<String, dynamic>;
                          return _buildProductCard(data, doc);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildFooter(context), // 👣 Footer fixo
      ],
    ),
  );
}

Widget _buildFooter(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 12),
    color: Color(0xFF8B4C39),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // 🏠 Home
        InkWell(
          onTap: () => context.go('/home'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home, color: Colors.white),
              Text("Home", style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
        // 🍕 Categorias
        InkWell(
          onTap: () => context.go('/categorias'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.category, color: Colors.white),
              Text("Categorias", style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
        // 🛒 Carrinho
        InkWell(
          onTap: () => context.go('/carrinho'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shopping_cart, color: Colors.white),
              Text("Carrinho", style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
        // 👤 Perfil
        InkWell(
          onTap: () => context.go('/perfil'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person, color: Colors.white),
              Text("Perfil", style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
      ],
    ),
  );
}
}

Widget _buildTextField(TextEditingController controller, String label,
    [bool isNumber = false, bool isMultiline = false]) {
  return TextField(
    controller: controller,
    keyboardType: isMultiline
        ? TextInputType.multiline
        : (isNumber ? TextInputType.number : TextInputType.text),
    maxLines: isMultiline ? 3 : 1, // ← área de texto para múltiplas linhas
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
    style: TextStyle(fontSize: 14),
  );
}

