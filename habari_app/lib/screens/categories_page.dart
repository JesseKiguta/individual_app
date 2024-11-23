import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_service.dart';

class CategoriesPage extends StatelessWidget {
  final List<String> categories = [
    'Business',
    'Entertainment',
    'Health',
    'Science',
    'Sports',
    'Technology',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'News App',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              title: Text('Sources'),
              onTap: () {
                Navigator.pushNamed(context, '/sources');
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryNewsPage(category: category),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CategoryNewsPage extends StatefulWidget {
  final String category;

  CategoryNewsPage({required this.category});

  @override
  _CategoryNewsPageState createState() => _CategoryNewsPageState();
}

class _CategoryNewsPageState extends State<CategoryNewsPage> {
  List<dynamic> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategoryNews();
  }

  void fetchCategoryNews() async {
    try {
      final newsService = NewsService();
      final articles = await newsService.fetchCategoryNews(widget.category);
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category} News"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _articles.length,
              itemBuilder: (context, index) {
                final article = _articles[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: article['urlToImage'] != null
                        ? Image.network(
                            article['urlToImage'],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.image, size: 30);
                            },
                          )
                        : Icon(Icons.image, size: 30),
                    title: Text(article['title'] ?? "No Title"),
                    onTap: () {
                      final url = article['url'];
                      if (url != null) {
                        _launchURL(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("No URL available")),
                        );
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
