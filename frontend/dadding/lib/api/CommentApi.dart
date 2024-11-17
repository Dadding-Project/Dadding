import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CommentApi {
  final String baseUrl = "${dotenv.env['BASE_URL']}/comment";
  User? user = FirebaseAuth.instance.currentUser;

  Future<List<dynamic>> getComments(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final idToken = await user?.getIdToken();  
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $idToken',
      },    
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      return [];
    }
  }

  Future<http.Response> createComment(String id, String content) async {
    final url = Uri.parse('$baseUrl/$id');
    final idToken = await user?.getIdToken();  

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({
        'userUid': user?.uid,
        'content': content,
      })
    );

    if (response.statusCode == 201) {
      return response;
    } else {
      print(response.body);
      throw Exception('Failed to create comment');
    }
  }
}