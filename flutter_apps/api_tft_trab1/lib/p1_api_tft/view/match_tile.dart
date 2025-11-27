import 'package:flutter/material.dart';
import '../model/match_model.dart';
import '../utils/constants.dart';

class MatchTile extends StatelessWidget {
  final MatchModel match;
  final VoidCallback onTap;

  const MatchTile({super.key, required this.match, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Lógica de Cores estilo MetaTFT
    // Top 1: Ouro/Laranja | Top 4: Azul/Ciano | Top 8: Cinza/Vermelho
    final placement = match.participant.placement;
    Color statusColor;
    if (placement == 1) {
      statusColor = Colors.orangeAccent;
    } else if (placement <= 4) {
      statusColor = Colors.cyanAccent;
    } else {
      statusColor = Colors.grey.shade700;
    }

    // Calcula tempo relativo (ex: "Há 2 horas") ou data simples
    final date = "${match.gameDatetime.day}/${match.gameDatetime.month}";
    final duration = "${(match.gameLength / 60).floor()}m";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        height: 85, // Altura fixa para ficar compacto
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // Fundo Dark estilo MetaTFT
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            // 1. BARRA LATERAL COLORIDA + COLOCAÇÃO
            Container(
              width: 45,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.2), // Fundo leve
                border: Border(
                  left: BorderSide(color: statusColor, width: 4), // Barra forte
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "#$placement",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Ranked", // Pode virar dinâmico se tiver queueId
                    style: TextStyle(fontSize: 9, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),

            // 2. LISTA DE CAMPEÕES (CENTRO)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Traits (Opcional - Se quiser por em cima)
                    // _buildTraitsRow(), 
                    
                    // Campeões
                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: match.participant.units.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 4),
                        itemBuilder: (context, index) {
                          final unit = match.participant.units[index];
                          return _buildChampionAvatar(unit);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. INFORMAÇÕES EXTRAS (DIREITA)
            Container(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(date, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(duration, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  const Icon(Icons.chevron_right, color: Colors.grey, size: 16)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChampionAvatar(dynamic unit) {
    final String characterId = unit['character_id'];
    final int rarity = unit['tier'] ?? 1; // Raridade do campeão (custo)

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Avatar
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: _getRarityColor(rarity), width: 1.5),
            image: DecorationImage(
              image: NetworkImage(getChampionIconUrl(characterId)),
              fit: BoxFit.cover,
              alignment: const Alignment(0.6, 0.0),
              onError: (exception, stackTrace) {
                // Se der erro na imagem, mostra um quadrado cinza
              },
            ),
          ),
        ),
        // Estrelas (se quiser mostrar)
        // Text("★" * starLevel, style: TextStyle(fontSize: 8, color: Colors.yellow)),
      ],
    );
  }

  Color _getRarityColor(int tier) {
    switch (tier) {
      case 5: return Colors.orange;     // Lendária
      case 4: return Colors.purple;     // Épica
      case 3: return Colors.blue;       // Rara
      case 2: return Colors.green;      // Incomum
      default: return Colors.grey;      // Comum
    }
  }
}