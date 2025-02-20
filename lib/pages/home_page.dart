

import 'dart:async';
import 'package:flappy_bird_app/objects/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Constructor de la clase HomePage

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double birdYaxis = -1; // Variable para controlar la posición vertical del pájaro (inicia en -1, arriba)

  void jump() {
    // Método para simular el salto del pájaro
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      // Timer.periodic ejecuta una función cada 100 milisegundos
      setState(() {
        birdYaxis += 0.1; // Incrementa la posición en el eje Y (mueve el pájaro hacia abajo)
      });
    });
  }

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
          child: GestureDetector(
            onTap: jump,
            child: AnimatedContainer(
              alignment: Alignment(0, birdYaxis),
              duration: Duration(milliseconds: 0),
              color: Colors.blue, // Color de fondo del contenedor (azul)
              child: Center(child: MyBird()), // Centra el widget MyBird dentro del contenedor
                    ),
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