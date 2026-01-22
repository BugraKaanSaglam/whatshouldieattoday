import 'dart:developer';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:yemek_tarifi_app/app/router/app_routes.dart';
import 'package:yemek_tarifi_app/features/favorites/models/favorite.dart';
import 'package:yemek_tarifi_app/features/recipes/models/ingredient.dart';
import 'package:yemek_tarifi_app/core/widgets/app_scaffold.dart';
import 'package:yemek_tarifi_app/core/widgets/main_app_bar.dart';
import 'package:yemek_tarifi_app/features/recipes/models/food.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:yemek_tarifi_app/features/recipes/widgets/food_image.dart';
import 'package:yemek_tarifi_app/core/database/db_helper.dart';
import 'package:yemek_tarifi_app/core/utils/checkstring.dart';
import 'package:yemek_tarifi_app/core/utils/form_decorations.dart';
import 'package:yemek_tarifi_app/core/constants/app_globals.dart';
import 'package:yemek_tarifi_app/core/theme/app_theme.dart';
import 'package:yemek_tarifi_app/core/services/backend_service.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectedFoodScreen extends StatefulWidget {
  final Food food;
  final int recipeId;
  final String category;
  const SelectedFoodScreen(this.food, {super.key, required this.recipeId, required this.category});
  @override
  State<SelectedFoodScreen> createState() => _SelectedFoodScreenState();
}

class _SelectedFoodScreenState extends State<SelectedFoodScreen> {
  late String foodName;
  late String stepsText;
  late Food food;
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  double get _fabBottomPadding {
    final safe = MediaQuery.of(context).padding.bottom;
    final adH = _isAdLoaded ? _bannerAd.size.height.toDouble() : 0;
    return 20 + adH + safe;
  }

  @override
  void initState() {
    super.initState();

    // 1) Context KULLANMADAN başlangıç atamaları
    _initBannerAd();
    food = widget.food;
    // Yerel dil daha sonra didChangeDependencies'te uygulanacak.
    foodName = food.name.isNotEmpty ? food.name : food.nameTr;
    stepsText = _formatInstructions(food.instructions);

    // 2) Deep link ile tek kayıt çekilecekse getir ve sonra detayları güncelle
    if (widget.recipeId != 0) {
      _fetchSingleFood(widget.recipeId).then((fetchedFood) {
        if (!mounted) return;
        if (fetchedFood != null) {
          setState(() {
            food = fetchedFood;
          });
          _updateFoodDetails();
        }
      }).catchError((e) {
        log('Error fetching food: $e');
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // context.locale gibi inherited erişimler BURADA güvenli
    _updateFoodDetails();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  void _initBannerAd() {
    String adUnitId;
    if (Platform.isAndroid) {
      adUnitId = 'ca-app-pub-8279650993144801/1857640059';
    } else if (Platform.isIOS) {
      adUnitId = 'ca-app-pub-8279650993144801/8683661028';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() => _isAdLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          // Hata fırlatmak yerine sessizce devam edelim
          log('Banner Ad Load Failed: $error');
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  Future<Food?> _fetchSingleFood(int recipeId) async {
    final SupabaseClient supabase = Supabase.instance.client;
    try {
      final List<Map<String, dynamic>> data = await supabase.from(recipesTableName).select().eq('RecipeId', recipeId).limit(1);
      if (data.isEmpty) return null;
      return Food.fromMap(data.first);
    } catch (_) {
      try {
        final List<Map<String, dynamic>> data = await supabase.from(recipesTableName).select().eq('Id', recipeId).limit(1);
        if (data.isEmpty) return null;
        return Food.fromMap(data.first);
      } catch (e) {
        log('Error processing doc');
        throw Exception('Error parsing food data: $e');
      }
    }
  }

  void _updateFoodDetails() {
    // Burada artık context güvenli
    final bool isTurkish = context.locale.languageCode == 'tr';
    foodName = isTurkish ? (food.nameTr.isNotEmpty ? food.nameTr : food.name) : (food.name.isNotEmpty ? food.name : food.nameTr);
    stepsText = _formatInstructions(_instructionsForLocale(isTurkish));
    if (mounted) setState(() {});
  }

  List<String> _instructionsForLocale(bool isTurkish) {
    if (isTurkish && food.instructionsTr.isNotEmpty) return food.instructionsTr;
    if (!isTurkish && food.instructions.isNotEmpty) return food.instructions;
    return isTurkish ? food.instructionsTr : food.instructions;
  }

  String _formatInstructions(List<String> instructions) {
    if (instructions.isEmpty) return '';
    return List.generate(instructions.length, (index) => '${index + 1}. ${instructions[index]}').join('\n\n');
  }

  String get _primaryCategoryLabel {
    if (food.categories.isNotEmpty) return food.categories.first;
    if (widget.category.isNotEmpty) return widget.category;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: MainAppBar(title: foodName),
      body: selectedFoodBody(),
      bottomBar: _isAdLoaded ? SizedBox(height: _bannerAd.size.height.toDouble(), child: AdWidget(ad: _bannerAd)) : null,
    );
  }

  Widget selectedFoodBody() {
    final double scrollBottomPad = 100 + (_isAdLoaded ? _bannerAd.size.height.toDouble() : 0);
    final bool hasIngredients = food.ingredients.isNotEmpty || food.ingredientsRaw.isNotEmpty || food.ingredientsRawTr.isNotEmpty;
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(bottom: scrollBottomPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMetaHighlights(),
                    const SizedBox(height: 20),
                    _buildRecipeFactsCard(),
                    if (hasIngredients) ...[
                      const SizedBox(height: 20),
                      _buildSectionCard(
                        title: 'ingredients'.tr(),
                        icon: Icons.shopping_basket_outlined,
                        child: _buildIngredientsContent(),
                      ),
                    ],
                    const SizedBox(height: 20),
                    _buildSectionCard(
                      title: 'timeInfo'.tr(),
                      icon: Icons.timer_outlined,
                      child: _buildTimeInfoContent(),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionCard(
                      title: 'contents'.tr(),
                      icon: Icons.local_fire_department_outlined,
                      child: _buildNutritionalContent(),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionCard(
                      title: 'recipeSteps'.tr(),
                      icon: Icons.menu_book_outlined,
                      child: Text(customChangeString(stepsText), style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    const SizedBox(height: 20),
                    _buildFeedbackButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: _fabBottomPadding,
          left: 16,
          child: _buildShareFab(),
        ),
        Positioned(
          bottom: _fabBottomPadding,
          right: 16,
          child: _buildFavoriteFab(),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    final String coverUrl = BackendService.recipeImagePublicUrl(food.recipeId);
    return Hero(
      tag: 'food-${food.recipeId}',
      child: ClipRRect(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
        child: SizedBox(height: 300, width: double.infinity, child: FoodImage(imageUrls: [coverUrl], cacheKey: 'recipe-${food.recipeId}')),
      ),
    );
  }

  Widget _buildMetaHighlights() {
    final List<Widget> highlights = [];
    final String? servingsValue = _normalizedServings(food.servings);
    final servingsText = servingsValue != null ? '$servingsValue ${'person'.tr()}' : null;
    if (servingsText != null) {
      highlights.add(Chip(
        avatar: const Icon(Icons.group_outlined, size: 18, color: Color(0xFF1F2937)),
        label: Text(servingsText, style: const TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
      ));
    }
    final int? totalTime = food.totalTimeMinutes ?? food.cookTimeMinutes ?? food.prepTimeMinutes;
    final String timeInfo = formatDuration(totalTime);
    if (timeInfo.isNotEmpty) {
      highlights.add(Chip(
        avatar: const Icon(Icons.timer_outlined, size: 18, color: Color(0xFF1F2937)),
        label: Text(timeInfo, style: const TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
      ));
    }
    if (highlights.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 8, runSpacing: 8, children: highlights);
  }

  Widget _buildRecipeFactsCard() {
    final bool isTr = context.locale.languageCode == 'tr';
    final String recipeInfoTitle = 'recipeInfo'.tr();
    final String recipeInfoLabel = recipeInfoTitle == 'recipeInfo' ? (isTr ? 'Tarif Bilgileri' : 'Recipe Info') : recipeInfoTitle;
    final List<Widget> rows = [];

    if (food.categories.isNotEmpty) {
      rows.add(_factRow('Category', _stringPills(food.categories)));
    }

    if (food.cuisines.isNotEmpty) {
      rows.add(_factRow('cuisineLabel'.tr(), _stringPills(food.cuisines)));
    }

    if (food.cookingMethods.isNotEmpty) {
      rows.add(_factRow('Cooking Methods', _stringPills(food.cookingMethods)));
    }

    if (food.implementsList.isNotEmpty) {
      rows.add(_factRow('Implements', _stringPills(food.implementsList)));
    }

    final String? servingsValue = _normalizedServings(food.servings);
    if (servingsValue != null) {
      rows.add(_factRow('Servings', _pill('$servingsValue ${'person'.tr()}')));
    }

    if (food.numberOfSteps != null) {
      rows.add(_factRow('recipeSteps'.tr(), _pill('${food.numberOfSteps}')));
    }

    final Widget? ratingWidget = _ratingBadge(food.ratingValue, food.ratingCount);
    if (ratingWidget != null) {
      rows.add(_factRow('Rating', ratingWidget));
    }

    if (food.url != null && food.url!.trim().isNotEmpty) {
      final String urlText = food.url!.trim();
      rows.add(
        _factRow(
          'URL',
          GestureDetector(
            onTap: () => _launchRecipeUrl(urlText),
            onLongPress: () => _copyUrlToClipboard(urlText),
            child: Text(
              urlText,
              style: const TextStyle(color: AppTheme.secondaryColor, decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    }

    return _buildSectionCard(
      title: recipeInfoLabel,
      icon: Icons.info_outline_rounded,
      child: Column(
        children: rows
            .map(
              (row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: row,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _factRow(String label, Widget value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1F2937))),
        ),
        const SizedBox(width: 12),
        Expanded(child: value),
      ],
    );
  }

  Widget _stringPills(List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((e) => _pill(e)).toList(),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.seedColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.seedColor.withValues(alpha: 0.2)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
    );
  }

  Widget? _ratingBadge(double? ratingValue, int? ratingCount) {
    if (ratingValue == null && ratingCount == null) return null;
    final bool isTr = context.locale.languageCode == 'tr';
    final double rating = (ratingValue ?? 0).clamp(0, 5).toDouble();
    final int fullStars = rating.floor();
    final double fractional = rating - fullStars;
    final bool hasHalfStar = fractional >= 0.25 && fractional < 0.75;
    final String countText = ratingCount != null ? (isTr ? '($ratingCount oy)' : '($ratingCount ratings)') : (isTr ? '(oy yok)' : '(no ratings)');

    return LayoutBuilder(
      builder: (context, constraints) {
        final double starSize = constraints.maxWidth < 260 ? 30 : 36;
        final double spacing = constraints.maxWidth < 260 ? 6 : 12;
        return Wrap(
          spacing: spacing,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                IconData icon;
                if (index < fullStars) {
                  icon = Icons.star_rounded;
                } else if (index == fullStars && hasHalfStar) {
                  icon = Icons.star_half_rounded;
                } else {
                  icon = Icons.star_border_rounded;
                }
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 260 + index * 90),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) => Transform.scale(scale: value, child: child),
                  child: Icon(icon, size: starSize, color: Colors.amber.shade600),
                );
              }),
            ),
            Text(
              countText,
              style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w700),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionCard({required String title, required Widget child, IconData? icon}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 18, offset: const Offset(0, 12))],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppTheme.seedColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                  child: Icon(icon, color: AppTheme.seedColor),
                ),
              if (icon != null) const SizedBox(width: 12),
              Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildIngredientsContent() {
    final bool isTr = context.locale.languageCode == 'tr';
    final List<String> rawIngredients = isTr ? food.ingredientsRawTr : food.ingredientsRaw;
    if (rawIngredients.isNotEmpty) {
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: rawIngredients
            .map(
              (item) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(color: AppTheme.secondaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(18)),
                child: Text(item, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
              ),
            )
            .toList(),
      );
    }
    final List<Ingredient> ingredients = food.ingredients;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(ingredients.length, (index) {
        final Ingredient ingredient = ingredients[index];
        final String value = (isTr && ingredient.nameTr.isNotEmpty) ? ingredient.nameTr : ingredient.name;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: AppTheme.secondaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(18)),
          child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
        );
      }),
    );
  }

  Widget _buildTimeInfoContent() {
    final List<_InfoItem> infoItems = [
      _InfoItem(icon: Icons.timer, label: 'prepTime'.tr(), value: formatDuration(food.prepTimeMinutes)),
      _InfoItem(icon: Icons.local_fire_department, label: 'cookTime'.tr(), value: formatDuration(food.cookTimeMinutes)),
      _InfoItem(icon: Icons.timelapse, label: 'totalTime'.tr(), value: formatDuration(food.totalTimeMinutes)),
    ].where((item) => item.value.isNotEmpty).toList();
    if (infoItems.isEmpty) {
      return Text('unknown'.tr(), style: Theme.of(context).textTheme.bodyMedium);
    }
    return Column(
      children: infoItems
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppTheme.seedColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                    child: Icon(item.icon, color: AppTheme.seedColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Text(item.label, style: const TextStyle(fontWeight: FontWeight.w600))),
                  Text(item.value, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildNutritionalContent() {
    final nutritionItems = [
      ('calories'.tr(), _formatNutrient(food.calories, 'kcal')),
      ('fat'.tr(), _formatNutrient(food.fat, 'g')),
      ('saturatedfat'.tr(), _formatNutrient(food.saturatedFat, 'g')),
      ('colestrol'.tr(), _formatNutrient(food.cholesterol, 'mg')),
      ('sodium'.tr(), _formatNutrient(food.sodium, 'mg')),
      ('carbohydrate'.tr(), _formatNutrient(food.carbohydrates, 'g')),
      ('fiber'.tr(), _formatNutrient(food.fiber, 'g')),
      ('sugar'.tr(), _formatNutrient(food.sugar, 'g')),
      ('protein'.tr(), _formatNutrient(food.protein, 'g')),
    ];
    return Column(
      children: nutritionItems
          .map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  Expanded(child: Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w600))),
                  Text(item.$2, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  String _formatNutrient(double? value, String unit) {
    if (value == null || value == 0) return '-';
    final bool hasDecimals = value % 1 != 0;
    final formatted = hasDecimals ? value.toStringAsFixed(1) : value.toStringAsFixed(0);
    return '$formatted $unit';
  }

  String? _normalizedServings(String? rawServings) {
    if (rawServings == null) return null;
    final String trimmed = rawServings.trim();
    if (trimmed.isEmpty) return null;

    String firstEntry = trimmed;
    if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
      final inner = trimmed.substring(1, trimmed.length - 1);
      final List<String> parts = inner.split(',').map((e) => e.trim().replaceAll(RegExp(r'''^['"]|['"]$'''), '')).where((e) => e.isNotEmpty).toList();
      if (parts.isNotEmpty) firstEntry = parts.first;
    }

    final RegExpMatch? match = RegExp(r'\d+').firstMatch(firstEntry);
    if (match != null) return match.group(0);

    final String fallback = firstEntry.replaceAll(RegExp(r'''^['"]|['"]$'''), '').trim();
    return fallback.isNotEmpty ? fallback : null;
  }

  Uri? _normalizeUrl(String? raw) {
    if (raw == null) return null;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    final Uri? direct = Uri.tryParse(trimmed);
    if (direct != null && direct.hasScheme) return direct;
    return Uri.tryParse('https://$trimmed');
  }

  Future<void> _launchRecipeUrl(String urlText) async {
    final Uri? uri = _normalizeUrl(urlText);
    if (uri == null) {
      await _copyUrlToClipboard(urlText);
      return;
    }
    try {
      final bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await _copyUrlToClipboard(urlText);
      }
    } catch (_) {
      await _copyUrlToClipboard(urlText);
    }
  }

  Future<void> _copyUrlToClipboard(String urlText) async {
    await Clipboard.setData(ClipboardData(text: urlText));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('linkCopied'.tr(args: [urlText]))),
    );
  }

  Widget _buildFeedbackButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => context.push(
            '${AppRoutes.feedback}?recipeId=${food.recipeId}&category=$_primaryCategoryLabel',
          ),
          icon: const Icon(Icons.feedback_outlined),
          label: Text('sendFeedback'.tr(), style: buttonTextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  bool get _isFavorite => globalDataBase!.favorites.any((fav) => fav.recipeId == food.recipeId);

  void _shareRecipe() async {
    final Uri recipeUrl = Uri(
      scheme: 'https',
      host: 'what-should-i-eat-today-7be98.web.app',
      path: '/recipe/${food.recipeId}',
    );
    final String text = 'shareRecipeMessage'.tr(args: [recipeUrl.toString()]);
    try {
      await SharePlus.instance.share(ShareParams(text: text, subject: foodName));
    } catch (e, s) {
      log('Share failed: $e\n$s');
      await Clipboard.setData(ClipboardData(text: recipeUrl.toString()));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('shareFallback'.tr())),
      );
    }
  }

  Future<void> _favorite() async {
    Favorite favoriteActionItem = Favorite(recipeId: food.recipeId, category: _primaryCategoryLabel);
    setState(() {
      if (_isFavorite) {
        globalDataBase!.favorites.removeWhere((fav) => fav.recipeId == food.recipeId);
      } else {
        globalDataBase!.favorites.add(favoriteActionItem);
      }
    });
    await DBHelper().update(globalDataBase!);
  }

  Widget _buildShareFab() {
    return FloatingActionButton.small(
      heroTag: 'shareFab',
      backgroundColor: Colors.white,
      foregroundColor: AppTheme.seedColor,
      onPressed: _shareRecipe,
      child: const Icon(Icons.share_rounded),
    );
  }

  Widget _buildFavoriteFab() {
    return FloatingActionButton.small(
      heroTag: 'favFab',
      backgroundColor: _isFavorite ? Colors.amber : Colors.white,
      foregroundColor: _isFavorite ? Colors.white : Colors.grey,
      onPressed: _favorite,
      child: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border_rounded),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  const _InfoItem({required this.icon, required this.label, required this.value});
}
