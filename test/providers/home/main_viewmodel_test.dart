import 'package:flutter_test/flutter_test.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:yemek_tarifi_app/providers/home/main_viewmodel.dart';

void main() {
  test('fetchTotalRecipeCount updates totalRecipeCount from loader', () async {
    final viewModel = MainViewModel(totalRecipeCountLoader: () async => 42);

    await viewModel.fetchTotalRecipeCount();

    expect(viewModel.totalRecipeCount, 42);
  });

  test('isBlinking reflects first launch state', () {
    isFirstLaunch = true;
    final viewModel = MainViewModel(totalRecipeCountLoader: () async => null);
    expect(viewModel.isBlinking, isTrue);

    isFirstLaunch = false;
    expect(viewModel.isBlinking, isFalse);
  });
}
