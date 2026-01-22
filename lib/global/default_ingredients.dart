import 'package:yemek_tarifi_app/models/recipe/ingredient.dart';

//* Default pantry ingredients to pre-select for new users.
List<Ingredient> buildDefaultInitialIngredients() {
  const List<Map<String, String>> defaults = [
    {'Ingredient': 'salt', 'Ingredient_tr': 'tuz'},
    {'Ingredient': 'black pepper', 'Ingredient_tr': 'karabiber'},
    {'Ingredient': 'olive oil', 'Ingredient_tr': 'zeytinyağı'},
    {'Ingredient': 'vegetable oil', 'Ingredient_tr': 'bitkisel yağ'},
    {'Ingredient': 'butter', 'Ingredient_tr': 'tereyağı'},
    {'Ingredient': 'flour', 'Ingredient_tr': 'un'},
    {'Ingredient': 'sugar', 'Ingredient_tr': 'şeker'},
    {'Ingredient': 'water', 'Ingredient_tr': 'su'},
    {'Ingredient': 'potato', 'Ingredient_tr': 'patates'},
    {'Ingredient': 'baking powder', 'Ingredient_tr': 'kabartma tozu'},
    {'Ingredient': 'vinegar', 'Ingredient_tr': 'sirke'},
    {'Ingredient': 'pasta', 'Ingredient_tr': 'makarna'},
    {'Ingredient': 'bread', 'Ingredient_tr': 'ekmek'},
    {'Ingredient': 'cucumber', 'Ingredient_tr': 'salatalık'},
    {'Ingredient': 'mayonnaise', 'Ingredient_tr': 'mayonez'},
    {'Ingredient': 'ketchup', 'Ingredient_tr': 'ketçap'},
    {'Ingredient': 'mustard', 'Ingredient_tr': 'hardal'},
    {'Ingredient': 'oregano', 'Ingredient_tr': 'kekik'},
    {'Ingredient': 'thyme', 'Ingredient_tr': 'kekik'},
    {'Ingredient': 'honey', 'Ingredient_tr': 'Bal'},
    {'Ingredient': 'tomato paste', 'Ingredient_tr': 'salça'},
    {'Ingredient': 'tomato sauce', 'Ingredient_tr': 'domates sosu'},
    {'Ingredient': 'olive', 'Ingredient_tr': 'zeytin'},
    {'Ingredient': 'black olives', 'Ingredient_tr': 'ons) siyah zeytin konservesi'},
  ];

  return defaults.map((item) => Ingredient(name: item['Ingredient']!, nameTr: item['Ingredient_tr']!)).toList(growable: true);
}
