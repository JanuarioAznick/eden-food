import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  Future<int> contarProdutos() async {
    final snapshot = await FirebaseFirestore.instance.collection('produtos').get();
    return snapshot.docs.length;
  }

  Future<Map<String, int>> contarPorCategoria() async {
    final snapshot = await FirebaseFirestore.instance.collection('produtos').get();
    final Map<String, int> contagem = {};
    for (var doc in snapshot.docs) {
      final cat = doc['categoria'] ?? 'Outros';
      contagem[cat] = (contagem[cat] ?? 0) + 1;
    }
    return contagem;
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel Administrativo", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF8B4C39),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (user != null)
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    "Olá, ${user.displayName ?? user.email}",
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
        ],
      ),
      backgroundColor: Colors.orange[50],
      body: FutureBuilder(
        future: Future.wait([contarProdutos(), contarPorCategoria()]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final totalProdutos = snapshot.data![0] as int;
          final categorias = snapshot.data![1] as Map<String, int>;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Resumo da Gestão",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Painéis de estatísticas
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _cardResumo("Total de Produtos", "$totalProdutos", Icons.inventory),
                    ...categorias.entries.map((e) => _cardResumo(
                      "Categoria: ${e.key}", "${e.value}", Icons.category,
                    )),
                  ],
                ),

                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => context.go('/produtos'),
                  icon: Icon(Icons.edit),
                  label: Text("Gerir Produtos"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _cardResumo(String titulo, String valor, IconData icone) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          Icon(icone, size: 40, color: Colors.deepOrange),
          SizedBox(height: 8),
          Text(titulo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(valor, style: TextStyle(fontSize: 20, color: Colors.green[800])),
        ],
      ),
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


