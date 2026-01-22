// ignore_for_file: use_build_context_synchronously, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:yemek_tarifi_app/core/configs/router/app_routes.dart';
import 'package:yemek_tarifi_app/core/utils/checkstring.dart';
import 'package:yemek_tarifi_app/widgets/app_scaffold.dart';
import 'package:yemek_tarifi_app/widgets/main_app_bar.dart';
import 'package:yemek_tarifi_app/models/recipe/food.dart';
import 'package:yemek_tarifi_app/widgets/recipes/food_image.dart';
import 'package:yemek_tarifi_app/global/app_theme.dart';
import 'package:yemek_tarifi_app/providers/favorites/favorites_viewmodel.dart';
import 'package:yemek_tarifi_app/core/network/backend_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = FavoritesViewModel();
    _viewModel.loadFavorites();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<FavoritesViewModel>(
        builder: (context, viewModel, _) => AppScaffold(
          appBar: MainAppBar(title: 'favorites'.tr()),
          body: favoritesBody(context, viewModel),
        ),
      ),
    );
  }

  Widget favoritesBody(BuildContext context, FavoritesViewModel viewModel) {
    final favorites = viewModel.favorites;
    final loadedFoods = viewModel.loadedFoods;
    final isLoading = viewModel.isLoading;

    if (favorites.isEmpty) {
      return Center(child: Text('noFavoritesYet'.tr(), style: Theme.of(context).textTheme.bodyLarge));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      itemCount: favorites.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final food = loadedFoods[index];
        if (isLoading || food == null) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 10))],
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        return FavoriteFoodListItem(food: food, onUpdateFavorites: viewModel.loadFavorites);
      },
    );
  }
}

class FavoriteFoodListItem extends StatelessWidget {
  final Food food;
  final VoidCallback onUpdateFavorites;

  const FavoriteFoodListItem({super.key, required this.food, required this.onUpdateFavorites});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isTurkish = context.locale.languageCode == 'tr';
    final String title = isTurkish ? food.nameTr : food.name;
    final String heroTag = 'food-${food.recipeId}';
    final int? rawDuration = food.totalTimeMinutes ?? food.cookTimeMinutes ?? food.prepTimeMinutes;
    final String timeText = formatDuration(rawDuration);
    final String servingsText = food.servings != null ? '${food.servings} ${'person'.tr()}' : '? ${'person'.tr()}';
    final String coverUrl = BackendService.recipeImagePublicUrl(food.recipeId);

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () async {
        await context.push(AppRoutes.recipeById(food.recipeId), extra: food);
        onUpdateFavorites();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 12))],
        ),
        child: SizedBox(
          height: 140,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(22)),
                child: Hero(
                  tag: heroTag,
                  child: SizedBox(width: 120, height: 140, child: FoodImage(imageUrls: [coverUrl], cacheKey: 'recipe-${food.recipeId}')),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 20, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title, style: theme.textTheme.titleLarge?.copyWith(fontSize: 18), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.group_outlined, size: 18, color: AppTheme.seedColor),
                          const SizedBox(width: 6),
                          Flexible(child: Text(servingsText, style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54), overflow: TextOverflow.ellipsis)),
                          if (timeText.isNotEmpty) ...[
                            const SizedBox(width: 12),
                            const Icon(Icons.schedule_rounded, size: 18, color: AppTheme.seedColor),
                            const SizedBox(width: 6),
                            Flexible(child: Text(timeText, style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54), overflow: TextOverflow.ellipsis)),
                          ],
                          const Spacer(),
                          const Icon(Icons.arrow_forward_rounded, size: 22, color: AppTheme.seedColor),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
