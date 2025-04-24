import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Article {
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final String date;
  final String slug;

  Article({
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.date,
    required this.slug,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['short_description'] ?? '',
      content: json['content'] ?? '',
      imageUrl:
          json['featured_image'] != null
              ? json['featured_image']['file_path']
              : 'https://via.placeholder.com/150',
      date: json['published_on'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}
