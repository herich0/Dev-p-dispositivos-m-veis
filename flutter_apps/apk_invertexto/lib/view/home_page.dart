// home_page.dart
import 'package:apk_invertexto/view/busca_cep_page.dart';
import 'package:apk_invertexto/view/por_extenso_page.dart';
import 'package:apk_invertexto/view/gerador_senha_page.dart'; // Importação necessária
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Row(
                children: <Widget>[
                  Icon(Icons.edit, color: Colors.white, size: 50.0),
                  SizedBox(width: 20.0),
                  Text(
                    "Por Extenso",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PorExtensoPage()),
                );
              },
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              child: Row(
                children: <Widget>[
                  Icon(Icons.home, color: Colors.white, size: 50.0),
                  SizedBox(width: 20.0),
                  Text(
                    "Busca CEP",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BuscaCepPage()),
                );
              },
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              child: Row( // O 'G' foi removido daqui
                children: <Widget>[
                  Icon(Icons.vpn_key, color: Colors.white, size: 50.0),
                  SizedBox(width: 20.0),
                  Text(
                    "Gerador de Senha",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GeradorSenhaPage()), // 'const' foi adicionado
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}