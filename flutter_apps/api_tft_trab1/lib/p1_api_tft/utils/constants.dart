// lib/p1_api_tft/utils/constants.dart

// Versão atualizada para o Set 15 (Verifique se essa versão existe no ddragon)
const String dataDragonVersion = '15.23.1'; 

const String dataDragonBaseUrl = 'https://ddragon.leagueoflegends.com/cdn';

// Função 1: Ícones de Campeão
String getChampionIconUrl(String characterId) {
  if (characterId.isEmpty) return "";

  if (characterId.startsWith('TFT15')) {
     return '$dataDragonBaseUrl/$dataDragonVersion/img/tft-champion/$characterId.TFT_Set15.png';
  }

  // Fallback para o padrão antigo (se houver)
  return '$dataDragonBaseUrl/$dataDragonVersion/img/tft-champion/$characterId.png';
}

// Função 2: Ícones de Características (Traits) - VERIFIQUE SE ESTA FUNÇÃO EXISTE
String getTraitIconUrl(String traitName) {
  if (traitName.isEmpty) return "";
  return '$dataDragonBaseUrl/$dataDragonVersion/img/tft-trait/$traitName.png';
}