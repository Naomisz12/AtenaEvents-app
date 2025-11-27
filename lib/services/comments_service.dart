import 'dart:convert';
import 'package:http/http.dart' as http;

class CommentsService {
  static const baseUrl =
      "https://atenaeventsapi-production.up.railway.app";

  Future<List<dynamic>> getComments(int eventId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/comments/event/$eventId"),
    );

    if (res.statusCode != 200) {
      throw Exception("Erro ao carregar comentários");
    }

    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> createComment({
    required int eventId,
    required int userId,
    required String text,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/comments"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "eventId": eventId,
        "userId": userId,
        "text": text,
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Erro ao enviar comentário");
    }

    return jsonDecode(res.body);
  }
}
