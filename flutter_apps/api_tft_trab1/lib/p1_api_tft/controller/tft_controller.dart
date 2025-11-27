import 'package:flutter/material.dart';
import '../model/match_model.dart';
import '../model/summoner_model.dart';
import '../service/riot_api_service.dart';

class TFTController extends ChangeNotifier {
  final RiotApiService _apiService = RiotApiService();
  
  SummonerModel? summoner;
  List<MatchModel> matches = [];
  bool isLoading = false;
  String errorMessage = '';

  // Variáveis para controle da paginação
  bool isLoadingMore = false; // Para o loading do botão de baixo
  int currentStartIndex = 0;  // Quantas partidas já carregamos
  final int matchesPerBatch = 5; // Quantas carregar por vez

  // Busca Inicial (Reseta tudo)
  Future<void> searchPlayer(String query) async {
    if (query.isEmpty) return;
    isLoading = true;
    errorMessage = '';
    matches = [];
    currentStartIndex = 0; // Reseta o contador
    notifyListeners();

    try {
      final newSummoner = await _apiService.getSummoner(query);
      summoner = newSummoner;
      
      // Busca o primeiro lote (0 a 5)
      await _fetchMatchesBatch();

    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // NOVA FUNÇÃO: Carregar Mais
  Future<void> loadMoreMatches() async {
    if (isLoadingMore || summoner == null) return;

    isLoadingMore = true;
    notifyListeners(); // Atualiza a UI para mostrar o loading no botão

    try {
      // Incrementa o índice (ex: de 0 vira 5, de 5 vira 10)
      currentStartIndex += matchesPerBatch;
      await _fetchMatchesBatch();
    } catch (e) {
      // Se der erro ao carregar mais, mostra um snackbar ou printa (opcional)
      currentStartIndex -= matchesPerBatch;
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  // Função auxiliar para evitar código duplicado
  Future<void> _fetchMatchesBatch() async {
    final matchIds = await _apiService.getMatchList(
      summoner!.puuid, 
      start: currentStartIndex, 
      count: matchesPerBatch
    );

    // Filtro e Detalhes
    final futures = matchIds.map((id) => 
      _apiService.getMatchDetails(id, summoner!.puuid)
    ).toList();

    final newMatches = await Future.wait(futures);
    
    // Adiciona as novas partidas na lista que já existe
    // Filtra pelo Set 15 aqui se quiser manter a lógica anterior
    matches.addAll(newMatches.where((m) => m.setNumber == 15)); 
  }
}