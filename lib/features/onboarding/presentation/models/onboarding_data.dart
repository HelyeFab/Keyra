class OnboardingData {
  final String title;
  final String description;
  final String imagePath;
  bool isFavorite;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
    this.isFavorite = false,
  });

  OnboardingData copyWith({
    String? title,
    String? description,
    String? imagePath,
    bool? isFavorite,
  }) {
    return OnboardingData(
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

final List<OnboardingData> onboardingPages = [
  OnboardingData(
    title: 'Welcome to Your Language Adventure!',
    description: 'Bonjour! こんにちは! ¡Hola! I\'m Keyra, your new reading buddy! 📚🌍  I\'ll guide you through magical AI-created stories filled with colourful worlds and playful adventures. Together, we\'ll explore new languages and make learning fun!',
    imagePath: 'assets/images/onboarding/keyra01.png',
  ),
  OnboardingData(
    title: 'Stories That Speak to You!',
    description: 'Did you know stories have superpowers? ✨ They help you learn words, understand cultures, and spark your imagination! Whether it\'s French, Japanese, Spanish, Italian or English, my books are here to make you smile, learn, and grow – one story at a time!',
    imagePath: 'assets/images/onboarding/keyra02.png',
  ),
  OnboardingData(
    title: 'Let\'s Start Your Journey!',
    description: 'Grab your book 📖, choose your language 🚀, and let\'s dive into a world of magical tales! I\'ll be right here to cheer you on. Who said learning a new language couldn\'t be fun? 🌟 Let\'s make your adventure unforgettable!',
    imagePath: 'assets/images/onboarding/keyra03.png',
  ),
];
