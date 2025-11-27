import 'dart:convert';
import 'package:http/http.dart' as http;

class EventService {
  static const baseUrl = 'https://atenaeventsapi-production.up.railway.app';

  Future<Map<String, dynamic>> getEventById(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/events/$id'));

    if (res.statusCode != 200) {
      throw Exception("Evento não encontrado");
    }

    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> createEvent({
    required int userId,
    required String title,
    required String type,
    required String description,
    required String date,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/events/create/$userId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "type": type,
        "description": description,
        "date": date,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'Erro ao criar evento. Status: ${response.statusCode}\nBody: ${response.body}',
    );
  }

  Future<Map<String, dynamic>> updateEvent({
    required int eventId,
    required String title,
    required String type,
    required String description,
    required String date,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/events/$eventId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
        "type": type,
        "date": date,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      "Erro ao atualizar evento. Status ${response.statusCode}: ${response.body}",
    );
  }

  Future<bool> deleteEvent(int eventId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/events/$eventId'),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    }

    throw Exception(
      "Erro ao deletar evento. Status ${response.statusCode}: ${response.body}",
    );
  }

  Future<List<dynamic>> getRecommendedEvents() async {
    final res = await http.get(Uri.parse("$baseUrl/events/recommended"));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    return [];
  }

  Future<List> getCreatedEvents(int userId) async {
    final res = await http.get(Uri.parse("$baseUrl/events/created_by/$userId"));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return [];
  }

  Future<List> getParticipatedEvents(int userId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/events/participated_by/$userId"),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return [];
  }

  Future<bool> isParticipating(int eventId, int userId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/participate/event/$eventId/user/$userId'),
    );

    if (res.statusCode != 200) return false;

    return res.body == "true";
  }

  Future<bool> toggleParticipation(int eventId, int userId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/participate/toggle'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"eventId": eventId, "userId": userId}),
    );

    if (res.statusCode != 200) {
      throw Exception("Erro ao alterar participação");
    }

    return res.body == "true";
  }
}
