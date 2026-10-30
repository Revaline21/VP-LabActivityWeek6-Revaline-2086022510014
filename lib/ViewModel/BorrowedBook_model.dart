import 'package:flutter/material.dart';
import '../Model/Repository/LibraryRepository.dart';
import '../Model/Book.dart';
import '../Model/Loan.dart';

class BorrowResult {
  const BorrowResult(this.success, this.message);
  final bool success;
  final String message;
}
typedef BorrowedItem = ({
  String loanId,
  String title,
  String author,
  DateTime borrowDate,
  DateTime dueDate,
  DateTime? returnDate,
  double fine,
  bool isReturned,
});

class BorrowedViewModel extends ChangeNotifier {
  final LibraryRepository _repository;

  BorrowedViewModel({LibraryRepository? repository})
      : _repository = repository ?? LibraryRepository();


  static const double _rateStep = 5000;
  static const int _daysPerWeek = 7;
  static const int _maxWeekTier = 3;

  DateTime _replacementDeadline(Loan loan) => DateTime(
        loan.dueDate.year,
        loan.dueDate.month + 6,
        loan.dueDate.day,
      );

  int _daysOverdue(Loan loan, {DateTime? currentDate}) {
    final endDate = loan.returnDate ?? currentDate ?? DateTime.now();
    if (!endDate.isAfter(loan.dueDate)) return 0;
    return endDate.difference(loan.dueDate).inDays;
  }

  bool _mustReplaceBook(Loan loan, {DateTime? currentDate}) {
    final endDate = loan.returnDate ?? currentDate ?? DateTime.now();
    return !endDate.isBefore(_replacementDeadline(loan));
  }

  double _calculateFine(Loan loan, Book book, {DateTime? currentDate}) {
    final days = _daysOverdue(loan, currentDate: currentDate);
    if (days <= 0) return 0.0;

    var total = 0.0;
    for (var day = 1; day <= days; day++) {
      final weekNumber = (day - 1) ~/ _daysPerWeek + 1;
      final tier = weekNumber > _maxWeekTier ? _maxWeekTier : weekNumber;
      total += tier * _rateStep;
    }

    if (_mustReplaceBook(loan, currentDate: currentDate)) {
      total += book.replacementPrice;
    }
    return total;
  }
  List<BorrowedItem> get borrowedItems {
    final loans = _repository.getAllLoans();
    final books = _repository.getAllBooks();

    final items = <BorrowedItem>[];
    for (final loan in loans) {
      final matches = books.where((b) => b.id == loan.bookId);
      if (matches.isEmpty) continue;

      final book = matches.first;
      items.add((
        loanId: loan.id,
        title: book.title,
        author: book.author,
        borrowDate: loan.borrowDate,
        dueDate: loan.dueDate,
        returnDate: loan.returnDate,
        fine: _calculateFine(loan, book),
        isReturned: loan.isReturned,
      ));
    }
    return items.reversed.toList(); 
  }

  int get activeLoansCount =>
    _repository.getAllLoans().where((l) => !l.isReturned).length;

  BorrowResult borrowBook(String bookId, String borrowerId) {
    final id = borrowerId.trim();
    if (id.isEmpty) {
      return const BorrowResult(false, 'ID/nama peminjam wajib diisi');
    }
    if (!_repository.isBookAvailable(bookId)) {
      return const BorrowResult(false, 'Stok buku habis');
    }
    if (!_repository.borrowBook(bookId, id)) {
      return const BorrowResult(false, 'Gagal meminjam buku');
    }

    final title = _bookTitle(bookId);
    notifyListeners();
    return BorrowResult(true, '"$title" berhasil dipinjam');
  }

  BorrowResult returnBook(String loanId) {
    final loanMatches = _repository.getAllLoans().where((l) => l.id == loanId);
    final bookId = loanMatches.isEmpty ? '' : loanMatches.first.bookId;

    if (!_repository.returnBook(loanId)) {
      return const BorrowResult(false, 'Gagal mengembalikan buku');
    }

    final title = _bookTitle(bookId);
    notifyListeners();
    return BorrowResult(true, '$title berhasil dikembalikan!');
  }

  String _bookTitle(String bookId) {
    final matches = _repository.getAllBooks().where((b) => b.id == bookId);
    return matches.isEmpty ? 'Buku' : matches.first.title;
  }
}