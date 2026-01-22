enum Language {
  turkish(0, "Türkçe", "tr-TR"),
  english(1, "English", "en-US");

  const Language(this.value, this.name, this.shortName);
  final int value;
  final String name;
  final String shortName;
  static Language getLanguageFromValue(int? value) {
    switch (value) {
      case 0:
        return Language.turkish;
      case 1:
        return Language.english;
      default:
        return Language.english;
    }
  }

  static Language getLanguageFromString(String? value) {
    switch (value) {
      case 'tr':
        return Language.turkish;
      case 'en':
        return Language.english;
      default:
        return Language.english;
    }
  }
}
