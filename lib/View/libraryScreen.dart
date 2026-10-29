import 'package:flutter/material.dart';
import '../ViewModel/library_view_model.dart';
import 'BorrowedBooksScreen.dart';
import 'Widget/BookCard.dart';

class LibraryScreen extends StatefulWidget {
  final LibraryViewModel viewModel;

  const LibraryScreen({super.key, required this.viewModel});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadLibraryData();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        if (widget.viewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Katalog Perpustakaan'),
                Text(
                  'Buku Tersedia: ${widget.viewModel.availableBooksCount}',
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BorrowedBooksScreen(
                      viewModel: widget.viewModel,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
          body: ListView.builder(
            itemCount: widget.viewModel.books.length,
            itemBuilder: (context, index) {
              final book = widget.viewModel.books[index];
              final bool isAvailable = widget.viewModel.checkIsBookAvailable(book);
              
              return BookCard(
                book: book,
                status: isAvailable ? 'Tersedia' : 'Habis',
                onBorrow: () {
                  widget.viewModel.borrowBook(book.id, '');
                  },
                  );
            },
          ),
        );
      },
    );
  }
}