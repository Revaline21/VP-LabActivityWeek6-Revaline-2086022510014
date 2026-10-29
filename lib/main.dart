import 'package:flutter/foundation.dart';
import '../Model/Repository/LibraryRepository.dart';
import '../Model/Service/LibraryService.dart';
import '../Model/Book.dart';
import '../Model/Loan.dart';

class LibraryViewModel extends ChangeNotifier {
  final LibraryRepository _repository;
  bool _isLoading = false;

  LibraryViewModel({LibraryRepository? repository})
      : _repository =
            repository ?? LibraryRepository(service: LibraryService());

  bool get isLoading => _isLoading;
  List<Book> get books => _repository.getAllBooks();
  List<Loan> get loans => _repository.getAllLoans();

  bool checkIsBookAvailable(Book book) => book.availableQuantity > 0;

  int get availableBooksCount =>
      books.where((b) => checkIsBookAvailable(b)).length;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _repository.initData();

    _isLoading = false;
    notifyListeners();
  }
}