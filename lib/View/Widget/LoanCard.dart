import 'package:flutter/material.dart';

class LoanCard extends StatelessWidget {
  const LoanCard({
    super.key,
    required this.bookTitle,
    required this.bookAuthor,
    required this.borrowDate,
    required this.dueDate,
    required this.returnDate,
    required this.fineAmount,
    required this.isReturned,
    required this.onReturn,
  });

  final String bookTitle;
  final String bookAuthor;
  final DateTime borrowDate;
  final DateTime dueDate;
  final DateTime? returnDate;
  final double fineAmount;
  final bool isReturned;
  final VoidCallback onReturn;

  @override
  Widget build(BuildContext context) {
    final l10n = MaterialLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bookTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(bookAuthor),
            const SizedBox(height: 8),
            Text('Dipinjam: ${l10n.formatShortDate(borrowDate)}'),
            Text('Jatuh tempo: ${l10n.formatShortDate(dueDate)}'),
            Text(
              'Dikembalikan: ${returnDate == null ? '-' : l10n.formatShortDate(returnDate!)}',
            ),
            Text(
              'Denda: Rp ${fineAmount.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: isReturned ? null : onReturn,
                child: Text(isReturned ? 'Sudah dikembalikan' : 'Kembalikan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}