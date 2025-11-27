import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth_service.dart';
import 'login_page.dart';
// Importaremos a Home do P3 depois, por enquanto usaremos um Placeholder
import 'comunidade_page.dart'; 

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        // Se estiver carregando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Se tem usuário (Logado) -> Vai para a Comunidade
        if (snapshot.hasData) {
          return const ComunidadePage();
        }

        // Se não tem usuário (Deslogado) -> Vai para Login
        return const LoginPage();
      },
    );
  }
}