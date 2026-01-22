import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:yemek_tarifi_app/app.dart';
import 'package:yemek_tarifi_app/core/configs/supabase_config.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:yemek_tarifi_app/global/default_ingredients.dart';
import 'package:yemek_tarifi_app/database/db_helper.dart';
import 'package:yemek_tarifi_app/database/food_application_database.dart';
import 'package:yemek_tarifi_app/enums/language_enum.dart';
import 'package:yemek_tarifi_app/core/utils/locale_utils.dart';
import 'package:yemek_tarifi_app/models/favorites/favorite.dart';
import 'package:yemek_tarifi_app/models/recipe/ingredient.dart';

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
