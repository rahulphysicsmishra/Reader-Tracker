
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:reader_tracker/models/book.dart';

class Network {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  Future<List<Book>> searchBooks(String query) async {
    var url = Uri.parse('$_baseUrl?q=$query');
    var response = await http.get(url);

    if(response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data['authors']);
      return [];
    } else {
      throw Exception('Failed to load books');
    }
  }
}