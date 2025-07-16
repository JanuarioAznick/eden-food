import 'package:eden_food/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CartPage extends StatelessWidget {
  final List<Product> carrinho;

  const CartPage({required this.carrinho, super.key});

  @override
  Widget build(BuildContext context) {
    final double total = carrinho.fold<double>(0.0, (double sum, Product p) => sum + p.price);
    // O cálculo do total já está correto, pois fold<double> e price é Double.
    // Se quiser mostrar o total sem casas decimais, pode fazer:
    // final int totalInt = total.toInt();
    return Scaffold(
      appBar: AppBar(title: const Text("Carrinho")),
      body: Column(
        children: [
          ...carrinho.map((p) => ListTile(title: Text(p.name), trailing: Text("${p.price} MT"))),
          const Divider(),
          Text("Total: ${total.toStringAsFixed(2)} MT", style: const TextStyle(fontWeight: FontWeight.bold)),
          ElevatedButton(
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Precisas entrar para finalizar o pedido")),
                );
                context.go('/login');
                return;
              }
              // Aqui salvamos no Firestore como pedido
              // usando PedidoService (ver próximo passo)
            },
            child: const Text("Finalizar Pedido"),
          )
        ],
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
