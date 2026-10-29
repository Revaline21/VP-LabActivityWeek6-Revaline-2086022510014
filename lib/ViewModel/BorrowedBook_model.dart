import 'package:flutter/material.dart';
import '../Model/Repository/LibraryRepository.dart';
import '../Model/Book.dart';
import '../Model/Loan.dart';

class BorrowedViewModel extends ChangeNotifier {
  final LibraryRepository _repository;

  BorrowedViewModel({required LibraryRepository repository})
      : _repository = repository;

  double calculateFine(Loan loan, Book book, {DateTime? currentDate}) {
    DateTime endDate = loan.returnDate ?? currentDate ?? DateTime.now();

    if (endDate.isBefore(loan.dueDate) || endDate.isAtSameMomentAs(loan.dueDate)) {
      return 0.0;
    }

    int daysOverdue = endDate.difference(loan.dueDate).inDays;
    if (daysOverdue <= 0) return 0.0;

    int completedWeeks = daysOverdue ~/ 7;
    int remainingDays = daysOverdue % 7;

    double accumulatedFine = 0.0;

    for (int week = 1; week <= completedWeeks; week++) {
      double dailyRateForThisWeek = week * 5000.0;
      accumulatedFine += dailyRateForThisWeek * 7;
    }

    if (remainingDays > 0) {
      int currentWeekNumber = completedWeeks + 1;
      double dailyRateForCurrentWeek = currentWeekNumber * 5000.0;
      accumulatedFine += remainingDays * dailyRateForCurrentWeek;
    }

    double totalFine = accumulatedFine;

    DateTime sixMonthsLater = DateTime(
      loan.dueDate.year,
      loan.dueDate.month + 6,
      loan.dueDate.day,
    );

    if (endDate.isAfter(sixMonthsLater) || endDate.isAtSameMomentAs(sixMonthsLater)) {
      totalFine += book.replacementPrice;
    }

    return totalFine;
  }

List<({Loan loan, Book book, double fine})> get borrowedItems {
  final loans = _repository.getAllLoans();
  final books = _repository.getAllBooks();

  final items = <({Loan loan, Book book, double fine})>[];

for (final loan in loans) {
      final matches = books.where((Book b) => b.id == loan.bookId);
      if (matches.isEmpty) continue;

      final book = matches.first;
      items.add((loan: loan, book: book, fine: calculateFine(loan, book)));
    }
  return items;
}

  void returnBook(String loanId) {
    _repository.returnBook(loanId);
    notifyListeners();
  }
}