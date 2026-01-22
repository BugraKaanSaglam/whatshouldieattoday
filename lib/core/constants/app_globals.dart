import 'package:flutter/material.dart';
import 'package:yemek_tarifi_app/features/recipes/models/ingredient.dart';
import 'package:yemek_tarifi_app/core/database/food_application_database.dart';

//? Database Values
int databaseVersion = 0;
FoodApplicationDatabase? globalDataBase;
const String recipesTableName = 'Recipes';
const String recipeSearchFunctionName = 'get_recipes_by_food_type';

//? Screen Params
double screenHeight = 0;
double screenWidth = 0;
double appBarHeight = 40;
double trueScreenHeight = screenHeight - appBarHeight;

//? Ingredients
List<Ingredient> totalSelectedIngredients = [];
Color dropdownBackgroundColor = Colors.grey.shade300;

//? App state flags
bool isFirstLaunch = false;
