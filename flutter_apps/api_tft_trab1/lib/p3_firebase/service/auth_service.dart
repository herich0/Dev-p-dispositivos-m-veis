import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instância do Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream para ouvir se o usuário logou ou deslogou
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Pegar usuário atual
  User? get currentUser => _auth.currentUser;

  // Login com Email e Senha
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Registro de Novo Usuário
  Future<void> signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}