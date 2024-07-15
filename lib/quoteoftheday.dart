import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';
import 'FavoriteQuotesScreen.dart' as favorites;
import 'FavoriteQuotesScreen.dart';
import 'MoreQuotesScreen.dart' as moreQuotes;
import 'quotes.dart';

class QuoteOfTheDayScreen extends StatefulWidget {
  @override
  _QuoteOfTheDayScreenState createState() => _QuoteOfTheDayScreenState();
}

class _QuoteOfTheDayScreenState extends State<QuoteOfTheDayScreen> {
  final QuotesDB _quoteManager = QuotesDB();
  late Map<String, String> _currentQuote;
  late SharedPreferences _prefs;

  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _currentQuote = _quoteManager.getRandomQuote();
    _loadSharedPreferences();
  }

  Future<void> _loadSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadFavorites();
  }

  void _loadFavorites() {
    List<String>? savedFavorites = _prefs.getStringList('favoriteQuotes');
    if (savedFavorites != null) {
      setState(() {
        _isFavorite = savedFavorites.contains(_currentQuote.toString());
      });
    }
  }

  void _updateQuote() {
    setState(() {
      _currentQuote = _quoteManager.getRandomQuote();
    });
    _prefs.setString('Random Quote Generator', QuotesDB.toJson(_currentQuote));
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _prefs.setString('lastDate', currentDate);
    _loadFavorites(); // Reload favorites after updating the quote
  }

  void _toggleFavorite() {
    String currentQuoteString = _currentQuote.toString();
    List<String> currentFavorites = _prefs.getStringList('favoriteQuotes') ?? [];

    setState(() {
      if (currentFavorites.contains(currentQuoteString)) {
        currentFavorites.remove(currentQuoteString);
        _showSnackbar('Removed from Favorites');
      } else {
        currentFavorites.add(currentQuoteString);
        _showSnackbar('Added to Favorites');
      }
      _prefs.setStringList('favoriteQuotes', currentFavorites);
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            _toggleFavorite(); // Toggle favorite again to undo
          },
        ),
      ),
    );
  }

  void _shareQuote() {
    final String quoteText = "${_currentQuote['quote']} - ${_currentQuote['author']} ${_currentQuote['description']}";

    Share.share(quoteText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Quote'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => favorites.FavoriteQuotesScreen(favorites: []),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.format_quote),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => moreQuotes.MoreQuotesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Colors.white,
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '"${_currentQuote["quote"]}"',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      '- ${_currentQuote["author"]}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[700],
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      '${_currentQuote["description"]}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _toggleFavorite,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
                SizedBox(width: 20.0),
                FloatingActionButton(
                  onPressed: _shareQuote,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.share, color: Colors.blue),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: _updateQuote,
                  child: Text('New Quote', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blueGrey[700], // Text color
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Quote of the Day'),
      ),
      child: SafeArea(
        child: QuoteOfTheDayScreen(),
      ),
    );
  }
}
