mixin History {
  List<String> history = [];

  void log(String action) {
    history.add(action);
  }

  void showHistory() {
    print("Operation History:");
    for (var action in history) {
      print(action);
    }
  }
}
