import 'package:flutter/material.dart';
import 'package:test_ansiedad/models/question_model.dart';
import '../views/questions_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evaluación de Ansiedad'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen del chatbot
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/chatbot_icon.png'),
            ),
            SizedBox(height: 20),
            // Cuadro de diálogo del chatbot
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hola, soy Analytics, tu asistente virtual.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Estoy aquí para ayudarte a evaluar tu estado emocional. Responde algunas preguntas para conocerte mejor.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Botón con ícono de Play
                  ElevatedButton.icon(
                    onPressed: () {
                      // Al presionar, navegar a la pantalla de preguntas
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionsView(
                            questions: hamiltonQuestions,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.play_arrow, size: 24),
                    label: Text(
                      'Comenzar Evaluación',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

