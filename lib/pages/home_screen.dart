import 'package:flutter/material.dart';
import 'package:reader_tracker/models/book.dart';
import 'package:reader_tracker/network/network.dart';
import 'package:reader_tracker/pages/details_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Network network = Network();
  List <Book> _books = [];

  Future<void> _searchBooks(String query) async {
    try {
      List<Book> books = await network.searchBooks(query);
      //print("Books: ${books.toString()}");
      setState(() {
        _books = books;
      });
    } catch (e) {
      
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Books",
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  )
                ),
                onSubmitted: (query)=>_searchBooks(query),
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: _books.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  childAspectRatio: 0.6,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        // Handle book tap, e.g., navigate to detail page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookDetailsScreen(),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _books[index].imageLinks.containsKey('thumbnail') ? 
                          Image.network(
                            _books[index].imageLinks['thumbnail']!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ) : Container(
                            height: 150,
                            color: Colors.grey,
                            child: const Center(child: Text("No Image")),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _books[index].title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              _books[index].authors.isNotEmpty ? _books[index].authors.join(", ") : "Unknown Author",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }))
            // Expanded(
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: ListView.builder(
            //       itemCount: _books.length,
            //       itemBuilder: (context, index) {
            //         Book book = _books[index];
            //         return ListTile(
            //           title: Text(book.title),
            //           subtitle: Text(book.authors.join(", ")),
            //         );
            //       },
            //     ),
            //   ),
            // )

          ],
        ),
      ),
    );
  }
}