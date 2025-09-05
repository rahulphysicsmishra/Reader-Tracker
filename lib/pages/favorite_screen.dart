import 'package:flutter/material.dart';
import 'package:reader_tracker/db/database_helper.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: FutureBuilder(
        future: DatabaseHelper.instance.readAllBooks(),
        builder: (context, snapshot) => snapshot.hasData ? ListView.builder(
          itemCount: (snapshot.data as List).length,
          itemBuilder: (context, index) {
            final book = (snapshot.data as List)[index];
            if (book.isFavorite) {
              return Card(
                child: ListTile(
                  leading: book.imageLinks.isNotEmpty
                      ? Image.network(book.imageLinks['thumbnail'] ?? '')
                      : null,
                  title: Text(book.title),
                  subtitle: Text(book.authors.isNotEmpty ? book.authors.join(', ') : 'Unknown Author'),
                ),
              );
            } else {
              return const SizedBox.shrink(); // Return an empty widget for non-favorite books
            }
          },
        ) : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}