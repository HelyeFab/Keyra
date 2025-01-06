class AppStrings {
  // App info
  static const String appName = 'Keyra';
  static const String appTagline = 'Learn while you Read';

  // Splash screen messages
  static const List<List<String>> splashMessages = [
    [
      "Downloading dictionary entries... 📚",
      "Téléchargement des entrées du dictionnaire... 📚",
      "Descargando entradas del diccionario... 📚",
      "Wörterbucheinträge werden heruntergeladen... 📚",
      "辞書のエントリをダウンロード中... 📚",
    ],
    [
      "Processing Japanese words... 🎌",
      "Traitement des mots japonais... 🎌",
      "Procesando palabras japonesas... 🎌",
      "Verarbeitung japanischer Wörter... 🎌",
      "日本語の単語を処理中... 🎌",
    ],
    [
      "Building your fabulous library... 📖",
      "Construction de votre bibliothèque fabuleuse... 📖",
      "Construyendo tu fabulosa biblioteca... 📖",
      "Aufbau Ihrer fabelhaften Bibliothek... 📖",
      "素晴らしいライブラリを構築中... 📖",
    ],
    [
      "Organizing kanji and vocabulary... ✨",
      "Organisation des kanjis et du vocabulaire... ✨",
      "Organizando kanji y vocabulario... ✨",
      "Kanji und Vokabeln organisieren... ✨",
      "漢字と語彙を整理中... ✨",
    ],
    [
      "Preparing your learning journey... 🚀",
      "Préparation de votre voyage d'apprentissage... 🚀",
      "Preparando tu viaje de aprendizaje... 🚀",
      "Vorbereitung Ihrer Lernreise... 🚀",
      "学びの旅を準備中... 🚀",
    ],
  ];

  // Dictionary modal messages
  static String findingExamplesFor(String word) => 'Finding examples for "$word"...';

  // Language indices for reference
  static const int englishIndex = 0;
  static const int frenchIndex = 1;
  static const int spanishIndex = 2;
  static const int germanIndex = 3;
  static const int japaneseIndex = 4;

  // Section titles
  static const String examples = 'Examples:';

}
