import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTopHeadlines();
  }

  void fetchTopHeadlines() async {
    try {
      final newsService = NewsService();
      final articles = await newsService.fetchTopHeadlines();
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
        title: Text("Top Headlines"),
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
