import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> categorias = [
    {'nome': 'Bebidas', 'icone': Icons.local_drink, 'cor': Colors.blue},
    {'nome': 'Lanches', 'icone': Icons.fastfood, 'cor': Colors.red},
    {'nome': 'Doces', 'icone': Icons.cake, 'cor': Colors.pink},
    {'nome': 'Pratos Quentes', 'icone': Icons.ramen_dining, 'cor': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorias", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF8B4C39),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        itemCount: categorias.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final cat = categorias[index];
          return GestureDetector(
            onTap: () => context.go('/produtos/${cat['nome'].toLowerCase()}'),
            child: Container(
              decoration: BoxDecoration(
                color: cat['cor'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFF8B4C39)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(cat['icone'], size: 40, color: cat['cor']),
                  SizedBox(height: 8),
                  Text(cat['nome'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      color: Color(0xFF8B4C39),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(onPressed: () => context.go('/home'), icon: Icon(Icons.home, color: Colors.white)),
          IconButton(onPressed: () => context.go('/categorias'), icon: Icon(Icons.category, color: Colors.white)),
          IconButton(onPressed: () => context.go('/carrinho'), icon: Icon(Icons.shopping_cart, color: Colors.white)),
          IconButton(onPressed: () => context.go('/perfil'), icon: Icon(Icons.person, color: Colors.white)),
        ],
      ),
    );
  }
}
