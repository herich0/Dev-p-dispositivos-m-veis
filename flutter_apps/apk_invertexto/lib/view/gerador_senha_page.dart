// gerador_senha_page.dart
import 'package:apk_invertexto/service/invertexto_service.dart';
import 'package:flutter/material.dart';

class GeradorSenhaPage extends StatelessWidget {
  const GeradorSenhaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final apiservice = InvertextoService();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/image.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Text(
              "Sua Senha Gerada:",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Expanded(
              child: FutureBuilder(
                future: apiservice.geraSenha(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 8.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Ocorreu um erro. Tente novamente mais tarde.",
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            snapshot.data?["password"] ?? '', // A correção foi aplicada aqui
                            style: TextStyle(fontSize: 20, color: Colors.white),
                            softWrap: true,
                          ),
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}