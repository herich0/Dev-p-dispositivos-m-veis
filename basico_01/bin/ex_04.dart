void main(List<String> arguments) {
  int a = 1;
  int b = 4;
  int c = 3;


  String ordem = (a > b && a > c)
      ? (b > c ? '$a > $b > $c' : '$a > $c > $b')
      : (b > a && b > c)
          ? (a > c ? '$b > $a > $c' : '$b > $c > $a')
          : (a > b ? '$c > $a > $b' : '$c > $b > $a');

  print(ordem);
}
