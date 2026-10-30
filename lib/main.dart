import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'Model/Repository/LibraryRepository.dart';
import 'ViewModel/library_view_model.dart';
import 'ViewModel/BorrowedBook_model.dart';
import 'View/libraryScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');

  final repository = LibraryRepository();
  final libraryVM = LibraryViewModel(repository: repository);
  final borrowedVM = BorrowedViewModel(repository: repository);
  await libraryVM.loadLibraryData();

  runApp(LibraryApp(libraryVM: libraryVM, borrowedVM: borrowedVM));
}

class LibraryApp extends StatefulWidget {
  const LibraryApp({
    super.key,
    required this.libraryVM,
    required this.borrowedVM,
  });

  final LibraryViewModel libraryVM;
  final BorrowedViewModel borrowedVM;

  @override
  State<LibraryApp> createState() => _LibraryAppState();
}

class _LibraryAppState extends State<LibraryApp> {
  @override
  void dispose() {
    widget.libraryVM.dispose();
    widget.borrowedVM.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Perpustakaan',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: LibraryScreen(
        viewModel: widget.libraryVM,
        borrowedViewModel: widget.borrowedVM,
      ),
    );
  }
}