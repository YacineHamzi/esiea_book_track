import 'dart:async';

import 'package:biblio_track/book.dart';

// Fonction pour gérer un Stream d'emprunt de livres
Stream<String> borrowStream(Book book) async* {
  await book.borrow();
  yield "Borrow operation completed for ${book.title}";
}
