import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/summoner_model.dart';
import '../model/match_model.dart';

class RiotApiService {
  // Mantenha sua chave atualizada aqui
  final String _apiKey = "segredo_da_riot_aqui"; 

  final String platformRoute = 'br1.api.riotgames.com';
  final String regionalRoute = 'americas.api.riotgames.com';

  // ==========================================
  // 1. Busca SOMENTE por Riot ID (Nick#Tag)
  // ==========================================
  Future<SummonerModel> getSummoner(String riotId) async {
    // Tratamento para garantir que temos Nick e Tag
    String gameName = '';
    String tagLine = '';

    if (riotId.contains('#')) {
      final parts = riotId.split('#');
      gameName = parts[0].trim();
      tagLine = parts[1].trim();
    } else {
      // Se o usuário esqueceu a #, assumimos #BR1 por padrão (opcional)
      gameName = riotId.trim();
      tagLine = 'BR1'; 
    }

    // PASSO 1: Pegar PUUID, GameName e TagLine corretos (Account-V1)
    final accountUri = Uri.https(
      regionalRoute,
      '/riot/account/v1/accounts/by-riot-id/$gameName/$tagLine',
    );

    final accountResponse = await http.get(accountUri, headers: {
      "X-Riot-Token": _apiKey,
    });

    if (accountResponse.statusCode != 200) {
      throw _handleError(accountResponse.statusCode, "Conta Riot ID ($gameName#$tagLine)");
    }

    final accountJson = json.decode(accountResponse.body);
    final String puuid = accountJson['puuid'] ?? '';
    // Pegamos o nome oficial formatado pela Riot (ex: Eki#Palms)
    final String realGameName = accountJson['gameName'] ?? gameName;
    final String realTagLine = accountJson['tagLine'] ?? tagLine;

    // PASSO 2: Pegar Level e Ícone (Summoner-V4) usando o PUUID
    final summonerUri = Uri.https(
      platformRoute,
      '/lol/summoner/v4/summoners/by-puuid/$puuid',
    );

    final summonerResponse = await http.get(summonerUri, headers: {
      "X-Riot-Token": _apiKey,
    });

    if (summonerResponse.statusCode != 200) {
      throw _handleError(summonerResponse.statusCode, "Dados de Invocador");
    }

    final summonerJson = json.decode(summonerResponse.body);

    // PASSO 3: Mesclar os dados manualmente para criar o Model
    // Usamos o nome do PASSO 1 (Riot ID) e o level/ícone do PASSO 2
    return SummonerModel(
      id: summonerJson['id'] ?? '',
      puuid: puuid,
      name: '$realGameName #$realTagLine', // Montamos o nome bonito aqui
      profileIconId: summonerJson['profileIconId'] ?? 0,
      summonerLevel: summonerJson['summonerLevel'] ?? 0,
    );
  }

  // ==========================================
  // 2. Match List
  // ==========================================
  Future<List<String>> getMatchList(String puuid, {int start = 0, int count = 5}) async {
    final uri = Uri.https(
      regionalRoute,
      '/tft/match/v1/matches/by-puuid/$puuid/ids',
      {
        'start': start.toString(), // <--- NOVO: Define o deslocamento
        'count': count.toString(),
      },
    );

    final response = await http.get(uri, headers: {"X-Riot-Token": _apiKey});

    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw _handleError(response.statusCode, "Histórico");
    }
  }

  // ==========================================
  // 3. Match Details
  // ==========================================
  Future<MatchModel> getMatchDetails(String matchId, String puuid) async {
    final uri = Uri.https(regionalRoute, '/tft/match/v1/matches/$matchId');

    final response = await http.get(uri, headers: {"X-Riot-Token": _apiKey});

    if (response.statusCode == 200) {
      return MatchModel.fromJson(json.decode(response.body), puuid);
    } else {
      throw _handleError(response.statusCode, "Detalhes da Partida");
    }
  }

  Exception _handleError(int statusCode, String context) {
    if (statusCode == 403) {
      return Exception('Erro 403: Chave expirada ou inválida no portal.');
    } else if (statusCode == 404) {
      return Exception('Erro 404: $context não encontrado.');
    } else {
      return Exception('Erro $statusCode ao buscar $context.');
    }
  }
}