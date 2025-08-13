void main(List<String> arguments) {
  soma_e_maior(10, 5, 14);
}

void soma_e_maior(int a, int b, int c) => print((a + b) > c ? 'a soma de a+b é maior' : "c é maior ou igual");
