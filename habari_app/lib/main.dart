import 'package:flutter/material.dart';
import 'screens/homepage.dart';
import 'screens/categories_page.dart';
import 'screens/source_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Habari App',
        theme: ThemeData.dark(),
        initialRoute: "/",
        routes: {
          "/": (context) => MainPage(),
          "/categories": (context) => CategoriesPage(),
          "/sources": (context) => SourcePage(),
        });
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habari App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              'Hello, Welcome to Habari!',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Your one-stop app for exploring the latest news',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),

            // Button to Top Headlines
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              icon: Icon(Icons.article),
              label: Text('Top Headlines'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 20),

            // Button to Categories
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoriesPage()),
                );
              },
              icon: Icon(Icons.category),
              label: Text('Explore by Categories'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 20),

            // Button to Country-Specific News
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SourcePage()),
                );
              },
              icon: Icon(Icons.source), // Using a relevant icon
              label: Text('Popular Media Outlets'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
