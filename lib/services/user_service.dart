import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const baseUrl = 'https://atenaeventsapi-production.up.railway.app';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/users/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception('Credenciais inválidas');
    }

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/users/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao criar conta");
    }

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>?> getUser(int userId) async {
    final res = await http.get(Uri.parse("$baseUrl/users/$userId"));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    return null;
  }

  Future<Map<String, dynamic>> updateUser({
    required int userId,
    required String name,
    required String email,
  }) async {
    final url = Uri.parse("$baseUrl/users/$userId");

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar conta");
    }
    return jsonDecode(response.body);
  }

  Future<bool> deleteUser(int userId) async {
    final url = Uri.parse("$baseUrl/users/$userId");

    final res = await http.delete(url);

    if (res.statusCode == 200) return true;

    throw Exception("Erro ao deletar conta");
  }

}
