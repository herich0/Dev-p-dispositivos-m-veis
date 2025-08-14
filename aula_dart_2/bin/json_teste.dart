import 'dart:convert';

String dadosAlunos() {
  return """{
    "nome":"Herich gabriel",
    "Sobrenome":"de Campos",
    "idade":"19",
    "casado":"false",
    "telefones":[
      {"ddd":42,"numero":988112233,"tipo":"celular"},
      {"ddd":42,"numero":988112244,"tipo":"celular"}
    ]
  }""";
}
void main (List<String> arguments){
  Map<String, dynamic> dados= json.decode(dadosAlunos());
  print (dados);  
}