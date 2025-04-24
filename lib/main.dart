import 'package:flutter/material.dart';
import 'package:flutter_task/api/apimodelclass.dart';
import 'package:flutter_task/home_sceen/home.dart';
import 'package:flutter_task/provider/newsprovider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NewsProvider()..fetchArticles(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'News App', home: HomePage());
  }
}
