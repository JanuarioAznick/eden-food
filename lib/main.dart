import 'package:eden_food/home.dart';
import 'package:eden_food/models/product.dart';
import 'package:eden_food/pages/admin_dashboard_page.dart';
import 'package:eden_food/pages/cadastro_produto_page.dart';
import 'package:eden_food/pages/cart_page.dart';
import 'package:eden_food/pages/category_page.dart';
import 'package:eden_food/pages/editar_page.dart';
import 'package:eden_food/pages/listagem_produtos_page.dart';
import 'package:eden_food/pages/product_details_page.dart';
import 'package:eden_food/pages/product_page.dart';
import 'package:eden_food/pages/profile_page.dart';
import 'package:eden_food/pages/register_page.dart';
import 'package:eden_food/pages/store_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

  runApp(const EdenApp());
}


class EdenApp extends StatelessWidget {
  const EdenApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final GoRouter router = GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final loggedIn = auth.currentUser != null;
        final accessingAdmin = state.matchedLocation == '/produtos';

        if (accessingAdmin && !loggedIn) return '/login';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(
            onLogin: (_) => context.go('/produtos'),
          ),
        ),
        GoRoute(
          path: '/loja',
            builder: (context, state) => const StorePage(),
          ),
        GoRoute(
          path: '/produto',
          builder: (context, state) => const ProductPage(),
        ),
        GoRoute(
          path: '/cadastro-produto',
          builder: (context, state) => const NewProductPage(),
        ),
       
        GoRoute(
          path: '/produtos',
          builder: (context, state) => const ProductListPage(),
        ),  
        GoRoute(
          path: '/detalhes-produto',
          builder: (context, state) {
            final product = state.extra;
            if (product is! Product) {
              return const Scaffold(
                body: Center(child: Text("Produto inválido ou não encontrado")),
              );
            }
            return ProductDetailsPage(produto: product);
          },
        ),
        GoRoute(
          path: '/editar-conta',
          builder: (context, state) {
            final dados = state.extra as Map<String, dynamic>;
            return EditarContaPage(dados: dados);
          },
        ),
        GoRoute(
          path: '/carrinho',
          builder: (context, state) => const CartPage(carrinho: [],),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/admin-dashboard',
          builder: (context, state) => const AdminDashboardPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => RegisterPage(
            previousPath: state.extra as String?, // guarda onde o cliente estava antes
          ),
        ),
         GoRoute(
          path: '/categorias',
          builder: (context, state) => CategoryPage(),
        ),
         GoRoute(
          path: '/perfil',
          builder: (context, state) => ProfilePage(),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Éden Food Web',
      routerConfig: router,
    );
  }
}
