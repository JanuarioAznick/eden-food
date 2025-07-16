import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eden_food/models/product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  Widget _buildProductCard(BuildContext context,Map<String, dynamic> data, String id) {
  final imageUrl = data['image']?.toString() ?? '';
  final description = data['description']?.toString() ?? 'Sem descrição';

  final produto = Product(
    id: id,
    name: data['name'],
    price: data['price'],
    category: data['category'],
    image: imageUrl,
    description: description,
  );

  return GestureDetector(
    onTap: () => context.go('/detalhes-produto', extra: produto),
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(imageUrl, height: 90, fit: BoxFit.cover),
              )
            else
              const Icon(Icons.fastfood, size: 60, color: Color(0xFF8B4C39)),

            const SizedBox(height: 8),
            Text(data['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Preço: ${data['price']} MT", style: TextStyle(color: Colors.green[700])),
            Text("Categoria: ${data['category']}", style: TextStyle(color: Colors.grey[600])),
            Text(
              description,
              style: TextStyle(fontSize: 13, color: Colors.grey[800]),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF8B4C39),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // ← botão de retorno manual context.go('/produtos')
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('produtos').orderBy('name').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return _buildProductCard(context,data, doc.id);
            },
          );
        },
      ),
    );
  }
}
