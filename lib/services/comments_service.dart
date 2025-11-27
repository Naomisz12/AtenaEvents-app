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

  Future<void> updateComment({
    required int commentId,
    required String newText,
  }) async {
    final res = await http.put(
      Uri.parse("$baseUrl/comments/$commentId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "text": newText,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Erro ao atualizar comentário");
    }
  }

  Future<void> deleteComment({
    required int commentId,
  }) async {
    final res = await http.delete(
      Uri.parse("$baseUrl/comments/$commentId"),
    );

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("Erro ao deletar comentário");
    }
  }
}
