import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_task/api/apimodelclass.dart';
import 'package:http/http.dart' as http;

class NewsDetailsPage extends StatefulWidget {
  final String slug;
  const NewsDetailsPage({required this.slug});

  @override
  _NewsDetailsPageState createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  late Future<Article> _articleFuture;

  Future<Article> fetchArticleDetails() async {
    final response = await http.get(
      Uri.parse('https://dashboard.cptguide.org/api/blogs/${widget.slug}'),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return Article.fromJson(jsonBody['data']);
    } else {
      throw Exception('Failed to load article details');
    }
  }

  @override
  void initState() {
    super.initState();
    _articleFuture = fetchArticleDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News Details')),
      body: FutureBuilder<Article>(
        future: _articleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Article not found.'));
          } else {
            final article = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      article.imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Published on ${article.date}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      article.content,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
