import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eden_food/models/product.dart';

class ProductService {
  final CollectionReference produtos = FirebaseFirestore.instance.collection('produtos');

   Stream<List<Product>> todos() {
    return produtos
        .orderBy('category') // ← podes ordenar por categoria aqui
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Product(
                id: doc.id,
                name: data['name'],
                price: data['price'],
                category: data['category'],
                image: data['image'] ?? '',
                description: data['description'] ?? '',
              );
            }).toList());
  }

  Future<void> criar(Product p) async {
    await produtos.add(p.toMap());
  }
}
