import 'package:flutter/material.dart';
import '../../../model/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final BookStatus status;
  final VoidCallback onBorrow;

  const BookCard({
    super.key,
    required this.book,
    required this.status,
    required this.onBorrow,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          book.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(book.author),
        ),
        trailing: book.isAvailable
            ? FilledButton(
                onPressed: onBorrow,
                child: const Text('Pinjam'),
              )
            : Text(
                status.name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}