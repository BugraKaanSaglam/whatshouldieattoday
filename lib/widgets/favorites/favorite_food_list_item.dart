import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:yemek_tarifi_app/core/configs/router/app_routes.dart';
import 'package:yemek_tarifi_app/core/network/backend_service.dart';
import 'package:yemek_tarifi_app/core/utils/checkstring.dart';
import 'package:yemek_tarifi_app/global/app_theme.dart';
import 'package:yemek_tarifi_app/models/recipe/food.dart';
import 'package:yemek_tarifi_app/widgets/recipes/food_image.dart';

class FavoriteFoodListItem extends StatelessWidget {
  const FavoriteFoodListItem({
    super.key,
    required this.food,
    this.onUpdateFavorites,
  });

  final Food food;
  final VoidCallback? onUpdateFavorites;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isTurkish = context.locale.languageCode == 'tr';
    final String title = isTurkish ? food.nameTr : food.name;
    final String heroTag = 'food-${food.recipeId}';
    final int? rawDuration =
        food.totalTimeMinutes ?? food.cookTimeMinutes ?? food.prepTimeMinutes;
    final String timeText = formatDuration(rawDuration);
    final String? servingsValue = _normalizedServings(food.servings);
    final String servingsText = servingsValue != null
        ? '$servingsValue ${'person'.tr()}'
        : '? ${'person'.tr()}';
    final String coverUrl = BackendService.recipeImagePublicUrl(food.recipeId);

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () async {
        await context.push(AppRoutes.recipeById(food.recipeId), extra: food);
        onUpdateFavorites?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: SizedBox(
          height: 140,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(22),
                ),
                child: Hero(
                  tag: heroTag,
                  child: SizedBox(
                    width: 120,
                    height: 140,
                    child: FoodImage(
                      imageUrls: [coverUrl],
                      cacheKey: 'recipe-${food.recipeId}',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 20, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 18,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.group_outlined,
                            size: 18,
                            color: AppTheme.seedColor,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              servingsText,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (timeText.isNotEmpty) ...[
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.schedule_rounded,
                              size: 18,
                              color: AppTheme.seedColor,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                timeText,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.black54,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 22,
                            color: AppTheme.seedColor,
                          ),
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

  String? _normalizedServings(String? rawServings) {
    if (rawServings == null) return null;
    final String trimmed = rawServings.trim();
    if (trimmed.isEmpty) return null;
    final RegExpMatch? match = RegExp(r'\d+').firstMatch(trimmed);
    if (match != null) return match.group(0);
    return trimmed;
  }
}
