// Simplificado para os dados mais importantes da partida para o trabalho
class MatchParticipantModel {
  final String riotId; 
  final String puuid;  
  final int placement;
  final int level;
  final int lastRound;
  final List<dynamic> traits; // Traits ativadas
  final List<dynamic> units; // Unidades no tabuleiro

  MatchParticipantModel({
    required this.riotId,
    required this.puuid,
    required this.placement,
    required this.level,
    required this.lastRound,
    required this.traits,
    required this.units,
  });

  // Mapeia a parte 'info.participants' do JSON de uma partida.
  factory MatchParticipantModel.fromJson(Map<String, dynamic> json) {
    // A API retorna 'riotIdGameName' e 'riotIdTagLine'. Vamos juntar.
    String name = json['riotIdGameName'] ?? 'Desconhecido';
    String tag = json['riotIdTagLine'] ?? '';
    String fullName = tag.isNotEmpty ? '$name #$tag' : name;

    return MatchParticipantModel(
      riotId: fullName,
      puuid: json['puuid'] ?? '',
      placement: json['placement'],
      level: json['level'],
      lastRound: json['last_round'],
      traits: json['traits'] ?? [],
      units: json['units'] ?? [],
    );
  }
}

class MatchModel {
  final String matchId;
  final DateTime gameDatetime;
  final int gameLength;
  final int setNumber;
  final MatchParticipantModel participant; // Você (Foco)
  final List<MatchParticipantModel> allParticipants; // <--- NOVO: Todos os 8 jogadores

  MatchModel({
    required this.matchId,
    required this.gameDatetime,
    required this.gameLength,
    required this.setNumber,
    required this.participant,
    required this.allParticipants,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json, String targetPuuid) {
    // 1. Converte a lista crua do JSON em objetos MatchParticipantModel
    List<MatchParticipantModel> participantsList = (json['info']['participants'] as List)
        .map((p) => MatchParticipantModel.fromJson(p))
        .toList();

    // 2. Ordena a lista pela colocação (1º lugar em cima, 8º embaixo)
    participantsList.sort((a, b) => a.placement.compareTo(b.placement));

    // 3. Encontra "Você" dentro da lista (para manter a lógica antiga funcionando)
    final myData = participantsList.firstWhere(
      (p) => p.puuid == targetPuuid, 
      orElse: () => participantsList[0] // Fallback seguro
    );

    return MatchModel(
      matchId: json['metadata']['match_id'],
      gameDatetime: DateTime.fromMillisecondsSinceEpoch(json['info']['game_datetime']),
      gameLength: json['info']['game_length'].toInt(),
      setNumber: json['info']['tft_set_number'] ?? 0,
      participant: myData,
      allParticipants: participantsList, // <--- Guardamos a lista ordenada
    );
  }
}