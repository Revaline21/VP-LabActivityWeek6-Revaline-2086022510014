import 'package:flutter/material.dart';
import '../viewmodel/library_view_model.dart';
import 'Widget/loancard.dart';

class BorrowedBooksScreen extends StatelessWidget {
  final LibraryViewModel viewModel;

  const BorrowedBooksScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final loans = viewModel.loans;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Daftar Peminjaman & Denda'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          body: loans.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: loans.length,
                  itemBuilder: (context, index) {
                    final loan = loans[loans.length - 1 - index];

                    final book = viewModel.getBookById(loan.bookId);
                    final fine = viewModel.getFineForLoan(loan);

                    return LoanCard(
                      bookTitle: book.title,
                      bookAuthor: book.author,
                      borrowDate: loan.borrowDate,
                      dueDate: loan.dueDate,
                      returnDate: loan.returnDate,
                      fineAmount: fine,
                      isReturned: loan.isReturned,
                      onReturn: () {
                        viewModel.returnBook(loan.id);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${book.title} berhasil dikembalikan!'),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
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