import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_service.dart';

class SourcePage extends StatefulWidget {
  @override
  _SourcePageState createState() => _SourcePageState();
}

class _SourcePageState extends State<SourcePage> {
  final Map<String, String> popularMediaOutlets = {
    'BBC News': 'bbc-news',
    'CNN': 'cnn',
    'TechCrunch': 'techcrunch',
    'The Verge': 'the-verge',
    'Reuters': 'reuters',
    'Al Jazeera': 'al-jazeera-english',
  };

  List<dynamic> _articles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void fetchSourceNews(String sourceId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final newsService = NewsService();
      final articles = await newsService.fetchSourceNews(sourceId);
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
        title: Text("Sources"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Habari App',
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
              title: Text('Categories'),
              onTap: () {
                Navigator.pushNamed(context, '/categories');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Select a Source to View News",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: popularMediaOutlets.keys.length,
              itemBuilder: (context, index) {
                final sourceName = popularMediaOutlets.keys.elementAt(index);
                final sourceId = popularMediaOutlets[sourceName]!;
                return ListTile(
                  title: Text(sourceName),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    fetchSourceNews(sourceId);
                  },
                );
              },
            ),
          ),
          if (_isLoading) CircularProgressIndicator(),
          if (!_isLoading && _articles.isNotEmpty)
            Expanded(
              child: ListView.builder(
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
            ),
          if (!_isLoading && _articles.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "No articles available. Please select a source.",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
