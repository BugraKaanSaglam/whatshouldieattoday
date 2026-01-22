import 'dart:ui';

import 'package:yemek_tarifi_app/core/enums/language_enum.dart';

Language detectDeviceLanguage() {
  final Locale deviceLocale = PlatformDispatcher.instance.locale;
  final String code = deviceLocale.languageCode.toLowerCase();
  if (code == 'tr') return Language.turkish;
  return Language.english;
}

Locale languageToLocale(Language lang) {
  switch (lang) {
    case Language.turkish:
      return const Locale('tr', 'TR');
    case Language.english:
      return const Locale('en', 'US');
  }
}
