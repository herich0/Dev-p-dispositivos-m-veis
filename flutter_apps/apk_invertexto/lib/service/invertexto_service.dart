import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class InvertextoService {
  // Use seu token aqui para garantir que a API funcione
  final String _token ="21552|XxWXePvHX2Q0VW4CzfgM6C5MDSg1hXlE";

  Future<Map<String, dynamic>> convertePorExtenso(String? valor, String moeda) async {
    try {
      if (valor == null || valor.isEmpty) {
        return {"text": ""};
      }
      final uri = Uri.parse("https://api.invertexto.com/v1/por-extenso?token=$_token&value=$valor&coin=$moeda");
      final response  = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet.');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> buscaCep(String? valor) async {
    try {
      if (valor == null || valor.isEmpty) {
        return {};
      }
      final uri = Uri.parse("https://api.invertexto.com/v1/cep?token=$_token&value=${valor.replaceAll('-', '')}");
      final response  = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet.');
    } catch (e) {
      rethrow;
    }
  }

  // Novo método para gerar senha
  Future<Map<String, dynamic>> geraSenha() async {
    try {
      final uri = Uri.parse("https://api.invertexto.com/v1/password?token=$_token");
      final response  = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet.');
    } catch (e) {
      rethrow;
    }
  }
}