import 'dart:async';

import 'package:biblio_track/biblio_track.dart';
import 'package:biblio_track/book.dart';
import 'package:biblio_track/library.dart';
import 'package:test/test.dart';

void main() {
  group('Book class tests', () {
    test('Should create a book with a title and optional author', () {
      // Arrange
      var book = Book('The Little Prince', author: 'Antoine de Saint-Exupéry');

      // Assert
      expect(book.title, equals('The Little Prince'));
      expect(book.author, equals('Antoine de Saint-Exupéry'));
      expect(book.isAvailable, isTrue); // Should be true by default
    });

    test('Should allow borrowing a book if available', () async {
      // Arrange
      var book = Book('1984', author: 'George Orwell');

      // Act
      await book.borrow();

      // Assert
      expect(book.isAvailable, isFalse);
    });

    test('Should not allow borrowing a book if it is already borrowed',
        () async {
      // Arrange
      var book = Book('1984', author: 'George Orwell');
      await book.borrow(); // First borrow

      // Act
      await book.borrow(); // Try to borrow again

      // Assert
      expect(book.isAvailable, isFalse); // Still not available
    });

    test('Should return a book and mark it as available again', () async {
      // Arrange
      var book = Book('1984', author: 'George Orwell');
      await book.borrow();

      // Act
      await book.returnBook();

      // Assert
      expect(book.isAvailable, isTrue);
    });

    test('Should record history when a book is borrowed and returned',
        () async {
      // Arrange
      var book = Book('The Little Prince', author: 'Antoine de Saint-Exupéry');

      // Act
      await book.borrow();
      await book.returnBook();

      // Assert
      expect(
          book.history.length, equals(2)); // Two operations: borrow and return
      expect(
          book.history,
          containsAll(
              ['Borrowed: The Little Prince', 'Returned: The Little Prince']));
    });

    test('Should convert title to uppercase using extension', () {
      // Arrange
      var book = Book('The Little Prince', author: 'Antoine de Saint-Exupéry');

      // Act
      var upperCaseTitle = book.displayUpperCaseTitle();

      // Assert
      expect(upperCaseTitle, equals('THE LITTLE PRINCE'));
    });
  });

  group('Library class tests', () {
    test('Should add books to the library', () {
      // Arrange
      var library = Library<Book>();
      var book = Book('1984', author: 'George Orwell');

      // Act
      library.add(book);

      // Assert
      expect(library.resources.length, equals(1));
      expect(library.resources[0].title, equals('1984'));
    });

    test('Should show only available books', () async {
      // Arrange
      var library = Library<Book>();
      var book1 = Book('1984', author: 'George Orwell');
      var book2 = Book('The Little Prince', author: 'Antoine de Saint-Exupéry');

      // Act
      library.add(book1);
      library.add(book2);
      await book1.borrow(); // Borrow the first book

      // Capture available books
      List<String> availableBooks = [];
      for (var book in library.resources) {
        if (book.isAvailable) {
          availableBooks.add(book.title);
        }
      }

      // Assert
      expect(availableBooks, contains('The Little Prince'));
      expect(availableBooks, isNot(contains('1984')));
    });
  });

  group('Stream test', () {
    test('Should stream a message after borrowing a book', () async {
      // Arrange
      var book = Book('1984', author: 'George Orwell');
      var stream = borrowStream(book);
      var messages = [];

      // Act
      await for (var message in stream) {
        messages.add(message);
      }

      // Assert
      expect(messages.length, equals(1));
      expect(messages[0], equals('Borrow operation completed for 1984'));
    });
  });

  group('Library class tests', () {
    test('Should add resources to the library', () {
      // Arrange
      var library = Library<Book>();
      var book = Book('1984', author: 'George Orwell');

      // Act
      library.add(book);

      // Assert
      expect(library.resources.length, equals(1)); // Le livre doit être ajouté
      expect(library.resources[0].title, equals('1984'));
    });

    test('Should show available books only', () {
      // Arrange
      var library = Library<Book>();
      var book1 = Book('1984', author: 'George Orwell', isAvailable: true);
      var book2 = Book('The Little Prince',
          author: 'Antoine de Saint-Exupéry', isAvailable: false);
      var book3 =
          Book('Moby Dick', author: 'Herman Melville', isAvailable: true);

      // Act
      library.add(book1);
      library.add(book2);
      library.add(book3);

      // Capture available books output using a zone to capture print output
      var output = capturePrint(() {
        library.showAvailableBooks();
      });

      // Assert
      expect(output, contains('Available Books:'));
      expect(output, contains('1984')); // Disponible
      expect(output, isNot(contains('The Little Prince'))); // Non disponible
      expect(output, contains('Moby Dick')); // Disponible
    });
  });

  group('History mixin tests', () {
    test('Should log actions', () {
      // Arrange
      var book = Book('1984', author: 'George Orwell');

      // Act
      book.log('Borrowed');
      book.log('Returned');

      // Assert
      expect(book.history.length, equals(2)); // Deux actions dans l'historique
      expect(book.history, contains('Borrowed'));
      expect(book.history, contains('Returned'));
    });

    test('Should display operation history', () {
      // Arrange
      var book = Book('1984', author: 'George Orwell');
      book.log('Borrowed');
      book.log('Returned');

      // Capture history output using a zone to capture print output
      var output = capturePrint(() {
        book.showHistory();
      });

      // Assert
      expect(output, contains('Operation History:'));
      expect(output, contains('Borrowed'));
      expect(output, contains('Returned'));
    });
  });
}

/// Utility function to capture print statements using Zones.
List<String> capturePrint(void Function() body) {
  var log = <String>[];
  var spec = ZoneSpecification(print: (_, __, ___, String msg) {
    log.add(msg);
  });
  Zone.current.fork(specification: spec).run(body);
  return log;
}
