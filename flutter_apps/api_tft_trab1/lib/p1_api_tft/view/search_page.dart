import 'package:api_tft_trab1/components/tft_background.dart';
import 'package:api_tft_trab1/p1_api_tft/view/match_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/tft_controller.dart';
import 'match_tile.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TFT Player Search'),
        backgroundColor: Colors.blueGrey,
      ),
      // 1. O Provider cria o Controller aqui
      body: TFTBackground(
        child: ChangeNotifierProvider(
          create: (_) => TFTController(),
          // 2. O Builder cria um NOVO contexto abaixo do Provider
          child: Builder(
            builder: (context) {
              // Agora esse 'context' aqui ENXERGA o TFTController
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    // Passamos o context "novo" do Builder para a função
                    _buildSearchBar(context),
                    const SizedBox(height: 15),
                    _buildResultArea(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final controller = context.read<TFTController>();
    final TextEditingController textController = TextEditingController();

    return TextField(
      controller: textController,
      decoration: const InputDecoration(
        labelText: 'Nome de Invocador',
        hintText: 'Ex: MeuNick#BR1',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.search),
      ),
      onSubmitted: (value) {
        // Chamada da função de busca no Controller
        controller.searchPlayer(value);
        textController.clear();
      },
    );
  }

  Widget _buildResultArea() {
    return Expanded(
      child: Consumer<TFTController>(
        builder: (context, local, child) {
          if (local.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (local.errorMessage.isNotEmpty) {
            // ... seu código de erro
            return Text(local.errorMessage); // Simplificado
          }

          if (local.summoner == null || local.matches.isEmpty) {
            return const Center(child: Text('Nenhuma partida encontrada.'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Invocador: ${local.summoner!.name} (Lv. ${local.summoner!.summonerLevel})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),

              Expanded(
                child: ListView.separated(
                  // TRUQUE: Adicionamos +1 item para ser o botão "Carregar Mais"
                  itemCount: local.matches.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    // Se o índice for igual ao tamanho da lista, chegamos no final -> Mostra o Botão
                    if (index == local.matches.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: local.isLoadingMore
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: () {
                                  // Chama a função do controller
                                  context
                                      .read<TFTController>()
                                      .loadMoreMatches();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey.shade800,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Carregar Mais Partidas"),
                              ),
                      );
                    }

                    // Se não for o último, mostra o MatchTile normal
                    final match = local.matches[index];
                    return MatchTile(
                      match: match,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MatchDetailPage(match: match),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
