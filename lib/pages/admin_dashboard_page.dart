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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel Administrativo"),
        backgroundColor: Colors.deepOrange,
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
