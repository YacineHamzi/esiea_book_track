import 'package:biblio_track/biblio_track.dart';
import 'package:biblio_track/book.dart';
import 'package:biblio_track/library.dart';

Future<void> main(List<String> arguments) async {
  // Création de livres
  Book book1 = Book("The Little Prince", author: "Antoine de Saint-Exupéry");
  Book book2 = Book("1984", author: "George Orwell");
  Book book3 = Book("The Plague", author: "Albert Camus");

  // Création d'une bibliothèque
  Library<Book> library = Library<Book>();
  library.add(book1);
  library.add(book2);
  library.add(book3);

  // Affichage des livres disponibles
  library.showAvailableBooks();

  // Emprunt d'un livre avec un stream
  await for (String message in borrowStream(book1)) {
    print(message);
  }

  // Retourner le livre emprunté
  await book1.returnBook();

  // Utilisation de l'extension pour afficher le titre en majuscules
  print(book1.displayUpperCaseTitle());

  // Historique des opérations
  book1.showHistory();
}
