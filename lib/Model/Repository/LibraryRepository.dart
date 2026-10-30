import '../Book.dart';
import '../Loan.dart';
import '../Service/LibraryService.dart';

class LibraryRepository {
  final LibraryService _service;

  LibraryRepository({LibraryService? service})
      : _service = service ??  LibraryService();

  Future<void> initData() => _service.init();

  List<Book> getAllBooks() => _service.readBooks();

  List<Loan> getAllLoans() => _service.readLoans();

  bool isBookAvailable(String bookId) {
    final book = _service.readBooks().where((b) => b.id == bookId).firstOrNull;
    return book != null && book.availableQuantity > 0;
  }

  bool borrowBook(String bookId, String studentId) {
    final books = _service.readBooks();
    final index = books.indexWhere((b) => b.id == bookId);
    if (index == -1 || books[index].availableQuantity <= 0) return false;
    books[index].availableQuantity -= 1;
    _service.writeBooks(books);

    final now = DateTime.now();
    final loans = _service.readLoans();
    loans.add(
      Loan(
        id: 'LN-${now.millisecondsSinceEpoch}',
        bookId: bookId,
        studentId: studentId,
        borrowDate: now,
        dueDate: now.add(const Duration(days: 14)),
      ),
    );
    _service.writeLoans(loans);
    return true;
  }

  bool returnBook(String loanId) {
    final loans = _service.readLoans();
    final loanIndex = loans.indexWhere((l) => l.id == loanId);
    if (loanIndex == -1 || loans[loanIndex].returnDate != null) return false;

    loans[loanIndex].returnDate = DateTime.now();
    _service.writeLoans(loans);

    final books = _service.readBooks();
    final bookIndex = books.indexWhere((b) => b.id == loans[loanIndex].bookId);
    if (bookIndex != -1) {
      books[bookIndex].availableQuantity += 1;
      _service.writeBooks(books);
    }
    return true;
  }
}