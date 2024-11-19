import 'dart:convert';
import 'package:dadding/util/Post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PostApi {
  final String baseUrl = "${dotenv.env['BASE_URL']}/post";
  User? user = FirebaseAuth.instance.currentUser;

  Future<List<dynamic>> getPosts() async {
    final url = Uri.parse(baseUrl);
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

  Future<Map<String, dynamic>> getPostById(String id) async {
    final url = Uri.parse('$baseUrl/$id');
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
      return {};
    }
  }

  Future<http.Response> createPost(String content, String title, List<String> tags, List<String> images) async {
    final url = Uri.parse(baseUrl);
    final idToken = await user?.getIdToken();  

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({
        'authorId': user?.uid,
        'content': content,
        'title': title,
        'tags': tags,
        'images': images,
      })
    );

    if (response.statusCode == 201) {
      return response;
    } else {
      print(response.body);
      throw Exception('Failed to create post');
    }
  }

  Future<http.Response> updatePostCommentCount(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final idToken = await user?.getIdToken();  
    final post = Post.fromJson(await getPostById(id));

    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({
        'authorId': post.authorId,
        'content': post.content,
        'title': post.title,
        'tags': post.tags,
        'images': post.images,
        'commentCount': post.commentCount + 1,
      })
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to update post');
    }
  }
}