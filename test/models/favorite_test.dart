import 'package:flutter_test/flutter_test.dart';
import 'package:yemek_tarifi_app/models/favorites/favorite.dart';
import 'package:yemek_tarifi_app/models/recipe/food.dart';

void main() {
  test('Favorite serializes cachedFood for offline usage', () {
    final favorite = Favorite(
      recipeId: 3,
      category: 'Breakfast',
      cachedFood: const Food(recipeId: 3, name: 'Toast', nameTr: 'Tost'),
    );

    final json = favorite.toJson();
    final restored = Favorite.fromJson(json);

    expect((json['cachedFood'] as Map<String, dynamic>)['name'], 'Toast');
    expect(restored.cachedFood?.recipeId, 3);
    expect(restored.cachedFood?.nameTr, 'Tost');
  });
}
