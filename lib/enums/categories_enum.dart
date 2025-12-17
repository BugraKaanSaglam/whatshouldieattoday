enum CategoriesEnum {
  appetizer('Appetizer', 'Aperatif', isEnabled: true, isVisible: true),
  beverage('Beverage', 'İçecek', isEnabled: true, isVisible: true),
  bread('Bread', 'Ekmek', isEnabled: true, isVisible: true),
  breakfast('Breakfast', 'Kahvaltı', isEnabled: true, isVisible: true),
  brunch('Brunch', 'Branç', isEnabled: true, isVisible: true),
  cake('Cake', 'Kek', isEnabled: true, isVisible: true),
  candy('Candy', 'Şekerleme', isEnabled: true, isVisible: true),
  cocktail('Cocktail', 'Kokteyl', isEnabled: true, isVisible: true),
  coffee('Coffee', 'Kahve', isEnabled: true, isVisible: true),
  condiment('Condiment', 'Çeşni', isEnabled: true, isVisible: true),
  dessert('Dessert', 'Tatlı', isEnabled: true, isVisible: true),
  dinner('Dinner', 'Akşam yemeği', isEnabled: true, isVisible: true),
  drink('Drink', 'İçecek', isEnabled: true, isVisible: true),
  entree('Entree', 'Ana yemek', isEnabled: true, isVisible: true),
  ingredient('Ingredient', 'Malzeme', isEnabled: true, isVisible: true),
  jamJelly('Jam / Jelly', 'Reçel / Jel', isEnabled: true, isVisible: true),
  lunch('Lunch', 'Öğle yemeği', isEnabled: true, isVisible: true),
  pasta('Pasta', 'Makarna', isEnabled: true, isVisible: true),
  pie('Pie', 'Turta', isEnabled: true, isVisible: true),
  salad('Salad', 'Salata', isEnabled: true, isVisible: true),
  sandwich('Sandwich', 'Sandviç', isEnabled: true, isVisible: true),
  sauce('Sauce', 'Sos', isEnabled: true, isVisible: true),
  sideDish('Side Dish', 'Yan yemek', isEnabled: true, isVisible: true),
  snack('Snack', 'Atıştırmalık', isEnabled: true, isVisible: true),
  soup('Soup', 'Çorba', isEnabled: true, isVisible: true),
  spiceMix('Spice Mix', 'Baharat karışımı', isEnabled: true, isVisible: true),
  none('None', 'Yok', isEnabled: false, isVisible: false); //initValue

  final String label;
  final String trLabel;
  final bool isEnabled;
  final bool isVisible;
  const CategoriesEnum(this.label, this.trLabel, {this.isEnabled = true, this.isVisible = true});

  static CategoriesEnum? fromLabel(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final normalized = value.trim().toLowerCase();
    for (final category in CategoriesEnum.values) {
      if (category.label.toLowerCase() == normalized) return category;
    }
    return null;
  }
}
