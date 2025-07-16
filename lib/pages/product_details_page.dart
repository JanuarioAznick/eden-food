import 'package:flutter/material.dart';
import 'package:eden_food/models/product.dart';
import 'package:go_router/go_router.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product produto;

  const ProductDetailsPage({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: AppBar(
        title: Text(produto.name, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF8B4C39),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // ← botão de retorno manual
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth:
                  MediaQuery.of(context).size.width > 700
                      ? 600
                      : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (produto.image.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      produto.image,
                      height:
                          MediaQuery.of(context).size.width > 700 ? 260 : 200,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => const Icon(
                            Icons.broken_image,
                            size: 100,
                            color: Colors.grey,
                          ),
                    ),
                  )
                else
                  const Icon(
                    Icons.fastfood,
                    size: 100,
                    color: Color(0xFF8B4C39),
                  ),

                const SizedBox(height: 24),

                Text(
                  produto.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  "Categoria: ${produto.category}",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                Text(
                  "${produto.price} MT",
                  style: const TextStyle(fontSize: 20, color: Colors.green),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                Text(
                  produto.description,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.justify,
                ),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => context.go('/produtos'),//   Navigator.pop(context), // ← voltar
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Voltar"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // lógica do carrinho
                        Navigator.pop(context); // ou adiciona e volta
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text("Adicionar ao carrinho"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4C39),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
