void main (List<String> arguments){
  List<int> intervalo = List.generate(10, (i)=>i*10);
  print(intervalo);
  print (intervalo.isEmpty);
  print (intervalo.isNotEmpty);
}