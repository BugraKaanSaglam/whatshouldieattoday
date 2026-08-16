import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:yemek_tarifi_app/core/favorites/favorites_store.dart';
import 'package:yemek_tarifi_app/models/recipe/food.dart';
import 'package:yemek_tarifi_app/widgets/app_surface.dart';
import 'package:yemek_tarifi_app/widgets/favorites/favorite_food_list_item.dart';

class OfflineFavoritesView extends StatelessWidget {
  const OfflineFavoritesView({super.key, this.onFavoritesChanged});

  final VoidCallback? onFavoritesChanged;

  @override
  Widget build(BuildContext context) {
    final List<Food> cachedFoods = FavoritesStore.cachedFoods;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSurface(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'offlineScreenTitle'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'offlineScreenBody'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'offlineFavoritesSectionTitle'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          if (cachedFoods.isEmpty)
            AppSurface(
              padding: const EdgeInsets.all(20),
              child: Text(
                'offlineNoFavoritesBody'.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          else
            ...List.generate(cachedFoods.length, (index) {
              final Food food = cachedFoods[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == cachedFoods.length - 1 ? 0 : 16,
                ),
                child: FavoriteFoodListItem(
                  food: food,
                  onUpdateFavorites: onFavoritesChanged,
                ),
              );
            }),
        ],
      ),
    );
  }
}
