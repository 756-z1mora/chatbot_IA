import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import '../config.dart';
class OpenAIService {
  
  Future<String> getDiagnosis(List<int> answers) async {
    // Convertir las respuestas en una cadena para enviar al modelo
    String answersText = answers.join(', ');

    // Crear el prompt que le enviarás al modelo
    String prompt = """Basado en estas respuestas, proporciona un diagnóstico detallado sobre el nivel de ansiedad del usuario. Respuestas: $answersText. 
Considera los niveles: **ausente, leve, moderada, severa o muy severa**. Además, incluye una breve explicación sobre cómo las respuestas influyen en este diagnóstico y, si es posible, algunas recomendaciones generales para manejar la ansiedad.
Por favor, asegúrate de que la respuesta incluya correctamente los acentos y caracteres especiales (como la "ó" y la "ñ").
Formato esperado del resultado:
1. Nivel de ansiedad: (especificar el nivel)
2. Explicación: (resumen de cómo se llegó al diagnóstico)
3. Recomendaciones: (acciones prácticas o consejos para el usuario)""";

    // Configurar la solicitud para el modelo de chat
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': 'gpt-4', // Modelo adecuado
          'messages': [
            {"role": "system", "content": "Eres un asistente que ayuda a evaluar la ansiedad."},
            {"role": "user", "content": prompt}
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        print(data['choices'][0]['message']['content'].trim());
        return data['choices'][0]['message']['content'].trim();
        
      } else {
        print("Error en la respuesta de OpenAI: ${response.statusCode}");
        print("Respuesta completa de OpenAI: ${response.body}");
        return 'Hubo un error al generar el diagnóstico.';
      }
    } catch (e) {
      print("Error en la solicitud: $e");
      return 'Hubo un error al generar el diagnóstico.';
    }
  }
}

// Pantalla de Resultados
class ResultView extends StatelessWidget {
  final String diagnosis;

  ResultView({required this.diagnosis});

  @override
  Widget build(BuildContext context) {
    final sections = _parseDiagnosis(diagnosis);

    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados de Ansiedad'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionCard(
              title: 'Nivel de Ansiedad',
              content: sections['Nivel de ansiedad'] ?? 'No especificado',
            ),
            SizedBox(height: 16),
            _buildSectionCard(
              title: 'detalle',
              content: sections['detalle'] ?? 'No detalle',
            ),
            SizedBox(height: 16),
            _buildSectionCard(
              title: 'Recomendaciones',
              content: sections['Recomendaciones'] ?? 'No especificado',
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
                padding: EdgeInsets.all(16),
              ),
              child: Text(
                'Volver al Inicio',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

 Map<String, String> _parseDiagnosis(String diagnosis) {
  final lines = diagnosis.split('\n');
  final Map<String, String> sections = {};
print("Diagnóstico recibido: $diagnosis");
  // Recorrer línea por línea buscando patrones específicos
  for (var line in lines) {
    if (line.contains('Nivel de ansiedad:')) {
      sections['Nivel de ansiedad'] = line.split('Nivel de ansiedad:')[1].trim();
    } else if (line.contains('Explicación:')) {
      sections['Explicación'] = line.split('Explicación:')[1].trim();
    } else if (line.contains('Recomendaciones:')) {
      sections['Recomendaciones'] = line.split('Recomendaciones:')[1].trim();
    }
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
