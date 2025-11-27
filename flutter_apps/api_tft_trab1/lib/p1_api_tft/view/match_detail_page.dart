import 'package:flutter/material.dart';
import '../model/match_model.dart';
import '../utils/constants.dart';
import '../../components/tft_background.dart';

class MatchDetailPage extends StatelessWidget {
  final MatchModel match;

  // Recebe o objeto MatchModel no construtor (similar a ContactPage ou ParqueDetailPage)
  const MatchDetailPage({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Partida ${match.matchId.substring(0, 8)}...'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: TFTBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 1. Resumo (Colocação, Tempo)
              _buildMatchSummary(),
              const Divider(height: 20),

              // 2. Traits (Características) - AQUI ESTAVA FALTANDO
              Text(
                'Sinergias Ativas:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildTraitSection(context), // <--- Chamando a função aqui!
              const Divider(height: 20),

              // 3. Unidades
              Text(
                'Suas Unidades:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildUnitSection(context),
              const Divider(height: 30),

              // 4. Placar Geral (Leaderboard)
              Text(
                'Placar da Partida:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              _buildLeaderboard(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para exibir o resumo da partida (Placement, Round, Duração)
  Widget _buildMatchSummary() {
    final placement = match.participant.placement;
    final bool isWin = placement <= 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Colocação Final: $placementº',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isWin ? Colors.green.shade700 : Colors.red.shade700,
          ),
        ),
        Text('Rodada Final: ${match.participant.lastRound}'),
        Text('Duração: ${(match.gameLength / 60).toStringAsFixed(1)} minutos'),
      ],
    );
  }

  // Widget para exibir as unidades em um layout Wrap (similar a Wrap no ParqueDetailPage)
  Widget _buildUnitSection(BuildContext context) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: match.participant.units.map<Widget>((unit) {
        final String name = unit['character_id'] ?? '';
        final int rarity = unit['tier'] ?? 1;

        // Formata o nome para exibição (Remove o TFT13_...)
        final String displayName = name.split('_').last;

        return Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                // Borda de raridade (igual ao MatchTile, mas mais grossa pq o ícone é maior)
                border: Border.all(color: _getRarityColor(rarity), width: 2.5),
                image: DecorationImage(
                  image: NetworkImage(getChampionIconUrl(name)),
                  // IMPORTANTE: Use 'cover' para não ficar achatada
                  fit: BoxFit.cover,
                  // O mesmo alinhamento que funcionou no MatchTile (ajuste se precisar)
                  alignment: const Alignment(0.6, 0.0),
                  onError: (exception, stackTrace) {
                    // Tratamento silencioso ou ícone de erro
                  },
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              displayName,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        );
      }).toList(),
    );
  }

  // 2. Atualizando a seção de Características (Traits)
  Widget _buildTraitSection(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: match.participant.traits.map<Widget>((trait) {
        final String name = trait['name'] ?? '';
        final int activeCount = trait['num_units'] ?? 0;
        final int style = trait['style'] ?? 0;
        final String displayName = name.split('_').last;

        // Se style for 0, a trait não está ativa (só tem unidades, mas não fechou o bonus)
        // Você pode optar por não mostrar traits inativas se quiser:
        if (style == 0) return const SizedBox.shrink();

        return Chip(
          backgroundColor: _getTraitColor(style),
          padding: const EdgeInsets.all(4),
          avatar: CircleAvatar(
            backgroundColor: Colors.black26,
            backgroundImage: NetworkImage(getTraitIconUrl(name)),
          ),
          label: Text(
            '$displayName ($activeCount)',
            style: const TextStyle(
              color: Colors
                  .black, // Texto preto para contraste com cores claras (Ouro/Prata)
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    );
  }

  // Funções auxiliares para cor baseadas em dados da API (raridade / nível de trait)
  Color _getRarityColor(int tier) {
    switch (tier) {
      case 5:
        return Colors.amber.shade700;
      case 4:
        return Colors.purple.shade700;
      case 3:
        return Colors.blue.shade700;
      case 2:
        return Colors.green.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  Color _getTraitColor(int style) {
    switch (style) {
      case 3:
        return Colors.orange.shade300; // Prismatic
      case 2:
        return Colors.yellow.shade300; // Gold
      case 1:
        return Colors.blueGrey.shade300; // Silver
      default:
        return Colors.grey.shade300; // Bronze/Active
    }
  }

  Widget _buildLeaderboard(BuildContext context) {
    return ListView.builder(
      shrinkWrap:
          true, // Importante para funcionar dentro do SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(), // Desativa rolagem interna
      itemCount: match.allParticipants.length,
      itemBuilder: (context, index) {
        final p = match.allParticipants[index];
        final isMe = p.puuid == match.participant.puuid;

        // Cores baseadas na posição (igual ao MatchTile)
        Color posColor;
        if (p.placement == 1) {
          posColor = Colors.orangeAccent;
        } else if (p.placement <= 4) {
          posColor = Colors.cyanAccent;
        } else {
          posColor = Colors.grey;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isMe ? Colors.white10 : Colors.black12, // Destaca você
            border: Border(left: BorderSide(color: posColor, width: 4)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Linha 1: Posição e Nome
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "#${p.placement}  ${p.riotId}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe ? Colors.white : Colors.white70,
                    ),
                  ),
                  Text(
                    "Lvl ${p.level}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Linha 2: Mini lista de campeões desse jogador
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: p.units.map((u) {
                    final String charId = u['character_id'];
                    final int rarity = u['tier'] ?? 1;
                    return Container(
                      margin: const EdgeInsets.only(right: 4),
                      width: 28, // Pequeno para caber os 8 jogadores
                      height: 28,
                      decoration: BoxDecoration(
                        border: Border.all(color: _getRarityColor(rarity)),
                        borderRadius: BorderRadius.circular(2),
                        image: DecorationImage(
                          image: NetworkImage(getChampionIconUrl(charId)),
                          fit: BoxFit.cover,
                          alignment: const Alignment(0.6, 0.0),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
