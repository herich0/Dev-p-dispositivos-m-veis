import 'package:firebase_auth/firebase_auth.dart'; // Import do Auth
import 'package:flutter/material.dart';
import '../../components/tft_background.dart';
import '../../p2_local_bd/helper/database_helper.dart';
import '../../p2_local_bd/model/composicao.dart';
import '../../p2_local_bd/view/composicao_form_page.dart'; // Import do Form
import '../service/firestore_service.dart'; // Import do Service

class ComunidadeDetailPage extends StatelessWidget {
  final Map<String, dynamic> data; // Dados do post
  final String docId; // ID do documento (necessário para update/delete)

  const ComunidadeDetailPage({
    super.key, 
    required this.data, 
    required this.docId // Recebe o ID agora
  });

  @override
  Widget build(BuildContext context) {
    // Pega o usuário atual
    final user = FirebaseAuth.instance.currentUser;
    // Verifica se o email do post é igual ao meu email
    final bool isOwner = user != null && data['author'] == user.email;

    return Scaffold(
      appBar: AppBar(
        title: Text(data['nome'] ?? "Detalhes"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // SE EU SOU O DONO, MOSTRA EDITAR E EXCLUIR
          if (isOwner) ...[
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => _editarOnline(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _confirmarExclusaoOnline(context),
            ),
          ]
        ],
      ),
      extendBodyBehindAppBar: true,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.download, color: Colors.white),
        label: const Text("Salvar no meu Caderno", style: TextStyle(color: Colors.white)),
        onPressed: () => _salvarLocalmente(context),
      ),

      body: Stack(
        children: [
          Positioned.fill(child: TFTBackground(child: Container())),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CABEÇALHO
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getTierColor(data['tier']),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${data['tier']}-Tier",
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Criado por:", style: TextStyle(color: Colors.grey)),
                          Text(
                            isOwner ? "Você" : (data['author'] ?? "Anônimo"),
                            style: TextStyle(
                              color: isOwner ? Colors.amber : Colors.white, 
                              fontStyle: FontStyle.italic,
                              fontWeight: isOwner ? FontWeight.bold : FontWeight.normal
                            )
                          ),
                        ],
                      )
                    ],
                  ),
                  const Divider(height: 40, color: Colors.white24),

                  // INFORMAÇÕES
                  _buildInfoSection("Campeões (Carry)", data['campeoes'], Icons.person),
                  _buildInfoSection("Itens Essenciais", data['itens'], Icons.shield),
                  _buildInfoSection("Economia / Custo", data['custo'], Icons.attach_money),
                  _buildInfoSection("Dificuldade", data['dificuldade'], Icons.speed),

                  const Divider(height: 40, color: Colors.white24),

                  // OBSERVAÇÕES
                  const Text("Dicas / Observações:", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Text(
                      data['observacoes'] ?? "Sem observações.",
                      style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- LÓGICA DE EDIÇÃO ONLINE ---
  void _editarOnline(BuildContext context) {
    // Converte os dados do Map (Firebase) para um Objeto Composicao (App)
    // para preencher o formulário automaticamente
    Composicao compParaEditar = Composicao(
      nome: data['nome'],
      campeoes: data['campeoes'],
      itens: data['itens'],
      tier: data['tier'],
      dificuldade: data['dificuldade'],
      custo: data['custo'],
      observacoes: data['observacoes'],
      imagem: null, // Imagem não vai pra nuvem
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComposicaoFormPage(
          composicao: compParaEditar, // Preenche os campos
          
          // AQUI ESTÁ O PULO DO GATO:
          // Passamos uma função customizada para salvar no FIREBASE em vez do SQLite
          onSaveExternal: (compEditada) async {
            await FirestoreService().updateComposicao(docId, compEditada);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Post atualizado na nuvem!")));
              Navigator.pop(context); // Volta para a lista para ver a atualização
            }
          },
        ),
      ),
    );
  }

  // --- LÓGICA DE EXCLUSÃO ONLINE ---
  void _confirmarExclusaoOnline(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Apagar Post?"),
        content: const Text("Isso removerá permanentemente sua publicação da comunidade."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx); // Fecha Dialog
              await FirestoreService().deleteComposicao(docId); // Apaga
              if (context.mounted) {
                Navigator.pop(context); // Fecha a tela de detalhes e volta pra lista
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Post apagado!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
              }
            },
            child: const Text("Apagar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ... (Resto das funções: _salvarLocalmente, _buildInfoSection, _getTierColor iguais) ...
  
  Widget _buildInfoSection(String title, String? value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueGrey.shade200, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value ?? "-", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _salvarLocalmente(BuildContext context) async {
    Composicao novaComp = Composicao(
      nome: data['nome'],
      campeoes: data['campeoes'],
      itens: data['itens'],
      tier: data['tier'],
      dificuldade: data['dificuldade'],
      custo: data['custo'],
      observacoes: "Importado de ${data['author']}: ${data['observacoes']}",
      imagem: null,
    );
    await DatabaseHelper().saveComposicao(novaComp);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Salvo no caderno local!"), backgroundColor: Colors.teal));
    }
  }

  Color _getTierColor(String? tier) {
    switch (tier) {
      case 'S': return Colors.amber;
      case 'A': return Colors.redAccent;
      case 'B': return Colors.blueAccent;
      default: return Colors.grey;
    }
  }
}