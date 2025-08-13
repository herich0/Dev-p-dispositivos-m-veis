import 'package:basico_01/basico_01.dart' as basico_01;

void main(List<String> arguments) {
  print('Hello world: ${basico_01.calculate()}!');
  saudacoes("Herich Gabriel de");
  saudacoes1("Herich Gabriel de", sobrenome: adicionaSobrenome);
}
void saudacoes (String nome, {String? sobrenome}){
  print ('Seja bem vindo: $nome $sobrenome');
}

void adicionaSobrenome(){
  print("Campos");
}
void saudacoes1(String nome, {required Function sobrenome}){
  print ('seja bem vindo: $nome');
  sobrenome();
}
