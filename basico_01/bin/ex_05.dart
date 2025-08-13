void main(List<String> arguments) {
  int n = 1;
  int soma = 0;

  while (n < 500) {
    soma += somar(n);
    n++;
  }

  print(soma);  
}

int somar(int n) => (n % 3 == 0 && n % 2 != 0) ? n : 0;  
