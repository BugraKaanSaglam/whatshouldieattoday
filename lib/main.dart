import 'package:easy_localization/easy_localization.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:yemek_tarifi_app/app.dart';
import 'package:yemek_tarifi_app/core/configs/supabase_config.dart';
import 'package:yemek_tarifi_app/core/favorites/favorites_store.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:yemek_tarifi_app/global/default_ingredients.dart';
import 'package:yemek_tarifi_app/database/db_helper.dart';
import 'package:yemek_tarifi_app/database/food_application_database.dart';
import 'package:yemek_tarifi_app/enums/language_enum.dart';
import 'package:yemek_tarifi_app/core/utils/locale_utils.dart';
import 'package:yemek_tarifi_app/models/favorites/favorite.dart';
import 'package:yemek_tarifi_app/models/recipe/ingredient.dart';
import 'package:yemek_tarifi_app/core/logging/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  unawaited(
    MobileAds.instance.initialize().then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {
        AppLogger.w('Mobile Ads initialization failed', error);
      },
    ),
  );

  try {
    SupabaseConfig.ensureSet();
  } catch (error, stackTrace) {
    AppLogger.e('Supabase configuration is missing', error, stackTrace);
    runApp(const SupabaseConfigErrorApp());
    return;
  }

  final Language deviceLanguage = detectDeviceLanguage();

  globalDataBase = await DBHelper().getList(databaseVersion);

  if (globalDataBase == null) {
    final List<Ingredient> defaultInitialIngredients =
        buildDefaultInitialIngredients();

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

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );
  await FavoritesStore.reconcileLocalState(backfillMissingCache: true);

  final Language startLanguage = globalDataBase != null
      ? Language.getLanguageFromValue(globalDataBase!.languageCode)
      : deviceLanguage;
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
