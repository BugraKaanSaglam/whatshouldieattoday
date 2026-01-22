import 'package:flutter/material.dart';
import 'package:yemek_tarifi_app/core/enums/categories_enum.dart';

class FoodType {
  const FoodType({required this.image, required this.type});

  final AssetImage image;
  final CategoriesEnum type;
}
