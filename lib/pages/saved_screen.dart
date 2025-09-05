import 'package:flutter/material.dart';
import 'package:reader_tracker/db/database_helper.dart';
import 'package:reader_tracker/models/book.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved"),
      ),
      body: FutureBuilder<List<Book>>(
        future: DatabaseHelper.instance.readAllBooks(),
        builder: (context, snapshot) => snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final book = snapshot.data![index];
            return Card(
              child: ListTile(
                leading: book.imageLinks.isNotEmpty
                    ? Image.network(book.imageLinks['thumbnail'] ?? '')
                    : null,
                title: Text(book.title),
                subtitle: Column(
                  children: [
                    Text(book.authors.isNotEmpty ? book.authors.join(', ') : 'Unknown Author'),
                    ElevatedButton.icon(
                      onPressed: () async {
                         await DatabaseHelper.instance
                          .toggleFavoriteStatus(book.id, book.isFavorite)
                          .then((value)=>print("Item favored"));
                      }, 
                      icon: Icon(Icons.favorite),
                      label: Text('Add to favorites'))
                  ],
                ),
              ),
            );
          },
        ) : const Center(child: CircularProgressIndicator()),
        
      ),
    );
  }
}