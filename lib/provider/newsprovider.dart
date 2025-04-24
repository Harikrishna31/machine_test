import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api/apimodelclass.dart';

class NewsProvider with ChangeNotifier {
  List<Article> _articles = [];
  bool _isLoading = false;
  String? _error;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchArticles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://dashboard.cptguide.org/api/blogs'),
      );
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        List data = jsonBody['data'];
        _articles = data.map((json) => Article.fromJson(json)).toList();
      } else {
        _error = 'Failed to load articles';
      } 
    
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
