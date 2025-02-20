

import 'dart:async';
import 'package:flappy_bird_app/objects/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Constructor de la clase HomePage

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYaxis = 0; // Posición vertical del pájaro (0 = centro)
  double time = 0; // Tiempo transcurrido
  double height = 0; // Altura calculada
  double initialHeight = birdYaxis; // Altura inicial del salto
  bool gameHasStarted = false; // Estado del juego

  void jump() {
    setState(() {
      time = 0; // Reinicia el tiempo para el salto
      initialHeight = birdYaxis; // Guarda la altura actual como inicial
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      time += 0.05; // Incrementa el tiempo
      height = -4.9 * time * time + 2.8 * time; // Ecuación de altura

      setState(() {
        birdYaxis = initialHeight - height; // Actualiza la posición del pájaro
      });

      // Detener el juego si el pájaro cae demasiado
      if (birdYaxis > 1) {
        timer.cancel();
        resetGame();
      }
    });
  }

  void resetGame() {
    setState(() {
      birdYaxis = 0;
      time = 0;
      height = 0;
      gameHasStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Método build que define la interfaz de usuario de la página
    return Scaffold(
        // Scaffold es una estructura básica de la interfaz de usuario en Flutter
        body: Column(
      children: [
        // Column es un widget que organiza a sus hijos en una columna vertical
        Expanded(
          flex:
              3, // Se define la proporción de espacio que ocupará este contenedor
          // Expandemos el contenedor azul (para simular el cielo)
          child: GestureDetector(
            onTap: () {
              if (gameHasStarted) {
                jump();
              }
              else {
                startGame();
              }
            },
            child: AnimatedContainer(
              alignment: Alignment(0, birdYaxis),
              duration: Duration(milliseconds: 0),
              color: Colors.blue, // Color de fondo del contenedor (azul)
              child: Center(
                  child:
                      MyBird()), // Centra el widget MyBird dentro del contenedor
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.green, // Color de fondo del contenedor (verde)
            // El contenedor verde se mantiene (para simular la tierra)
          ),
        ),
      ],
    ));
  }
}