import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:yemek_tarifi_app/app/app.dart';
import 'package:yemek_tarifi_app/core/config/supabase_config.dart';
import 'package:yemek_tarifi_app/core/constants/app_globals.dart';
import 'package:yemek_tarifi_app/core/data/default_ingredients.dart';
import 'package:yemek_tarifi_app/core/database/db_helper.dart';
import 'package:yemek_tarifi_app/core/database/food_application_database.dart';
import 'package:yemek_tarifi_app/core/enums/language_enum.dart';
import 'package:yemek_tarifi_app/core/utils/locale_utils.dart';
import 'package:yemek_tarifi_app/features/favorites/models/favorite.dart';
import 'package:yemek_tarifi_app/features/recipes/models/ingredient.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await MobileAds.instance.initialize();

  final Language deviceLanguage = detectDeviceLanguage();

  globalDataBase = await DBHelper().getList(databaseVersion);

  if (globalDataBase == null) {
    final List<Ingredient> defaultInitialIngredients = buildDefaultInitialIngredients();

    globalDataBase = FoodApplicationDatabase(
      ver: databaseVersion,
      languageCode: deviceLanguage.value,
      initialIngredients: List<Ingredient>.from(defaultInitialIngredients),
      favorites: <Favorite>[],
    );
    await DBHelper().add(globalDataBase!);
    isFirstLaunch = true;
  } else {
    isFirstLaunch = false;
  }

  SupabaseConfig.ensureSet();
  await Supabase.initialize(url: SupabaseConfig.url, anonKey: SupabaseConfig.anonKey);

  final Language startLanguage = globalDataBase != null ? Language.getLanguageFromValue(globalDataBase!.languageCode) : deviceLanguage;
  final Locale startLocale = languageToLocale(startLanguage);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
      path: 'assets/translations',
      fallbackLocale: const Locale('tr', 'TR'),
      startLocale: startLocale,
      child: const FoodApp(),
    ),
  );
}
