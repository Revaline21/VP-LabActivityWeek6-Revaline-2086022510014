import 'package:flutter/material.dart';
import '../ViewModel/library_view_model.dart';
import '../ViewModel/BorrowedBook_model';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LibraryViewModel()),
        ChangeNotifierProvider(create: (_) => BorrowedViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}