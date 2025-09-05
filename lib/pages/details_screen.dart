import 'package:flutter/material.dart';
import 'package:reader_tracker/db/database_helper.dart';
import 'package:reader_tracker/models/book.dart';
import 'package:reader_tracker/utils/book_details_arguments.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as BookDetailsArguments;
    final Book book = args.itemBook;
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              if (book.imageLinks.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(book.imageLinks['thumbnail'] ?? '',
                  fit: BoxFit.cover,
                  ),
                ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (book.authors.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'by ${book.authors.join(', ')}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    'Published: ${book.publishedDate}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey
                  ),
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    'Published: ${book.pageCount} pages',
                    style: const TextStyle(fontSize: 16, color: Colors.grey
                  ),
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    'Published: ${book.language}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey
                  ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  ElevatedButton.icon(onPressed: () async {
                    try {
                      int savedInt = await DatabaseHelper.instance.insert(book);
                      SnackBar snackBar = SnackBar(
                        content: Text("Book saved $savedInt"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } catch (e) {
                      print('Error saving book: $e');
                    }
                  }, 
                  icon: Icon(Icons.save), 
                  label: Text('Save')),
                  ElevatedButton.icon(
                    onPressed: () async{
                    
                    }, 
                    icon: Icon(Icons.favorite), 
                    label:  Text('Favorite')),                  

                  ]
                ),
                Container(
                  margin: const EdgeInsets.all(12.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                    border: Border.all(color: Theme.of(context).colorScheme.secondary),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    book.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            ],
          ),
        ),
      )
    );
  }
}