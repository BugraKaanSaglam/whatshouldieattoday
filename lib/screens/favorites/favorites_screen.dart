import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:yemek_tarifi_app/core/configs/router/app_routes.dart';
import 'package:yemek_tarifi_app/global/app_theme.dart';
import 'package:yemek_tarifi_app/providers/favorites/favorites_viewmodel.dart';
import 'package:yemek_tarifi_app/widgets/app_scaffold.dart';
import 'package:yemek_tarifi_app/widgets/favorites/favorite_food_list_item.dart';
import 'package:yemek_tarifi_app/widgets/main_app_bar.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key, this.viewModel});

  final FavoritesViewModel? viewModel;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? FavoritesViewModel();
    _viewModel.loadFavorites();
  }

  @override
  void dispose() {
    if (widget.viewModel == null) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<FavoritesViewModel>(
        builder: (context, viewModel, _) => AppScaffold(
          appBar: MainAppBar(title: 'favorites'.tr()),
          body: _favoritesBody(context, viewModel),
        ),
      ),
    );
  }

  Widget _favoritesBody(BuildContext context, FavoritesViewModel viewModel) {
    final favorites = viewModel.favorites;
    final loadedFoods = viewModel.loadedFoods;
    final isLoading = viewModel.isLoading;

    if (favorites.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.seedColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    size: 34,
                    color: AppTheme.seedColor,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'noFavoritesYet'.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'favoritesOfflineHintBody'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: () => context.push(AppRoutes.recipes),
                  icon: const Icon(Icons.restaurant_menu_rounded),
                  label: Text('startCooking'.tr()),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: _OfflineInfoCard(
            title: 'favoritesOfflineHintTitle'.tr(),
            message: viewModel.showingCachedOnly
                ? 'offlineFavoritesBody'.tr()
                : 'favoritesOfflineHintBody'.tr(),
          ),
        ),
        if (viewModel.showingCachedOnly)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: _OfflineInfoCard(
              title: 'offlineFavoritesTitle'.tr(),
              message: 'offlineFavoritesBody'.tr(),
            ),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            itemCount: favorites.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final food = loadedFoods[index];
              if (isLoading && food == null) {
                return const _FavoriteLoadingCard();
              }
              if (food == null) {
                return const SizedBox.shrink();
              }
              return FavoriteFoodListItem(
                food: food,
                onUpdateFavorites: viewModel.loadFavorites,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OfflineInfoCard extends StatelessWidget {
  const _OfflineInfoCard({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _FavoriteLoadingCard extends StatelessWidget {
  const _FavoriteLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
