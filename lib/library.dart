import 'package:biblio_track/book.dart';

class Library<T> {
  List<T> resources = [];

  void add(T resource) {
    resources.add(resource);
  }

  void showAvailableBooks() {
    print("Available Books:");
    for (var resource in resources) {
      if (resource is Book && resource.isAvailable) {
        print(resource.title);
      }
    }
  }
}
