import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:share/share.dart';

class QuotesDB {
  final List<Map<String, String>> _availableQuotes = [
    {
      "quote": "The only way to do great work is to love what you do.",
      "author": "Steve Jobs",
      "description": "Cofounder of Apple Inc."
    },
    {
      "quote": "Believe you can and you're halfway there.",
      "author": "Theodore Roosevelt",
      "description": "26th President of the United States"
    },
    {
      "quote": "The future belongs to those who believe in the beauty of their dreams.",
      "author": "Eleanor Roosevelt",
      "description": "First Lady of the United States (1933-1945)"
    },
    {
      "quote": "The best way to predict the future is to create it.",
      "author": "Peter Drucker",
      "description": "Management consultant, educator, and author"
    },
    {
      "quote": "Success is not final, failure is not fatal: It is the courage to continue that counts.",
      "author": "Winston Churchill",
      "description": "Prime Minister of the United Kingdom (1940-1945, 1951-1955)"
    },
    {
      "quote": "You miss 100% of the shots you don't take.",
      "author": "Wayne Gretzky",
      "description": "Canadian professional ice hockey player"
    },
    {
      "quote": "Act as if what you do makes a difference. It does.",
      "author": "William James",
      "description": "Philosopher and psychologist"
    },
    {
      "quote": "Success usually comes to those who are too busy to be looking for it.",
      "author": "Henry David Thoreau",
      "description": "Essayist, poet, and philosopher"
    },
    {
      "quote": "Don't watch the clock; do what it does. Keep going.",
      "author": "Sam Levenson",
      "description": "Humorist, writer, and teacher"
    },
    {
      "quote": "Keep your face always toward the sunshine—and shadows will fall behind you.",
      "author": "Walt Whitman",
      "description": "Poet, essayist, and journalist"
    },
    {
      "quote": "Opportunities don't happen. You create them.",
      "author": "Chris Grosser",
      "description": "Entrepreneur"
    },
    {
      "quote": "It is never too late to be what you might have been.",
      "author": "George Eliot",
      "description": "Novelist"
    },
    {
      "quote": "What we achieve inwardly will change outer reality.",
      "author": "Plutarch",
      "description": "Greek biographer and essayist"
    },
    {
      "quote": "The only limit to our realization of tomorrow is our doubts of today.",
      "author": "Franklin D. Roosevelt",
      "description": "32nd President of the United States"
    },
    {
      "quote": "The best revenge is massive success.",
      "author": "Frank Sinatra",
      "description": "Singer, actor, and producer"
    },
    {
      "quote": "Your time is limited, don't waste it living someone else's life.",
      "author": "Steve Jobs",
      "description": "Cofounder of Apple Inc."
    },
    {
      "quote": "The way to get started is to quit talking and begin doing.",
      "author": "Walt Disney",
      "description": "American entrepreneur, animator, and film producer"
    },
    {
      "quote": "Don't be afraid to give up the good to go for the great.",
      "author": "John D. Rockefeller",
      "description": "Business magnate and philanthropist"
    },
    {
      "quote": "I find that the harder I work, the more luck I seem to have.",
      "author": "Thomas Jefferson",
      "description": "3rd President of the United States"
    },
    {
      "quote": "Success is not how high you have climbed, but how you make a positive difference to the world.",
      "author": "Roy T. Bennett",
      "description": "Author"
    },
    {
      "quote": "What lies behind us and what lies before us are tiny matters compared to what lies within us.",
      "author": "Ralph Waldo Emerson",
      "description": "Essayist, lecturer, and poet"
    },
    {
      "quote": "The only place where success comes before work is in the dictionary.",
      "author": "Vidal Sassoon",
      "description": "Hairdresser, businessman, and philanthropist"
    },
    {
      "quote": "Don't count the days, make the days count.",
      "author": "Muhammad Ali",
      "description": "Professional boxer and activist"
    },
    {
      "quote": "The secret of success is to do the common thing uncommonly well.",
      "author": "John D. Rockefeller Jr.",
      "description": "Financier and philanthropist"
    },
    {
      "quote": "The difference between ordinary and extraordinary is that little extra.",
      "author": "Jimmy Johnson",
      "description": "Football coach"
    },
    {
      "quote": "It always seems impossible until it’s done.",
      "author": "Nelson Mandela",
      "description": "Former President of South Africa"
    },
    {
      "quote": "The best preparation for tomorrow is doing your best today.",
      "author": "H. Jackson Brown Jr.",
      "description": "Author"
    },
    {
      "quote": "The purpose of our lives is to be happy.",
      "author": "Dalai Lama",
      "description": "Spiritual leader"
    },
    {
      "quote": "Life is what happens when you're busy making other plans.",
      "author": "John Lennon",
      "description": "Singer-songwriter and peace activist"
    },
    {
      "quote": "Get busy living or get busy dying.",
      "author": "Stephen King",
      "description": "Author"
    }
  ];

  final List<String> _favoriteQuotes = [].cast<String>();

  void addToFavorites(Map<String, String> quote) {
    String quoteString =
        '"${quote["quote"]}" - ${quote["author"]} (${quote["description"]})';

    if (!_favoriteQuotes.contains(quoteString)) {
      _favoriteQuotes.add(quoteString);
      print('Added "$quoteString" to favorites.');
    } else {
      print('The quote is already in the favorites list.');
    }
  }


  UnmodifiableListView<String> get favoriteQuotes {
    return UnmodifiableListView(_favoriteQuotes);
  }

  Map<String, String> getRandomQuote() {
    Random random = Random();
    int index = random.nextInt(_availableQuotes.length);
    return _availableQuotes[index];
  }
  List<Map<String, String>> getMoreQuotes() {
    return _availableQuotes;
  }



  // Optional: Convert JSON to Map and vice versa


  static Map<String, String> fromJson(String jsonString) {
    return jsonDecode(jsonString);
  }

  static String toJson(Map<String, String> quote) {
    return jsonEncode(quote);
  }
}