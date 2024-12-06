import 'package:flutter/material.dart';
import '../models/question_model.dart';

class QuestionsView extends StatefulWidget {
  final List<HamiltonQuestion> questions;

  QuestionsView({required this.questions});

  @override
  _QuestionsViewState createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<QuestionsView> {
  final List<int> _answers = [];

  @override
  void initState() {
    super.initState();
    _answers.addAll(List.filled(widget.questions.length, 0));
  }

  void _submitAnswers() {
    // Aquí puedes manejar las respuestas, y pasar los resultados a otra pantalla o mostrar un diagnóstico.
    // Por ahora, solo las imprimimos en la consola.
    print(_answers);
    // Navegar al resultado, por ejemplo:
    Navigator.pushNamed(context, '/result', arguments: _answers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preguntas de utilizando la Escala Hamilton'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: widget.questions.length,
        itemBuilder: (context, index) {
          final question = widget.questions[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    question.question,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...List.generate(
                  question.options.length,
                  (optionIndex) => RadioListTile<int>(
                    title: Text(question.options[optionIndex]),
                    value: optionIndex,
                    groupValue: _answers[index],
                    onChanged: (value) {
                      setState(() {
                        _answers[index] = value ?? 0;
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitAnswers,
        child: Icon(Icons.check),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
