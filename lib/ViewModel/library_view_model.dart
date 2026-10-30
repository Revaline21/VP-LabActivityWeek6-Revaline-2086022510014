import 'package:flutter/material.dart';
import '../Model/Repository/LibraryRepository.dart';
import '../Model/Book.dart';

typedef CatalogItem = ({
  String id,
  String title,
  String author,
  String stockLabel,
  bool canBorrow,
});

class LibraryViewModel extends ChangeNotifier {
  final LibraryRepository _repository;
  bool _isLoading = false;

  LibraryViewModel({LibraryRepository? repository})
      : _repository = repository ?? LibraryRepository();

  bool get isLoading => _isLoading;
  bool get hasBooks => _books.isNotEmpty;

  List<CatalogItem> get catalogItems => _books
      .map((b) => (
            id: b.id,
            title: b.title,
            author: b.author,
            stockLabel: _stockLabel(b),
            canBorrow: _canBorrow(b),
          ))
      .toList();

  int get availableBooksCount => _books.where(_canBorrow).length;

  String get availabilitySummary =>
      '$availableBooksCount dari ${_books.length} judul tersedia';

  List<Book> get _books => _repository.getAllBooks();

  bool _canBorrow(Book book) => book.availableQuantity > 0;

  String _stockLabel(Book book) => _canBorrow(book)
      ? 'Stok: ${book.availableQuantity} / ${book.totalQuantity}'
      : 'Stok habis (0 / ${book.totalQuantity})';

  Future<void> loadLibraryData() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.initData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}