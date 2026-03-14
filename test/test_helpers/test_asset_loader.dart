import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TestAssetLoader extends AssetLoader {
  const TestAssetLoader();

  static const Map<String, dynamic> _en = <String, dynamic>{
    'appName': 'What Should I Eat Today?',
    'favorites': 'My Favorite Recipes',
    'noFavoritesYet': 'You do not have any favorite recipes yet.',
    'favoritesOfflineHintTitle': 'Available offline',
    'favoritesOfflineHintBody':
        'Recipes you favorite here stay on this device and can be opened without internet.',
    'offlineFavoritesTitle': 'Showing saved copies',
    'offlineFavoritesBody':
        'These favorites are loaded from local storage until the connection returns.',
    'startCooking': 'Start Cooking!',
    'initialIngredientsSelectorScreenTitle': 'My Kitchen',
    'settingsTitle': 'Settings',
    'creditsTitle': 'Credits',
    'exit': 'Exit',
    'recipes': 'Recipes',
    'loading': 'Loading...',
    'storedIngredientsCount': '{} ingredients saved',
    'hour': 'hour',
    'minutes': 'minutes',
    'seconds': 'seconds',
    'offlineScreenTitle': 'You are offline',
    'offlineScreenBody': 'Offline body',
    'offlineFavoritesSectionTitle': 'Available offline',
    'offlineNoFavoritesBody': 'No offline favorites',
    'offlineBannerTitle': 'No connection',
    'offlineBannerBody': 'Some online features are temporarily unavailable.',
    'maintenanceBody': 'Maintenance body',
    'maintenanceBadge': 'Maintenance mode',
    'maintenanceStaticDescription': 'Static maintenance description',
  };

  static const Map<String, dynamic> _tr = <String, dynamic>{
    'appName': 'Bugun Ne Yesem?',
    'favorites': 'Favoriler',
    'noFavoritesYet': 'Henuz favori yok.',
    'favoritesOfflineHintTitle': 'Cevrimdisi kullanilabilir',
    'favoritesOfflineHintBody':
        'Burada favoriledigin tarifler bu cihazda saklanir ve internet olmadan da acilabilir.',
    'offlineFavoritesTitle': 'Kayitli kopyalar gosteriliyor',
    'offlineFavoritesBody':
        'Baglanti geri gelene kadar bu favoriler cihazdaki yerel kayittan aciliyor.',
    'startCooking': 'Basla',
    'initialIngredientsSelectorScreenTitle': 'Mutfagim',
    'settingsTitle': 'Ayarlar',
    'creditsTitle': 'Emegi Gecenler',
    'exit': 'Cikis',
    'recipes': 'Tarifler',
    'loading': 'Yukleniyor...',
    'storedIngredientsCount': '{} malzeme kayitli',
    'hour': 'Saat',
    'minutes': 'Dakika',
    'seconds': 'Saniye',
    'offlineScreenTitle': 'Cihaz cevrimdisi',
    'offlineScreenBody': 'Cevrimdisi govde',
    'offlineFavoritesSectionTitle': 'Cevrimdisi erisilebilenler',
    'offlineNoFavoritesBody': 'Cevrimdisi favori yok',
    'offlineBannerTitle': 'Baglanti yok',
    'offlineBannerBody':
        'Bazi cevrimici ozellikler gecici olarak kullanilamiyor.',
    'maintenanceBody': 'Bakim govdesi',
    'maintenanceBadge': 'Bakim modu',
    'maintenanceStaticDescription': 'Statik bakim aciklamasi',
  };

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    return locale.languageCode == 'tr' ? _tr : _en;
  }
}

Widget buildTestApp(Widget child) {
  return EasyLocalization(
    supportedLocales: const <Locale>[Locale('en', 'US'), Locale('tr', 'TR')],
    path: 'unused',
    fallbackLocale: const Locale('en', 'US'),
    assetLoader: const TestAssetLoader(),
    child: Builder(
      builder: (context) {
        return MaterialApp(
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          home: child,
        );
      },
    ),
  );
}
