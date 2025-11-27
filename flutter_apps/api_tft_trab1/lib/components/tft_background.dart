import 'package:flutter/material.dart';

class TFTBackground extends StatelessWidget {
  final Widget child;

  const TFTBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          // 1. Carrega a imagem dos assets
          image: AssetImage("assets/imgs/background.jpg"), 
          
          // 2. Cobre a tela toda (pode cortar bordas)
          fit: BoxFit.cover, 
          
          // 3. O Pulo do Gato: Filtro Escuro
          // Isso coloca uma camada preta com 70% de opacidade por cima da imagem.
          // Sem isso, o texto branco fica ilegível.
          colorFilter: ColorFilter.mode(
            Colors.black87, // Quanto mais escuro (ex: black87), mais legível o texto
            BlendMode.darken,
          ),
        ),
      ),
      // O conteúdo da tela (botões, listas) entra aqui
      child: child, 
    );
  }
}