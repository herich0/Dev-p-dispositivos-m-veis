import 'package:flutter/material.dart';
import '../p1_api_tft/view/search_page.dart';
import '../p2_local_bd/view/composicoes_list_page.dart';
import '../p3_firebase/view/auth_gate.dart';
import '../components/tft_background.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TFT Companion - Trab. Mobile'),
        centerTitle: true,
      ),
      body: TFTBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.gamepad, size: 80, color: Colors.blueGrey),
              const SizedBox(height: 40),

              // BOTÃO DO TRABALHO 1
              ElevatedButton.icon(
                icon: const Icon(Icons.cloud_download),
                label: const Text('P1: API Riot (Busca TFT)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
              ),

              const SizedBox(height: 20),

              // BOTÃO DO TRABALHO 2 (Desabilitado por enquanto ou Placeholder)
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('P2: Caderno Tático (SQLite)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.teal.shade900, // Diferenciar cor
                  foregroundColor: Colors.white,
                ),
                // Agora chama a página de lista!
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ComposicoesListPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // BOTÃO DO TRABALHO 3
              ElevatedButton.icon(
                icon: const Icon(Icons.local_fire_department),
                label: const Text('P3: Comunidade (Firebase)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  backgroundColor:
                      Colors.orange.shade900, // Cor de destaque do Firebase
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Navega para o PORTÃO de autenticação
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthGate()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
