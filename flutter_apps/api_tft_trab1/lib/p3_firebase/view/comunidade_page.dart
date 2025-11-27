import 'package:api_tft_trab1/components/tft_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../service/auth_service.dart';
import '../service/firestore_service.dart';
import 'comunidade_detail_page.dart';

class ComunidadePage extends StatelessWidget {
  const ComunidadePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();
    final user = AuthService().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meta da Comunidade"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => AuthService().signOut(),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade900,
      body: TFTBackground(
        child: Column(
          children: [
            // Cabeçalho simples
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Logado como: ${user?.email}",
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),

            // Lista em Tempo Real (Stream)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getComposicoesStream(),
                builder: (context, snapshot) {
                  // Estados de Carregamento e Erro
                  if (snapshot.hasError) {
                    return const Center(child: Text("Erro ao carregar dados."));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text("Nenhuma comp publicada ainda."),
                    );
                  }

                  // Lista de Cards
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      // Pegamos os dados do documento
                      final data = docs[index].data() as Map<String, dynamic>;
                      final docId = docs[index].id;

                      return _buildCommunityCard(
                        context, // Passando o contexto para navegação
                        data,
                        docId,
                        firestoreService,
                        user!.uid,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityCard(
    BuildContext context, // Recebe o contexto aqui
    Map<String, dynamic> data,
    String docId,
    FirestoreService service,
    String currentUserId,
  ) {
    // Lógica para verificar se o usuário já deu like
    final List<dynamic> likedBy = data['likedBy'] ?? [];
    final bool isLiked = likedBy.contains(currentUserId);

    return GestureDetector(
      onTap: () {
        // Navega para a tela de detalhes passando os dados
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ComunidadeDetailPage(data: data, docId: docId),
          ),
        );
      },
      child: Card(
        color: Colors.grey.shade800,
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Linha 1: Título e Likes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      data['nome'] ?? "Sem Nome",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // --- BOTÃO DE LIKE INTELIGENTE ---
                  Row(
                    children: [
                      IconButton(
                        // Muda o ícone: Cheio se curtiu, Contorno se não
                        icon: Icon(
                          isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          color: isLiked ? Colors.amber : Colors.grey,
                          size: 20,
                        ),
                        onPressed: () {
                          // Chama o Toggle passando o ID do usuário
                          service.toggleLike(docId, currentUserId);
                        },
                      ),
                      Text(
                        "${data['likes'] ?? 0}",
                        style: TextStyle(
                          color: isLiked ? Colors.amber : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Linha 2: Autor e Tier
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getTierColor(data['tier']),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "${data['tier']}-Tier",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "por ${data['author']}",
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Linha 3: Detalhes
              Text(
                "Carry: ${data['campeoes']}",
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                "Itens: ${data['itens']}",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTierColor(String? tier) {
    switch (tier) {
      case 'S':
        return Colors.amber;
      case 'A':
        return Colors.redAccent;
      case 'B':
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }
}
