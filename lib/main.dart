

import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60, // Altura del contenedor
      width: 60, // Ancho del contenedor
      child: Image.asset(
        'lib/images/flappybird.png', // Ruta de la imagen del pájaro
      ),
    );
  }
}