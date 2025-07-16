import 'package:eden_food/models/product.dart';
import 'package:flutter/material.dart';

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
              // Aqui salvamos no Firestore como pedido
              // usando PedidoService (ver próximo passo)
            },
            child: const Text("Finalizar Pedido"),
          )
        ],
      ),
    );
  }
}
