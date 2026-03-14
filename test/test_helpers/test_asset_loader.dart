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
    'kitchenHeroBody':
        'Build your default kitchen set. Ingredients saved here make recipe search faster every time.',
    'kitchenSaveActionBody': 'Save the selected ingredients on this device.',
    'kitchenDeleteActionBody': 'Clear the entire saved kitchen list.',
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
    'select_ingredients': 'Select Ingredients',
    'selectionIngredientHelper':
        'Search ingredients, add them to your current selection, and remove anything you do not want before starting.',
    'selectionIngredientEmpty':
        'No ingredients selected yet. Tap below and start building your recipe search.',
    'selectionSelectedCount': '{} selected',
    'selectionHeroTitle': 'Find recipes with less guesswork',
    'selectionHeroBody':
        'Choose ingredients once, review what is selected, then search matching recipes in a single flow.',
    'selectionResultsTitle': 'Search status',
    'selectionResultsIdle':
        'Choose ingredients and tap the main action to see matching recipes.',
    'selectionResultsReady': '{} recipes are ready to browse.',
    'selectionResultsEmpty':
        'No recipes matched this selection yet. Try removing or changing a few ingredients.',
    'selectionPrimaryAction': 'Find recipes',
    'selectionSecondaryAction': 'Clear selection',
    'viewRecipe': 'Open recipe',
    'feedbackScreen': 'Feedback',
    'feedbackHeroBody':
        'Send bugs, friction points, or improvement ideas directly. A short and clear note is enough.',
    'feedbackEmailHint':
        'Add your email so we can reach you if a follow-up is needed.',
    'feedbackMessageHint':
        'Describe what should improve in a few concise sentences.',
    'Email': 'Email',
    'yourFeedback': 'Your Feedback',
    'send': 'Send',
    'timeInfo': 'Time Info',
    'contents': 'Contents',
    'recipeSteps': 'Recipe Steps',
    'sendFeedback': 'Send Feedback',
    'thankyouForYourFeedback': 'Thank You For Your Feedback!',
    'yourFeedbackWillBeReview':
        'Your message will be reviewed for future improvements.',
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
    'recipeOverviewTitle': 'Quick overview',
    'categoryLabel': 'Category',
    'cookingMethodsLabel': 'Cooking methods',
    'implementsLabel': 'Kitchen tools',
    'servingsLabel': 'Servings',
    'ratingLabel': 'Rating',
    'sourceLabel': 'Source',
    'share': 'Share',
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
    'saved': 'Saved',
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
    'creditsHeroTitle': 'Sources and acknowledgments',
    'creditsHeroBody':
        "This page keeps the project's data source, license frame, and contributor attribution visible and explicit.",
    'creditsCreatorRole': 'Product, design, and mobile development',
    'creditsLicenseHint':
        'The dataset source and usage obligations are kept transparent here.',
    'splashTitle': 'Preparing your recipes',
    'splashBody': 'Loading data and your saved preferences.',
    'onboardingProgress': '{} / {}',
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
    'kitchenHeroBody':
        'Kendi mutfak temelini olustur. Buraya ekledigin malzemeler tarif ararken hizli baslangic saglar.',
    'kitchenSaveActionBody': 'Secili malzemeleri bu cihaza kaydet.',
    'kitchenDeleteActionBody': 'Kayitli mutfak listenin tamamini temizle.',
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
    'select_ingredients': 'Malzemeleri Sec',
    'selectionIngredientHelper':
        'Malzeme ara, secimine ekle ve aramayi baslatmadan once istemediklerini cikar.',
    'selectionIngredientEmpty':
        'Henuz malzeme secmedin. Asagidan baslayip tarif aramani olustur.',
    'selectionSelectedCount': '{} secildi',
    'selectionHeroTitle': 'Tahmin etmeden tarif bul',
    'selectionHeroBody':
        'Malzemeleri sec, secimini gozden gecir ve ayni akis icinde eslesen tarifleri gor.',
    'selectionResultsTitle': 'Arama durumu',
    'selectionResultsIdle':
        'Malzemeleri sec ve eslesen tarifleri gormek icin ana aksiyona dokun.',
    'selectionResultsReady': '{} tarif goruntulenmeye hazir.',
    'selectionResultsEmpty':
        'Bu secimle eslesen tarif bulunamadi. Birkac malzeme cikarip tekrar dene.',
    'selectionPrimaryAction': 'Tarifleri bul',
    'selectionSecondaryAction': 'Secimi temizle',
    'viewRecipe': 'Tarifi ac',
    'feedbackScreen': 'Geri bildirim',
    'feedbackHeroBody':
        'Eksik gordugun alanlari, hatalari veya iyilestirme onerilerini dogrudan gonder. Kisa ve net yazman yeterli.',
    'feedbackEmailHint':
        'Gerekirse sana donus yapabilmemiz icin e-posta adresini ekle.',
    'feedbackMessageHint':
        'Neyi gelistirmenin daha iyi olacagini birkac cumleyle anlat.',
    'Email': 'Eposta',
    'yourFeedback': 'Geri Bildirimin',
    'send': 'Gonder',
    'timeInfo': 'Sure Bilgisi',
    'contents': 'Icerik',
    'recipeSteps': 'Tarif Adimlari',
    'sendFeedback': 'Geri Bildirim Gonder',
    'thankyouForYourFeedback': 'Bildirim icin tesekkurler!',
    'yourFeedbackWillBeReview':
        'Mesajin incelenecek ve sonraki iyilestirmelerde degerlendirilecek.',
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
    'recipeOverviewTitle': 'Hizli ozet',
    'categoryLabel': 'Kategori',
    'cookingMethodsLabel': 'Pisirme yontemleri',
    'implementsLabel': 'Mutfak araclari',
    'servingsLabel': 'Porsiyon',
    'ratingLabel': 'Puan',
    'sourceLabel': 'Kaynak',
    'share': 'Paylas',
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
    'saved': 'Kaydedildi',
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
    'creditsHeroTitle': 'Kaynaklar ve emegi gecenler',
    'creditsHeroBody':
        'Bu ekran, uygulamanin veri kaynagini, lisans cercevesini ve projeye katki saglayan taraflari acik sekilde listeler.',
    'creditsCreatorRole': 'Urun, tasarim ve mobil gelistirme',
    'creditsLicenseHint':
        'Veri kaynagi ve kullanim sartlari seffaf bicimde burada tutulur.',
    'splashTitle': 'Tarifler hazirlaniyor',
    'splashBody': 'Veriler ve kisisel tercihlerin yukleniyor.',
    'onboardingProgress': '{} / {}',
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
