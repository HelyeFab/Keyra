class Language {
  final String code;
  final String name;
  final String flag;

  const Language({
    required this.code,
    required this.name,
    required this.flag,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Language &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          name == other.name &&
          flag == other.flag;

  @override
  int get hashCode => code.hashCode ^ name.hashCode ^ flag.hashCode;

  Language copyWith({
    String? code,
    String? name,
    String? flag,
  }) {
    return Language(
      code: code ?? this.code,
      name: name ?? this.name,
      flag: flag ?? this.flag,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'flag': flag,
    };
  }

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      code: map['code'] as String,
      name: map['name'] as String,
      flag: map['flag'] as String,
    );
  }
}
