class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String image;
  final String category;

  Product({
    required this.id, 
    required this.name, 
    required this.price, 
    required this.category, 
    required this.description, 
    required this.image
  });

  factory Product.fromFirestore(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'],
      price: data['price'],
      category: data['category'],
      description: data['description'] ?? '',
      image: data['image'] ?? 'assets/images/default.png',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'category': category,
      'description': description,
      'image': image,
    };
  }
}
