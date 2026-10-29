import 'package:flutter/material.dart';
import '../Model/Repository/LibraryRepository.dart';
import '../model/book.dart';
import '../model/loan.dart';

class LibraryViewModel extends ChangeNotifier {
  final LibraryRepository _repository;
  bool _isLoading = false;

  LibraryViewModel({required LibraryRepository repository}) : _repository = repository;

  bool get isLoading => _isLoading;
  List<Book> get books => _repository.getAllBooks();
  List<Loan> get loans => _repository.getAllLoans();
  
  bool checkIsBookAvailable(Book book) {
    return book.availableQuantity > 0;
  }

  int get availableBooksCount => 
      (_repository.getAllBooks() as List<Book>).where((b) => checkIsBookAvailable(b)).length;

  Future<void> loadLibraryData() async {
    _isLoading = true;
    notifyListeners();

    await _repository.initData();

    _isLoading = false;
    notifyListeners();
  }

  Book getBookById(String bookId) {
    return _repository.getAllBooks().firstWhere(
      (Book b) => b.id == bookId,
      orElse: () => Book(
        id: '',
        title: 'Tidak Ditemukan',
        author: '-',
        replacementPrice: 0.0,
        totalQuantity: 0,
        availableQuantity: 0,
      ),
    );
  }


  double getFineForLoan(Loan loan) {
    if (loan.isReturned) return 0.0;
    
    final now = DateTime.now();
    if (now.isAfter(loan.dueDate)) {
      final daysLate = now.difference(loan.dueDate).inDays;
      const double finePerDay = 1000.0;
      return daysLate * finePerDay;
    }
    return 0.0;
  }

  void borrowBook(String bookId, String studentId) {
    bool success = _repository.borrowBook(bookId, studentId);
    if (success) notifyListeners();
  }

  void returnBook(String loanId) {
    _repository.returnBook(loanId);
    notifyListeners();
  }
}