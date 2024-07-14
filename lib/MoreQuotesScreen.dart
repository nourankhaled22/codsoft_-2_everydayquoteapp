import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';
import 'quotes.dart'; // Import your quotes data or logic here

class MoreQuotesScreen extends StatefulWidget {
  @override
  _MoreQuotesScreenState createState() => _MoreQuotesScreenState();
}

class _MoreQuotesScreenState extends State<MoreQuotesScreen> {
  final QuotesDB _quotesDB = QuotesDB(); // Create an instance of QuotesDB
  Set<String> favoriteQuotes = Set();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites = prefs.getStringList('favoriteQuotes');
    if (savedFavorites != null) {
      setState(() {
        favoriteQuotes.addAll(savedFavorites);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> moreQuotes = _quotesDB.getMoreQuotes(); // Access instance method
    return Scaffold(
      appBar: AppBar(
        title: Text('More Quotes'),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: moreQuotes.length,
        itemBuilder: (context, index) {
          String quote = moreQuotes[index]["quote"] ?? "";
          String author = moreQuotes[index]["author"] ?? "";
          String description = moreQuotes[index]["description"] ?? "";

          bool isFavorite = favoriteQuotes.contains('"$quote" - $author ($description)');

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"$quote"',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '- $author',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[700],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          _toggleFavorite(quote, author, description);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          _shareQuote(quote, author);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _toggleFavorite(String quote, String author, String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String quoteString = '"$quote" - $author ($description)';

    setState(() {
      if (favoriteQuotes.contains(quoteString)) {
        favoriteQuotes.remove(quoteString);
      } else {
        favoriteQuotes.add(quoteString);
      }
    });
    prefs.setStringList('favoriteQuotes', favoriteQuotes.toList());
  }

  void _shareQuote(String quote, String author) {
    final String quoteText = '"$quote" - $author';
    Share.share(quoteText);
  }
}

class FavoriteQuotesScreen extends StatefulWidget {
  @override
  _FavoriteQuotesScreenState createState() => _FavoriteQuotesScreenState();
}

class _FavoriteQuotesScreenState extends State<FavoriteQuotesScreen> {
  List<Map<String, String>> favoriteQuotes = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites = prefs.getStringList('favoriteQuotes');
    if (savedFavorites != null) {
      setState(() {
        favoriteQuotes = savedFavorites.map((quoteString) {
          var parts = quoteString.split(' - ');
          var description = parts[1].substring(parts[1].indexOf('(') + 1, parts[1].indexOf(')'));
          var author = parts[1].substring(0, parts[1].indexOf('(')).trim();
          return {
            'quote': parts[0].replaceAll('"', ''),
            'author': author,
            'description': description,
          };
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Quotes'),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: favoriteQuotes.length,
        itemBuilder: (context, index) {
          String quote = favoriteQuotes[index]["quote"] ?? "";
          String author = favoriteQuotes[index]["author"] ?? "";
          String description = favoriteQuotes[index]["description"] ?? "";

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"$quote"',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '- $author',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[700],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
