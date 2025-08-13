void main() {
  int a = 5;  // Defina o valor de A aqui
  int resultado = 1;

  String sequencia = '';
  for (int i = a; i > 1; i--) {
    resultado *= i;
    sequencia += '$i X ';
  }
  sequencia += '1 = $resultado';

  print(sequencia);
}