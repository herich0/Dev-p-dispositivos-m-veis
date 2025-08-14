void main() {
  List<int> numeros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  var filtrarPares = (List<int> lista) {
    return lista.where((numero) => numero % 2 == 0).toList();
  };
  List<int> numerosPares = filtrarPares(numeros);
  print('Lista original de números: $numeros');
  print('Lista com os números pares: $numerosPares');
}