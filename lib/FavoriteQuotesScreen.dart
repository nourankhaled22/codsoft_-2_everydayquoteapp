import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';

class FavoriteQuotesScreen extends StatelessWidget {
  final List<String> favorites;

  FavoriteQuotesScreen({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return FavoriteQuotesScreenStateful(favorites: favorites);
  }
}

class FavoriteQuotesScreenStateful extends StatefulWidget {
  final List<String> favorites;

  FavoriteQuotesScreenStateful({required this.favorites});

  @override
  _FavoriteQuotesScreenState createState() => _FavoriteQuotesScreenState();
}

class _FavoriteQuotesScreenState extends State<FavoriteQuotesScreenStateful> {
  final ScrollController _scrollController = ScrollController();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites = _prefs.getStringList('favoriteQuotes');
    if (savedFavorites != null) {
      setState(() {
        widget.favorites.addAll(savedFavorites);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Quotes',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7F00FF), Color(0xFFE100FF)], // Match gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: widget.favorites.isEmpty
            ? Center(
          child: Text(
            'No favorite quotes yet',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
            : Scrollbar(
          controller: _scrollController,
          thumbVisibility: true, // Optional: to always show the scrollbar
          child: ListView.builder(
            controller: _scrollController,
            itemCount: widget.favorites.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(widget.favorites[index]),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.0),
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  _removeFromFavorites(widget.favorites[index]);
                },
                child: Card(
                  color: Colors.white,
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      widget.favorites[index],
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                      ),
                    ),
                    leading: Icon(Icons.format_quote,
                        color: Colors.deepPurple[700]),
                    trailing: IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        _shareQuote(widget.favorites[index]);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _removeFromFavorites(String quote) async {
    List<String> updatedFavorites = List.from(widget.favorites);
    updatedFavorites.remove(quote);
    await _prefs.setStringList('favoriteQuotes', updatedFavorites);
    setState(() {
      widget.favorites.remove(quote);
    });
  }

  void _shareQuote(String quote) {
    final String quoteText = '"$quote"';
    Share.share(quoteText);
  }
}