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
        _buildNavIcon(context, '/dashboard-admin', Icons.dashboard_customize, currentPath),
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
}
