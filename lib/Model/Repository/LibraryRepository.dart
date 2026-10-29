import '../Book.dart';
import '../Loan.dart';
import '../Service/LibraryService.dart';

class LibraryRepository {
  final LibraryService service;

  LibraryRepository({required this.service});

  Future<void> initData() => service.init();

  List<Book> getAllBooks() => service.readBooks();

  List<Loan> getAllLoans() => service.readLoans();

  bool isBookAvailable(String bookId) {
    final book = service.readBooks().where((b) => b.id == bookId).firstOrNull;
    return book != null && book.availableQuantity > 0;
  }

  bool borrowBook(String bookId, String studentId) {
    final books = service.readBooks();
    final index = books.indexWhere((b) => b.id == bookId);
    if (index == -1 || books[index].availableQuantity <= 0) return false;

    books[index].availableQuantity -= 1; // stok berkurang
    service.writeBooks(books);

    final now = DateTime.now();
    final loans = service.readLoans();
    loans.add(
      Loan(
        id: 'LN-${now.millisecondsSinceEpoch}',
        bookId: bookId,
        studentId: studentId,
        borrowDate: now,
        dueDate: now.add(const Duration(days: 14)),
      ),
    );
    service.writeLoans(loans);
    return true;
  }

  bool returnBook(String loanId) {
    final loans = service.readLoans();
    final loanIndex = loans.indexWhere((l) => l.id == loanId);
    if (loanIndex == -1 || loans[loanIndex].returnDate != null) return false;

    loans[loanIndex].returnDate = DateTime.now();
    service.writeLoans(loans);

    final books = service.readBooks();
    final bookIndex = books.indexWhere((b) => b.id == loans[loanIndex].bookId);
    if (bookIndex != -1) {
      books[bookIndex].availableQuantity += 1; // stok bertambah
      service.writeBooks(books);
    }
    return true;
  }
}