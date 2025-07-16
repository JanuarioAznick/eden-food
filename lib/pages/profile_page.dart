import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil do Utilizador', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF8B4C39),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          SizedBox(height: 32),
          CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFF8B4C39),
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            user?.displayName ?? 'Sem nome',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            user?.email ?? 'Sem email',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              context.go('/login'); // Redireciona ao login após logout
            },
            icon: Icon(Icons.logout),
            label: Text("Sair da conta"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8B4C39),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          Spacer(),
          _buildFooter(context),
        ],
      ),
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
