import 'package:apk_invertexto/service/invertexto_service.dart';
import 'package:flutter/material.dart';

class PorExtensoPage extends StatefulWidget {
  const PorExtensoPage({super.key});

  @override
  State<PorExtensoPage> createState() => _PorExtensoPageState();
}

class _PorExtensoPageState extends State<PorExtensoPage> {
  final TextEditingController _controller = TextEditingController();
  final apiservice = InvertextoService();
  String _moedaSelecionada = "real"; // Valor padrão para a moeda

  Widget exibeResultado(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasError) {
      return Text(
        'Ocorreu um erro. Verifique o número digitado.',
        style: TextStyle(fontSize: 18, color: Colors.red),
      );
    }
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        snapshot.data["text"] ?? '',
        style: TextStyle(fontSize: 20, color: Colors.white),
        softWrap: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            TextField(
              controller: _controller,
              onChanged: (text) {
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: "Digite um número",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _moedaSelecionada,
              dropdownColor: Colors.black,
              style: TextStyle(color: Colors.white),
              onChanged: (String? newValue) {
                setState(() {
                  _moedaSelecionada = newValue!;
                });
              },
              items: <String>['real', 'dolar', 'euro']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Expanded(
              child: FutureBuilder(
                future: apiservice.convertePorExtenso(
                  _controller.text,
                  _moedaSelecionada,
                ),
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
                        return exibeResultado(context, snapshot);
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
