import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../Book.dart';
import '../Loan.dart';

class LibraryService {
  static const String _booksAsset = 'assets/data/books.json';

  static final List<Book> _books = [];
  static final List<Loan> _loans = [];
  static bool _loaded = false;

  Future<void> init() async {
    if (_loaded) return;
    final raw = await rootBundle.loadString(_booksAsset);
    final list = jsonDecode(raw) as List<dynamic>;
    _books
      ..clear()
      ..addAll(list.map((e) => Book.fromJson(e as Map<String, dynamic>)));
    _loaded = true;
  }

  List<Book> readBooks() => List.of(_books);

  void writeBooks(List<Book> books) {
    final copy = List.of(books);
    _books..clear()..addAll(copy);
  }

  List<Loan> readLoans() => List.of(_loans);

  void writeLoans(List<Loan> loans) {
    final copy = List.of(loans);
    _loans..clear()..addAll(copy);
  }
}