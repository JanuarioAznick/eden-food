import 'package:eden_food/models/product.dart';
import 'package:eden_food/pages/cart_page.dart';
import 'package:eden_food/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final List<Product> carrinho = [];
  String filtro = '';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Éden Food", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF8B4C39),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (user != null)
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    "Olá, ${user.email}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    context.go('/login');
                  },
                ),
              ],
            )
          else
            Row(
              children: [
                TextButton(
                  onPressed: () => context.go('/login'),
                  style: TextButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Entrar", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => context.go('/register'),
                  style: TextButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Registrar", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartPage(carrinho: carrinho),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (v) => setState(() => filtro = v),
              decoration: InputDecoration(
                labelText: "Buscar produto...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: ProductService().todos(), // ← deve retornar produtos sem depender do login
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final produtos = snapshot.data!
                    .where((p) => p.name.toLowerCase().contains(filtro.toLowerCase()))
                    .toList();

                if (produtos.isEmpty) {
                  return const Center(child: Text("Nenhum produto encontrado."));
                }

                final produtosPorCategoria = <String, List<Product>>{};
                for (var p in produtos) {
                  produtosPorCategoria.putIfAbsent(p.category, () => []).add(p);
                }

                return ListView(
                  children: produtosPorCategoria.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            entry.key,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8B4C39)),
                          ),
                        ),
                        ...entry.value.map((p) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 4,
                                child: ListTile(
                                  onTap: () => context.go('/detalhes-produto', extra: p),
                                  leading: p.image.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            p.image,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Icon(Icons.fastfood, color: Color(0xFF8B4C39), size: 32),
                                  title: Text(p.name),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${p.price} MT", style: TextStyle(color: Colors.green[700])),
                                      Text(
                                        p.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.add_shopping_cart),
                                    onPressed: () {
                                      setState(() => carrinho.add(p));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${p.name} adicionado ao carrinho!')),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
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
