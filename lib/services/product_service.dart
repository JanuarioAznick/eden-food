import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eden_food/models/product.dart';

class ProductService {
  final produtos = FirebaseFirestore.instance.collection('produtos');

  Stream<List<Product>> todos() {
    return produtos.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromFirestore(doc.id, doc.data() as Map<String, dynamic>)).toList());
  }

  Future<void> criar(Product p) async {
    await produtos.add(p.toMap());
  }
}
