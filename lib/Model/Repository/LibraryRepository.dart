import 'package:flutter/material.dart';
import '../Service/LibraryService.dart';
import '../Model/Book.dart';
import '../Model/Loan.dart';

class LibraryRepository {
  final LibraryService service;
  final List<Book> _books = [];
  final List<Loan> _loans = [];
  LibraryRepository({required this.service});
  Future<void> initData() async {
    if (_books.isNotEmpty) return;
    final Map<String, dynamic> rawData = await service.fetchLibraryData();
    if (rawData.containsKey('books')) {
      final List<dynamic> booksJson = rawData['books'];
      _books.addAll(booksJson.map((json) => Book.fromJson(json)).toList());
    }
    if (rawData.containsKey('loans')) {
      final List<dynamic> loansJson = rawData['loans'];
      _loans.addAll(loansJson.map((json) => Loan.fromJson(json)).toList());
    }
  }
  List<Book> getAllBooks() => _books;
  List<Loan> getAllLoans() => _loans;
  bool borrowBook(String bookId, String studentId) {
    final bookIndex = _books.indexWhere((b) => b.id == bookId);
    if (bookIndex == -1 || _books[bookIndex].availableQuantity <= 0) {
      return false; 
    }

    final now = DateTime.now();
    final dueDate = now.add(const Duration(days: 14));
    final newLoan = Loan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bookId: bookId,
      studentId: studentId,
      borrowDate: now,
      dueDate: dueDate,
      returnDate: null,
    );
    _loans.add(newLoan);
    _books[bookIndex].availableQuantity -= 1;
    
    return true;
  }
  void returnBook(String loanId) {
    final loanIndex = _loans.indexWhere((l) => l.id == loanId);
    if (loanIndex == -1 || _loans[loanIndex].isReturned) {
      return; 
    }
    _loans[loanIndex].returnDate = DateTime.now();
    final bookId = _loans[loanIndex].bookId;
    final bookIndex = _books.indexWhere((b) => b.id == bookId);
    if (bookIndex != -1) {
      _books[bookIndex].availableQuantity += 1;
    }
  }
}