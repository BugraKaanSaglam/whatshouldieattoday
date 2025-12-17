class Favorite {
  int recipeId;
  String category;

  Favorite({
    required this.recipeId,
    required this.category,
  });

  /// Converts the `Favorite` object into a Map
  Map<String, dynamic> toMap() {
    return {
      'recipeId': recipeId,
      'category': category,
    };
  }

  /// Creates a `Favorite` object from a Map
  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      recipeId: map['recipeId'] ?? 0,
      category: map['category'] ?? "",
    );
  }

  @override
  String toString() => 'Favorite(recipeId: $recipeId, category: $category)';
}
