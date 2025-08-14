void main() {
  // 1. Criação de Listas
  List<String> frutas = ['Maçã', 'Banana', 'Morango', 'Abacaxi', 'Uva'];
  print('1. Lista de frutas: $frutas');

  // 2. Acesso por Índice
  print('\n2. Terceiro elemento: ${frutas[2]}');

  // 3. Adição e Remoção de Elementos
  frutas.add('Laranja');
  print('\n3. Após adicionar Laranja: $frutas');

  frutas.remove('Maçã');
  print('Após remover Maçã: $frutas');

  // 4. Iteração com For Numérico
  print('\n4. Frutas em letras maiúsculas:');
  for (int i = 0; i < frutas.length; i++) {
    print(frutas[i].toUpperCase());
  }

  // 5. Iteração com For Each
  print('\n5. Frutas em letras minúsculas:');
  frutas.forEach((fruta) {
    print(fruta.toLowerCase());
  });

  // 6. Filtragem de Elementos
  List<String> frutasComA = frutas.where((fruta) => fruta.startsWith('A')).toList();
  print('\n6. Frutas que começam com "A": $frutasComA');

  // 7. Mapas em Dart
  Map<String, double> precosFrutas = {
    'Banana': 2.50,
    'Morango': 8.00,
    'Abacaxi': 5.50,
    'Uva': 7.00,
    'Laranja': 3.00,
  };
  print('\n7. Mapa de preços: $precosFrutas');

  // 8. Iteração em Mapas
  print('\n8. Preços por fruta:');
  for (var fruta in precosFrutas.keys) {
    print('$fruta: R\$${precosFrutas[fruta]}');
  }
}