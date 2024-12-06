import '../models/openai_service.dart';

class AnxietyController {
  final OpenAIService openAIService = OpenAIService();
  List<int> scores = [];

  void addScore(int score) {
    scores.add(score);
  }

  Future<String> getDiagnosis() async {
    String responses = scores.join(', ');
    return await openAIService.analyzeResponses(responses);
  }
}
