import 'dart:io';
import 'package:api_tft_trab1/components/tft_background.dart';
import 'package:flutter/material.dart';
import '../helper/database_helper.dart';
import '../model/composicao.dart';
import 'composicao_form_page.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Para saber quem tá logado
import '../../p3_firebase/service/firestore_service.dart'; // O serviço novo

class ComposicoesListPage extends StatefulWidget {
  const ComposicoesListPage({super.key});

  @override
  State<ComposicoesListPage> createState() => _ComposicoesListPageState();
}

class _ComposicoesListPageState extends State<ComposicoesListPage> {
  final DatabaseHelper _helper = DatabaseHelper();
  List<Composicao> composicoes = [];

  // Controle do Modo de Visualização (Toggle)
  bool _isTierMode = true; // Começa como Tier List por padrão

  @override
  void initState() {
    super.initState();
    _loadComposicoes();
  }

  void _loadComposicoes() {
    _helper.getAllComposicoes().then((list) {
      setState(() {
        composicoes = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Estratégias"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade900,
        actions: [
          // BOTÃO TOGGLE (Alternar Visualização)
          IconButton(
            icon: Icon(_isTierMode ? Icons.view_list : Icons.grid_view),
            tooltip: _isTierMode ? "Ver como Lista" : "Ver como Tier List",
            onPressed: () {
              setState(() {
                _isTierMode = !_isTierMode;
              });
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber, // Cor de destaque
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          _showComposicaoPage();
        },
      ),
      body: TFTBackground(
        child: composicoes.isEmpty
            ? const Center(
                child: Text(
                  "Nenhuma estratégia salva.",
                  style: TextStyle(fontSize: 18),
                ),
              )
            : _isTierMode
            ? _buildTierListView() // Modo Novo (TFT Academy)
            : _buildStandardListView(), // Modo Antigo (Lista detalhada)
      ),
    );
  }

  // --- MODO 1: TIER LIST VIEW (Estilo TFT Academy) ---
  Widget _buildTierListView() {
    // Lista de Tiers para iterar
    final tiers = ["S", "A", "B", "C", "D"];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: tiers.map((tier) {
        // Filtra as comps que pertencem a este Tier
        final compsDoTier = composicoes.where((c) => c.tier == tier).toList();

        // Se não tiver nenhuma comp nesse tier, não mostra a linha
        if (compsDoTier.isEmpty) return const SizedBox.shrink();

        return _buildTierRow(tier, compsDoTier);
      }).toList(),
    );
  }

  Widget _buildTierRow(String tier, List<Composicao> comps) {
    Color color = _getTierColor(tier);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: IntrinsicHeight(
        // Força a altura a ser igual ao conteúdo
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Caixa do Tier (Esquerda)
            Container(
              width: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                border: Border(right: BorderSide(color: color, width: 4)),
              ),
              child: Center(
                child: Text(
                  tier,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ),
            ),

            // 2. Bolinhas das Comps (Direita)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: comps.map((comp) {
                    return _buildCompBubble(comp, color);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompBubble(Composicao comp, Color color) {
    return GestureDetector(
      onTap: () => _showComposicaoPage(composicao: comp),
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
              color: Colors.grey.shade800,
              image: comp.imagem != null && comp.imagem!.isNotEmpty
                  ? DecorationImage(
                      image: FileImage(File(comp.imagem!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            // Se não tiver imagem, mostra a inicial do nome
            child: comp.imagem == null || comp.imagem!.isEmpty
                ? Center(
                    child: Text(
                      comp.nome != null && comp.nome!.isNotEmpty
                          ? comp.nome![0].toUpperCase()
                          : "?",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 4),
          // Nome Pequeno embaixo da bolinha
          SizedBox(
            width: 60,
            child: Text(
              comp.nome ?? "",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: Colors.white60),
            ),
          ),
        ],
      ),
    );
  }

  // --- MODO 2: STANDARD LIST VIEW (Modo Antigo) ---
  Widget _buildStandardListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: composicoes.length,
      itemBuilder: (context, index) {
        return _composicaoCard(composicoes[index]);
      },
    );
  }

  Widget _composicaoCard(Composicao comp) {
    Color tierColor = _getTierColor(comp.tier ?? 'D');

    return GestureDetector(
      onTap: () {
        _showComposicaoPage(composicao: comp);
      },
      child: Card(
        color: Colors.grey.shade900,
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              // Imagem ou Tier
              Container(
                width: 55,
                height: 55,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tierColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: tierColor, width: 2),
                  image: comp.imagem != null && comp.imagem!.isNotEmpty
                      ? DecorationImage(
                          image: FileImage(File(comp.imagem!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: comp.imagem == null || comp.imagem!.isEmpty
                    ? Text(
                        comp.tier ?? "-",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: tierColor,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              // Infos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comp.nome ?? "Sem nome",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Carry: ${comp.campeoes ?? '?'}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.cloud_upload, color: Colors.blueAccent),
                tooltip: "Publicar na Comunidade",
                onPressed: () {
                  _publicarNaComunidade(comp);
                },
              ),
              // Botão Excluir
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  _confirmarExclusao(comp.id!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComposicaoPage({Composicao? composicao}) async {
    final recarregar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComposicaoFormPage(composicao: composicao),
      ),
    );

    if (recarregar != null && recarregar) {
      _loadComposicoes();
    }
  }

  void _confirmarExclusao(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Excluir Estratégia?"),
          content: const Text("Essa ação não pode ser desfeita."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo sem fazer nada
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo
                _helper.deleteComposicao(id); // Apaga do banco
                _loadComposicoes(); // Atualiza a tela

                // Feedback visual (opcional mas legal)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Estratégia removida!")),
                );
              },
              child: const Text("Excluir", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Color _getTierColor(String tier) {
    switch (tier) {
      case 'S':
        return Colors.amber;
      case 'A':
        return Colors.redAccent;
      case 'B':
        return Colors.blueAccent;
      case 'C':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _publicarNaComunidade(Composicao comp) {
    // 1. Verifica se tem usuário logado
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Você precisa fazer login no P3 para publicar!"),
        ),
      );
      return;
    }

    // 2. Pede confirmação
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Publicar Online?"),
        content: Text(
          "A estratégia '${comp.nome}' será visível para todos na comunidade.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Fecha Dialog

              // 3. Envia pro Firestore
              FirestoreService().addComposicao(comp, user.email ?? "Anônimo");

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Publicado com sucesso na Comunidade!"),
                ),
              );
            },
            child: const Text("Publicar"),
          ),
        ],
      ),
    );
  }
}
