enum StatusMaioridade {
  maior,
  menor,
}

class Pessoa {
  String nome;
  int idade;
  StatusMaioridade status;

  Pessoa(this.nome, this.idade)
      : status = (idade >= 18) ? StatusMaioridade.maior : StatusMaioridade.menor;
}

void imprimirMaioresDeIdade(List<Pessoa> pessoas) {
  print('Pessoas maiores de idade:');
  for (var pessoa in pessoas) {
    if (pessoa.status == StatusMaioridade.maior) {
      print('${pessoa.nome} (${pessoa.idade} anos)');
    }
  }
}

void main() {
  List<Pessoa> listaDePessoas = [
    Pessoa('Ana', 25),
    Pessoa('Pedro', 17),
    Pessoa('Carlos', 30),
    Pessoa('Mariana', 16),
    Pessoa('João', 18),
  ];
  imprimirMaioresDeIdade(listaDePessoas);
}