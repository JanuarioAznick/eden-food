import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<bool> isAdmin(User user) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    final data = doc.data();
    return data?['role'] == 'admin';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil do Utilizador',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF8B4C39),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          user == null
              ? const Center(child: Text("Nenhum utilizador autenticado"))
              : FutureBuilder<bool>(
                future: isAdmin(user),
                builder: (context, snapshot) {
                  final isAdminUser = snapshot.data ?? false;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFF8B4C39),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.displayName ?? 'Sem nome',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.email ?? 'Sem email',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                            onPressed: () {
                              context.go('/editar-conta', extra: {
                              'uid': user.uid,
                              'name': user.displayName,
                              'email': user.email,
                              'phone': user.phoneNumber,                              
                            });
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text("Editar conta"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            context.go('/login');
                          },
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text("Sair da conta", style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B4C39),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (isAdminUser)
                          ElevatedButton.icon(
                            onPressed: () async {
                              await FirebaseAuth.instance.currentUser?.delete();
                              context.go('/login');
                            },
                            icon: const Icon(Icons.delete_forever),
                            label: const Text("Apagar conta (admin)"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        if (isAdminUser)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Utilizadores cadastrados",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              StreamBuilder<QuerySnapshot>(
                                stream:
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  final users = snapshot.data!.docs;

                                  return ListView.builder(
                                    itemCount: users.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final data =
                                          users[index].data()
                                              as Map<String, dynamic>;
                                      final uid = users[index].id;
                                      final isSelf = uid == user.uid;

                                      return Card(
                                        elevation: 2,
                                        child: ListTile(
                                          leading: const Icon(Icons.person),
                                          title: Text(
                                            data['name'] ?? 'Sem nome',
                                          ),
                                          subtitle: Text(
                                            data['email'] ?? 'Sem email',
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(data['role'] ?? 'usuario'),
                                              if (!isSelf) // 👈 Exibir botão apenas se não for ele mesmo
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete_forever,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(uid)
                                                        .delete();
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "Conta excluída com sucesso",
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                      ],
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
}
