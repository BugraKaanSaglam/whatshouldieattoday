// ignore_for_file: non_constant_identifier_names

class IngredientClass {
  final String Ingredient;
  final String Ingredient_tr;

  IngredientClass({required this.Ingredient, this.Ingredient_tr = ""});

  Map<String, dynamic> toMap() {
    return {'Ingredient': Ingredient, 'Ingredient_tr': Ingredient_tr};
  }

  factory IngredientClass.fromMap(Map<String, dynamic> map) {
    return IngredientClass(Ingredient: map['Ingredient'] ?? '', Ingredient_tr: map['Ingredient_tr'] ?? '');
  }
  @override
  bool operator ==(Object other) => identical(this, other) || other is IngredientClass && runtimeType == other.runtimeType && Ingredient_tr == other.Ingredient_tr;

  @override
  int get hashCode => Ingredient_tr.hashCode;
  @override
  String toString() => Ingredient;
}
