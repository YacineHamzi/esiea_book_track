import 'dart:async';
import 'package:biblio_track/history.dart';

class Book with History {
  String title;
  String? author; // Auteur optionnel
  bool isAvailable;

  Book(this.title, {this.author, this.isAvailable = true});

  // Méthode asynchrone pour emprunter un livre
  Future<void> borrow() async {
    if (isAvailable) {
      print("Borrowing $title...");
      await Future.delayed(Duration(seconds: 2)); // Simule un délai
      isAvailable = false;
      log("Borrowed: $title");
      print("$title has been borrowed.");
    } else {
      print("$title is not available.");
    }
  }

  // Méthode asynchrone pour retourner un livre
  Future<void> returnBook() async {
    print("Returning $title...");
    await Future.delayed(Duration(seconds: 2)); // Simule un délai
    isAvailable = true;
    log("Returned: $title");
    print("$title has been returned.");
  }
}

extension UpperCaseTitle on Book {
  String displayUpperCaseTitle() => title.toUpperCase();
}
