import 'dart:async';
import 'dart:math';
import 'package:flappy_bird_app/barriers.dart';
import 'package:flappy_bird_app/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variables para controlar la posición y física del pájaro.
  static double birdY = 0; // Posición vertical del pájaro.
  double initialPosition =
      birdY; // Posición inicial del pájaro antes del salto.
  double height = 0; // Altura calculada para el salto.
  double time = 0; // Tiempo transcurrido desde el último salto.
  double gravity = -9.8; // Gravedad que afecta al pájaro (hace que caiga).
  double velocity = 2.5; // Velocidad inicial del salto.
  double birdWidth =
      0.15; // Ancho del pájaro (relativo al ancho de la pantalla).
  double birdHeight =
      0.15; // Altura del pájaro (relativo a la altura de la pantalla).

  bool gameHasStarted = false; // Indica si el juego ha comenzado.
  int score = 0; // Variable para almacenar el puntaje actual.

  // Variables para las barreras.
  static List<double> barrierX = [
    2,
    2 + 1.5
  ]; // Posiciones horizontales de las barreras.
  static double barrierWidth = 0.5; // Ancho de las barreras.
  List<Map<String, dynamic>> barrierHeight = [
    // Alturas de las barreras y un flag para el puntaje.
    {'top': 0.6, 'bottom': 0.4, 'scored': false},
    {'top': 0.4, 'bottom': 0.6, 'scored': false},
  ];

  // Método para iniciar el juego.
  void startGame() {
    gameHasStarted = true;
    score = 0; // Reinicia el puntaje al comenzar el juego.
    Timer.periodic(Duration(milliseconds: 30), (timer) {
      // Fórmula de física para simular el salto (parábola).
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPosition - height; // Actualiza la posición del pájaro.
      });

      // Verifica si el pájaro ha muerto.
      if (birdIsDead()) {
        timer.cancel(); // Detiene el temporizador.
        _showDialog(); // Muestra el diálogo de "Game Over".
      }

      moveMap(); // Mueve las barreras.
      updateScore(); // Actualiza el puntaje.

      time += 0.01; // Incrementa el tiempo para la física del salto.
    });
  }

  // Método para mover las barreras.
  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.01; // Mueve las barreras hacia la izquierda.
      });

      // Si la barrera sale de la pantalla, la reposiciona a la derecha.
      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
        barrierHeight[i] = {
          'top': randomHeight(),
          'bottom': randomHeight(),
          'scored': false
        }; // Nueva altura aleatoria.
      }
    }
  }

  // Método para actualizar el puntaje.
  void updateScore() {
    for (int i = 0; i < barrierX.length; i++) {
      // Si el pájaro pasa una barrera y no se ha contabilizado aún.
      if (barrierX[i] + barrierWidth < 0 && !barrierHeight[i]['scored']) {
        setState(() {
          score++; // Incrementa el puntaje.
          barrierHeight[i]['scored'] =
              true; // Marca la barrera como contabilizada.
        });
      }
    }
  }

  // Método para generar alturas aleatorias para las barreras.
  double randomHeight() {
    return Random().nextDouble() * 0.4 +
        0.2; // Altura aleatoria entre 0.2 y 0.6.
  }

  // Método para reiniciar el juego.
  void resetGame() {
    Navigator.pop(context); // Cierra el diálogo de "Game Over".
    setState(() {
      birdY = 0; // Reinicia la posición del pájaro.
      gameHasStarted = false; // Detiene el juego.
      time = 0; // Reinicia el tiempo.
      initialPosition = birdY; // Reinicia la posición inicial.
      barrierX = [2, 2 + 1.5]; // Reposiciona las barreras.
      barrierHeight = [
        {
          'top': randomHeight(),
          'bottom': randomHeight(),
          'scored': false
        }, // Nuevas alturas aleatorias.
        {'top': randomHeight(), 'bottom': randomHeight(), 'scored': false},
      ];
      score = 0; // Reinicia el puntaje.
    });
  }

  // Método para mostrar el diálogo de "Game Over".
  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Center(
            child: Text(
              "GAME OVER",
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: Text(
            "Score: $score", // Muestra el puntaje final.
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: EdgeInsets.all(7),
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Método para verificar si el pájaro ha muerto.
  bool birdIsDead() {
    // Si el pájaro cae fuera de la pantalla.
    if (birdY < -1 || birdY > 1) {
      return true;
    }

    // Verifica colisiones con las barreras.
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i]['top'] ||
              birdY + birdHeight >= 1 - barrierHeight[i]['bottom'])) {
        return true;
      }
    }
    return false;
  }

  // Método para hacer saltar al pájaro.
  void jump() {
    setState(() {
      time = 0; // Reinicia el tiempo para calcular un nuevo salto.
      initialPosition = birdY; // Guarda la posición actual del pájaro.
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted
          ? jump
          : startGame, // Inicia el juego o hace saltar al pájaro.
      child: Scaffold(
        body: Column(
          children: [
            // Parte superior de la pantalla (cielo y pájaro).
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                      // Pájaro.
                      MyBird(
                        birdY: birdY,
                        birdWidth: birdWidth,
                        birdHeight: birdHeight,
                      ),

                      // Barreras.
                      for (int i = 0; i < barrierX.length; i++) ...[
                        MyBarrier(
                          barrierX: barrierX[i],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[i]['top'],
                          isThisBottomBarrier: false,
                        ),
                        MyBarrier(
                          barrierX: barrierX[i],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[i]['bottom'],
                          isThisBottomBarrier: true,
                        ),
                      ],

                      // Mensaje "TAP TO PLAY" antes de iniciar el juego.
                      if (!gameHasStarted)
                        Container(
                          alignment: Alignment(0, -0.3),
                          child: Text(
                            "T A P  T O  P L A Y",
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Suelo del juego.
            Container(
              height: 20,
              color: Colors.green,
            ),
            // Parte inferior de la pantalla (puntaje y mejor puntaje).
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Puntaje actual.
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "SCORE",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "$score", // Muestra el puntaje actual.
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ],
                    ),
                    // Mejor puntaje.
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "BEST",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "10", // Aquí puedes implementar el mejor puntaje.
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
