import 'package:flutter/material.dart';
import '../ViewModel/library_view_model.dart';
import '../ViewModel/BorrowedBook_model.dart';
import 'BorrowedBooksScreen.dart';
import 'Widget/BookCard.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({
    super.key,
    required this.viewModel,
    required this.borrowedViewModel,
  });

  final LibraryViewModel viewModel;
  final BorrowedViewModel borrowedViewModel;

  Future<String?> _askBorrowerId(BuildContext context, String bookTitle) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Pinjam "$bookTitle"'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'ID / Nama Peminjam'),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Pinjam'),
          ),
        ],
      ),
    );
  }

  void _openBorrowed(NavigatorState navigator) {
    navigator.push(
      MaterialPageRoute(
        builder: (_) => BorrowedBooksScreen(viewModel: borrowedViewModel),
      ),
    );
  }

  Future<void> _onBorrowPressed(
    BuildContext context,
    String bookId,
    String bookTitle,
  ) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final input = await _askBorrowerId(context, bookTitle);
    if (input == null) return;

    final result = borrowedViewModel.borrowBook(bookId, input);
    if (result.success) {
      _openBorrowed(navigator);
    } else {
      messenger.showSnackBar(SnackBar(content: Text(result.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: Listenable.merge([viewModel, borrowedViewModel]),
      builder: (context, _) {
        final items = viewModel.catalogItems;

        if (viewModel.isLoading && !viewModel.hasBooks) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Katalog Perpustakaan'),
                Text(
                  viewModel.availabilitySummary,
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.onPrimary.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Buku dipinjam',
                icon: Badge(
                  label: Text('${borrowedViewModel.activeLoansCount}'),
                  isLabelVisible: borrowedViewModel.activeLoansCount > 0,
                  child: const Icon(Icons.bookmark_border),
                ),
                onPressed: () => _openBorrowed(Navigator.of(context)),
              ),
            ],
          ),
          body: items.isEmpty
              ? const Center(child: Text('Belum ada buku'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return BookCard(
                      title: item.title,
                      author: item.author,
                      stockLabel: item.stockLabel,
                      canBorrow: item.canBorrow,
                      onBorrow: () =>
                          _onBorrowPressed(context, item.id, item.title),
                    );
                  },
                ),
        );
      },
    );
  }
}