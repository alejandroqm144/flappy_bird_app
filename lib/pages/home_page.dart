

import 'package:flappy_bird_app/objects/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Constructor de la clase HomePage

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Método build que define la interfaz de usuario de la página
    return Scaffold(
      // Scaffold es una estructura básica de la interfaz de usuario en Flutter
      body: Column(children: [
        // Column es un widget que organiza a sus hijos en una columna vertical
        Expanded(
          flex: 3, // Se define la proporción de espacio que ocupará este contenedor
          // Expandemos el contenedor azul (para simular el cielo)
          child: Container(
            color: Colors.blue, // Color de fondo del contenedor (azul)
            child: Center(child: MyBird()), // Centra el widget MyBird dentro del contenedor
        ),
        ),
        Expanded(
          child: Container(
            color: Colors.green, // Color de fondo del contenedor (verde)
            // El contenedor verde se mantiene (para simular la tierra)
        ),
        ),
      ],)
    );
  }
}