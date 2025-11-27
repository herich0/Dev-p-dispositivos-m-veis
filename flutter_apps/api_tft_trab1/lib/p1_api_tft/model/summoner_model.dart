class SummonerModel {
  final String id;
  final String puuid;
  final String name;
  final int profileIconId;
  final int summonerLevel;

  SummonerModel({
    required this.id,
    required this.puuid,
    required this.name,
    required this.profileIconId,
    required this.summonerLevel,
  });

  factory SummonerModel.fromJson(Map<String, dynamic> json) {
    return SummonerModel(
      // O operador ?? garante que se vier null, usamos '' ou 0
      id: json['id'] ?? '',
      puuid: json['puuid'] ?? '',
      name: json['name'] ?? 'Desconhecido', 
      profileIconId: json['profileIconId'] ?? 0,
      summonerLevel: json['summonerLevel'] ?? 0,
    );
  }
}