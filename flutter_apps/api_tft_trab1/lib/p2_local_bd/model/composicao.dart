// Nomes das colunas no Banco de Dados
const String idColumn = "idColumn";
const String nomeColumn = "nomeColumn";        // Nome da Comp
const String campeoesColumn = "campeoesColumn"; // Campeões Principais
const String itensColumn = "itensColumn";       // Itens
const String tierColumn = "tierColumn";         // S, A, B...
const String dificuldadeColumn = "dificuldadeColumn"; // Fácil, Médio...
const String custoColumn = "custoColumn";       // Custo (Barata/Cara)
const String obsColumn = "obsColumn";           // Observações
const String imageColumn = "imageColumn";     // Imagem (caminho)

class Composicao {
  int? id;
  String? nome;
  String? campeoes;
  String? itens;
  String? tier;
  String? dificuldade;
  String? custo;
  String? observacoes;
  String? imagem;

  // Construtor
  Composicao({
    this.id,
    this.nome,
    this.campeoes,
    this.itens,
    this.tier,
    this.dificuldade,
    this.custo,
    this.observacoes,
    this.imagem,
  });

  // Converte de Map (Banco) para Objeto (App)
  Composicao.fromMap(Map<String, dynamic> map) {
    id = map[idColumn];
    nome = map[nomeColumn];
    campeoes = map[campeoesColumn];
    itens = map[itensColumn];
    tier = map[tierColumn];
    dificuldade = map[dificuldadeColumn];
    custo = map[custoColumn];
    observacoes = map[obsColumn];
    imagem = map[imageColumn];
  }

  // Converte de Objeto (App) para Map (Banco)
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nomeColumn: nome,
      campeoesColumn: campeoes,
      itensColumn: itens,
      tierColumn: tier,
      dificuldadeColumn: dificuldade,
      custoColumn: custo,
      obsColumn: observacoes,
      imageColumn: imagem,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Composicao(id: $id, nome: $nome, tier: $tier)";
  }
}