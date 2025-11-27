import 'package:flutter/material.dart';
import 'package:geo_loc/controller/parque_controller.dart';
import 'package:provider/provider.dart';

final apiKey = GlobalKey();

class ParquePage extends StatelessWidget {
  const ParquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text("Meu Local"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider<ParqueController>(
        create: (context) => ParqueController(),
        child: Builder(
          builder: (context) {
            final local = context.watch<ParqueController>();
            String mensagem = local.erro = '' ? 'Latitude: ${local.lat}\nLongitude: ${local.long}' : local.erro;
            return Center(child: Text(mensagem));
          },
        ),
      ),
    );
  }
}
