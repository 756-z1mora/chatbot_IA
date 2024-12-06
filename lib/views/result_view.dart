import 'package:flutter/material.dart';
import 'package:test_ansiedad/models/openai_service.dart';

class ResultView extends StatefulWidget {
  final List<int> answers;

  ResultView({required this.answers});



  @override
  _ResultViewState createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  late Future<String> _diagnosisFuture;

  @override
  void initState() {
    super.initState();
    _diagnosisFuture = OpenAIService().getDiagnosis(widget.answers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnóstico de Ansiedad'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: FutureBuilder<String>(
          future: _diagnosisFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final sections = _parseDiagnosis(snapshot.data!);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                 _buildSectionCard(
      title: 'Nivel de Ansiedad',
      content: sections['Nivel de ansiedad'] ?? 'El modelo no proporcionó esta información.',
    ),
    SizedBox(height: 16),
    _buildSectionCard(
      title: 'Explicación',
      content: sections['Explicación'] ?? 'El modelo no proporcionó una explicación.',
    ),
    SizedBox(height: 16),
    _buildSectionCard(
      title: 'Recomendaciones',
      content: sections['Recomendaciones'] ?? 'El modelo no proporcionó recomendaciones.',
    ),
                 
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Volver al Inicio',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Text('No se pudo generar el diagnóstico.'));
            }
          },
        ),
      ),
    );
  }

  Map<String, String> _parseDiagnosis(String diagnosis) {
  final lines = diagnosis.split('\n');
  final Map<String, String> sections = {};
  String currentSection = '';
  String currentContent = '';
  // Recorrer línea por línea buscando patrones específicos
  for (var line in lines) {
    if (line.contains('Nivel de ansiedad:')) {
      sections['Nivel de ansiedad'] = line.split('Nivel de ansiedad:')[1].trim();
    } else if (line.contains('Explicación:')) {
      if (currentSection.isNotEmpty) {
        sections[currentSection] = currentContent.trim(); // Guardar contenido previo
      }
      currentSection = 'Explicación';
      currentContent = line.split('Explicación:')[1].trim();
      
    } else if (line.contains('Recomendaciones:')) {
        if (currentSection.isNotEmpty) {
        sections[currentSection] = currentContent.trim();
      }
      currentSection = 'Recomendaciones';
      currentContent = line.split('Recomendaciones:')[1].trim();
    } else if (currentSection.isNotEmpty) {
      currentContent += ' ' + line.trim(); // Concatenar líneas adicionales
    }
  }

  // Agregar la última sección procesada
  if (currentSection.isNotEmpty) {
    sections[currentSection] = currentContent.trim();
  }

  return sections;
}


  Widget _buildSectionCard({required String title, required String content}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
