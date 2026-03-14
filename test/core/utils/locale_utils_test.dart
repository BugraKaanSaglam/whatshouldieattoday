import 'package:flutter_test/flutter_test.dart';
import 'package:yemek_tarifi_app/core/utils/locale_utils.dart';
import 'package:yemek_tarifi_app/enums/language_enum.dart';

void main() {
  test('languageToLocale maps supported languages correctly', () {
    expect(languageToLocale(Language.turkish).languageCode, 'tr');
    expect(languageToLocale(Language.english).countryCode, 'US');
  });

  test('Language enum helpers fallback to english', () {
    expect(Language.getLanguageFromValue(999), Language.english);
    expect(Language.getLanguageFromString('unknown'), Language.english);
  });
}
