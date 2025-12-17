import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../global/global_images.dart';

class AssetManager {
  static Future<void> addAssetsToList<T extends Enum, TDTO>(List<TDTO> targetList, List<T> enumValues, dynamic Function(AssetImage image, T enumValue) objectBuilder) async {
    if (targetList.isNotEmpty) return;

    for (T enumValue in enumValues) {
      if (enumValue.toString() == "character(0)") return;
      String assetLocation = 'assets/images/${enumValue.name}_${T.toString()}.png';
      AssetImage assetImage = AssetImage(defaultFoodImage); //* Initial Image
      if (await assetExists(assetLocation)) assetImage = AssetImage(assetLocation);
      targetList.add(objectBuilder(assetImage, enumValue)); //* Adding to GlobalList
    }
  }

  static Future<bool> assetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }
}
