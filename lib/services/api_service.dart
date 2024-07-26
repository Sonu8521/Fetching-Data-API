// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  final String apiUrl = "https://dummyjson.com/products";

  Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> body = jsonResponse['products'];
        List<User> users = body.map((dynamic item) => User.fromJson(item)).toList();
        print('Fetched users: $users'); // Debug print
        return users;
      } else {
        throw Exception("Failed to load users: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching users: $e");
      throw Exception("Error fetching users: $e");
    }
  }
}
