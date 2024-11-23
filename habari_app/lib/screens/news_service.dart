import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final String _baseUrl = "https://newsapi.org/v2";
  final String _apiKey = "c380d6c274e2405096547bcb7adfb2d7";

  Future<List<dynamic>> fetchTopHeadlines() async {
    final response = await http.get(
      Uri.parse("$_baseUrl/top-headlines?country=us&apiKey=$_apiKey"),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['articles'];
    } else {
      throw Exception("Failed to load news");
    }
  }

  Future<List<dynamic>> fetchCategoryNews(String category) async {
    final response = await http.get(Uri.parse(
        "$_baseUrl/top-headlines?category=$category&apiKey=$_apiKey"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['articles'];
    } else {
      throw Exception("Failed to load category news");
    }
  }

  Future<List<dynamic>> fetchSourceNews(String source) async {
    final response = await http.get(
        Uri.parse("$_baseUrl/top-headlines?sources=$source&apiKey=$_apiKey"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['articles'];
    } else {
      throw Exception("Failed to load news for source: $source");
    }
  }
}
