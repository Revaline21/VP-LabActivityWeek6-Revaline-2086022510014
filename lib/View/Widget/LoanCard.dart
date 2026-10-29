import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanCard extends StatelessWidget {
  final String bookTitle;
  final String bookAuthor;
  final DateTime borrowDate;
  final DateTime dueDate;
  final DateTime? returnDate;
  final double fineAmount;
  final bool isReturned;
  final VoidCallback onReturn;

  const LoanCard({
    super.key,
    required this.bookTitle,
    required this.bookAuthor,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    required this.fineAmount,
    required this.isReturned,
    required this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd MMM yyyy');
    final isOverdue = fineAmount > 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bookTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'Penulis: $bookAuthor',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tanggal Pinjam:', style: TextStyle(color: Colors.grey)),
                Text(dateFormatter.format(borrowDate)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tenggat Waktu (Due):', style: TextStyle(color: Colors.grey)),
                Text(
                  dateFormatter.format(dueDate),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isOverdue && !isReturned ? Colors.red : null,
                  ),
                ),
              ],
            ),
            if (isReturned && returnDate != null) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Dikembalikan Pada:', style: TextStyle(color: Colors.grey)),
                  Text(dateFormatter.format(returnDate!)),
                ],
              ),
            ],
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Denda:', style: TextStyle(fontSize: 12)),
                    Text(
                      'Rp ${fineAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isOverdue ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
                if (!isReturned)
                  OutlinedButton.icon(
                    onPressed: onReturn,
                    icon: const Icon(Icons.keyboard_return),
                    label: const Text('Kembalikan'),
                  )
                else
                  const Chip(
                    label: Text('SELESAI'),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}