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
    'initialIngredientsText1': 'Save ingredients once for faster cooking.',
    'settingsTitle': 'Settings',
    'settingsHeroTitle': 'Make the app yours',
    'settingsHeroBody':
        'Keep language, offline favorites, and sharing tools in one clean place.',
    'settingsPreferencesTitle': 'Preferences',
    'settingsPreferencesBody':
        'Choose how the app feels on this device and save it once.',
    'settingsFavoritesStat': '{} favorites saved',
    'select_language': 'Select Language',
    'Turkish': 'Turkish',
    'English': 'English',
    'creditsTitle': 'Credits',
    'exit': 'Exit',
    'recipes': 'Recipes',
    'homeHeroTitle': 'Cook faster with what you have',
    'homeHeroBody':
        'Search recipes, keep favorites on-device, and jump back into cooking without friction.',
    'loading': 'Loading...',
    'storedIngredientsCount': '{} ingredients saved',
    'ingredients': 'Ingredients',
    'timeInfo': 'Time Info',
    'contents': 'Contents',
    'recipeSteps': 'Recipe Steps',
    'sendFeedback': 'Send Feedback',
    'prepTime': 'Prep Time',
    'cookTime': 'Cook Time',
    'totalTime': 'Total Time',
    'unknown': 'Unknown',
    'calories': 'Calories',
    'fat': 'Fat',
    'saturatedfat': 'Saturated Fat',
    'colestrol': 'Colestrol',
    'sodium': 'Sodium',
    'carbohydrate': 'Carbohydrate',
    'fiber': 'Fiber',
    'sugar': 'Sugar',
    'protein': 'Protein',
    'recipeInfo': 'Recipe Info',
    'shareRecipeMessage': 'You should try this recipe! 👉 {}',
    'shareFallback': 'Sharing failed, link copied to clipboard.',
    'shareAppTitle': 'Share the app',
    'shareAppBody':
        'Send the App Store and Google Play links so friends can install the right version instantly.',
    'shareAppAction': 'Share app',
    'shareAppMessage':
        'Try What Should I Eat Today?\n\nApp Store: {}\nGoogle Play: {}',
    'linkCopied': 'Link copied: {}',
    'openAppStore': 'Open App Store',
    'openPlayStore': 'Open Google Play',
    'save': 'Save',
    'languageSaved': 'Settings saved.',
    'couldNotOpenLink': 'Could not open the link. Please try again.',
    'cuisineLabel': 'Cuisine',
    'person': 'Person',
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
    'initialIngredientsText1':
        'Malzemeleri bir kez kaydet, sonra daha hizli pisir.',
    'settingsTitle': 'Ayarlar',
    'settingsHeroTitle': 'Uygulamayi kendine gore ayarla',
    'settingsHeroBody':
        'Dil, cevrimdisi favoriler ve paylasim araclarini tek alanda yonet.',
    'settingsPreferencesTitle': 'Tercihler',
    'settingsPreferencesBody':
        'Bu cihazdaki deneyimi ayarla ve bir kez kaydet.',
    'settingsFavoritesStat': '{} favori kayitli',
    'select_language': 'Dil Seciniz',
    'Turkish': 'Turkce',
    'English': 'Ingilizce',
    'creditsTitle': 'Emegi Gecenler',
    'exit': 'Cikis',
    'recipes': 'Tarifler',
    'homeHeroTitle': 'Elindekilerle daha hizli pisir',
    'homeHeroBody':
        'Tarif ara, favorilerini cihazda sakla ve pisirmeye hizlica geri don.',
    'loading': 'Yukleniyor...',
    'storedIngredientsCount': '{} malzeme kayitli',
    'ingredients': 'Malzemeler',
    'timeInfo': 'Sure Bilgisi',
    'contents': 'Icerik',
    'recipeSteps': 'Tarif Adimlari',
    'sendFeedback': 'Geri Bildirim Gonder',
    'prepTime': 'Hazirlama',
    'cookTime': 'Pisirme',
    'totalTime': 'Toplam Sure',
    'unknown': 'Bilinmiyor',
    'calories': 'Kalori',
    'fat': 'Yag',
    'saturatedfat': 'Doymus Yag',
    'colestrol': 'Kolestrol',
    'sodium': 'Sodyum',
    'carbohydrate': 'Karbonhidrat',
    'fiber': 'Lif',
    'sugar': 'Seker',
    'protein': 'Protein',
    'recipeInfo': 'Tarif Bilgisi',
    'shareRecipeMessage': 'Bu tarifi denemelisin! 👉 {}',
    'shareFallback': 'Paylasim acilamadi.',
    'shareAppTitle': 'Uygulamayi paylas',
    'shareAppBody':
        'Arkadaslarin dogru surumu hemen kurabilsin diye App Store ve Google Play baglantilarini gonder.',
    'shareAppAction': 'Uygulamayi paylas',
    'shareAppMessage':
        'Bugun Ne Yesem? uygulamasini dene.\n\nApp Store: {}\nGoogle Play: {}',
    'linkCopied': 'Link kopyalandi: {}',
    'openAppStore': "App Store'u ac",
    'openPlayStore': "Google Play'i ac",
    'save': 'Kaydet',
    'languageSaved': 'Ayarlar kaydedildi.',
    'couldNotOpenLink': 'Baglanti acilamadi. Lutfen tekrar deneyin.',
    'cuisineLabel': 'Mutfak',
    'person': 'Kisilik',
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
