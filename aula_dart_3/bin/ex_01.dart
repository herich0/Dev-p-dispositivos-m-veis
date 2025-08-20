import 'dart:math';

enum Naipe {
  copas, ouro, espada, paus
}

enum Valor {
  as, dois, tres, quatro, cinco, seis, sete, oito, nove, dez, valete, dama, rei
}

class Carta {
  Carta({required this.naipe, required this.valor});
  Naipe naipe;
  Valor valor;

  @override
  String toString() {
    final nomesNaipes = ["Copas", "Ouro", "Espadas", "Paus"];
    final nomesValores = [
      "Ás", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Valete", "Dama", "Rei"
    ];

    String nomeNaipe = nomesNaipes[naipe.index];
    String nomeValor = nomesValores[valor.index];

    return "$nomeValor de $nomeNaipe";
  }
}

class Baralho {
  Baralho() : cartas = [] {
    for (var naipe in Naipe.values) {
      for (var valor in Valor.values) {
        cartas.add(Carta(naipe: naipe, valor: valor));
      }
    }
  }
  List<Carta> cartas;

  void embaralhar() {
    final random = Random();
    for (int i = cartas.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      var temp = cartas[i];
      cartas[i] = cartas[j];
      cartas[j] = temp;
    }
  }

  Carta comprar() {
    if (cartas.isEmpty) {
      throw Exception("O baralho está vazio!");
    }
    return cartas.removeAt(0);
  }

  int cartasRestantes() {
    return cartas.length;
  }
}

void main() {
  Baralho baralho = Baralho();
  baralho.embaralhar();

  for (int i = 0; i < 5; i++) {
    print(baralho.comprar());
  }

  print("Cartas restantes no baralho: ${baralho.cartasRestantes()}");
}
