enum WordStatus {
  initial,
  learning,
  reviewing,
  mastered;

  String toJson() => name;
  
  static WordStatus fromJson(String json) {
    return WordStatus.values.firstWhere(
      (status) => status.name == json,
      orElse: () => WordStatus.initial,
    );
  }
}
