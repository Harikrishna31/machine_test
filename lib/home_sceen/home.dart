import 'package:flutter/material.dart';
import 'package:flutter_task/newdetailspage/newsdetails.dart';
import 'package:flutter_task/provider/newsprovider.dart';
import 'package:provider/provider.dart';
import '../api/apimodelclass.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News App')),
      body: SafeArea(
        child:
            _selectedIndex == 0
                ? buildNewsContent(context)
                : Center(child: Text('Profile Page (Coming Soon)')),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget buildNewsContent(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (provider.error != null) {
          return Center(child: Text('Error: ${provider.error}'));
        } else if (provider.articles.isEmpty) {
          return Center(child: Text('No articles found.'));
        } else {
          final featured = provider.articles.take(3).toList();
          final rest = provider.articles.skip(3).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle('Featured'),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: featured.length,
                    itemBuilder: (context, index) {
                      final article = featured[index];
                      return articleCard(context, article, isHorizontal: true);
                    },
                  ),
                ),
                sectionTitle('All News'),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: rest.length,
                  itemBuilder: (context, index) {
                    final article = rest[index];
                    return articleCard(context, article);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget articleCard(
    BuildContext context,
    Article article, {
    bool isHorizontal = false,
  }) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewsDetailsPage(slug: article.slug),
            ),
          ),
      child:
          isHorizontal
              ? Container(
                width: 300,
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          article.imageUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          article.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          article.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              )
              : Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      article.imageUrl,
                      width: 100,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    article.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
    );
  }
}
