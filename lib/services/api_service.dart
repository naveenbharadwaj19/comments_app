import 'package:comments_app/models/comment_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String url = "https://jsonplaceholder.typicode.com/comments";

  Future<List<Comment>> fetchComments() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((comment) => Comment.fromJson(comment)).toList();
    } else {
      throw Exception("Failed to load comments");
    }
  }
}
