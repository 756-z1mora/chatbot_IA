import 'package:flutter/material.dart';
import 'views/home_view.dart';
import 'models/question_model.dart';
import 'views/questions_view.dart';
import 'views/result_view.dart'; // Si tienes una pantalla de resultados

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escala de Ansiedad',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeView(),
        '/questions': (context) => QuestionsView(questions: hamiltonQuestions),
        '/result': (context) {
  final arguments = ModalRoute.of(context)!.settings.arguments;

  // Verifica si 'arguments' es nulo o no es del tipo esperado
  if (arguments == null || arguments is! List<int>) {
    print("Los argumentos pasados son inválidos o nulos.");
    return ResultView(answers: []); // Usa una lista vacía por defecto
  }

  return ResultView(answers: arguments);
},
      },
    );
  }
}
