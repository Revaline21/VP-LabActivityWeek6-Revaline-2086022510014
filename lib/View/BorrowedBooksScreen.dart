import 'package:flutter/material.dart';
import '../ViewModel/BorrowedBook_model.dart';
import 'Widget/LoanCard.dart';

class BorrowedBooksScreen extends StatelessWidget {
  const BorrowedBooksScreen({super.key, required this.viewModel});

  final BorrowedViewModel viewModel;

  void _onReturn(BuildContext context, String loanId) {
    final result = viewModel.returnBook(loanId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message),
        backgroundColor: result.success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final items = viewModel.borrowedItems;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Daftar Peminjaman & Denda'),
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
          ),
          body: items.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return LoanCard(
                      bookTitle: item.title,
                      bookAuthor: item.author,
                      borrowDate: item.borrowDate,
                      dueDate: item.dueDate,
                      returnDate: item.returnDate,
                      fineAmount: item.fine,
                      isReturned: item.isReturned,
                      onReturn: () => _onReturn(context, item.loanId),
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.collections_bookmark_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada buku yang dipinjam',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}