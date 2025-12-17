import 'package:flutter/material.dart';
import '../classes/ingredient_class.dart';
import '../database/food_application_database.dart';

//? Database Values
int databaseVersion = 0;
FoodApplicationDataBase? globalDataBase;
const String recipesTableName = 'Recipes';
const String recipeSearchFunctionName = 'get_recipes_by_food_type';

//? Screen Params
double screenHeight = 0;
double screenWidth = 0;
double appBarHeight = 40;
double trueScreenHeight = screenHeight - appBarHeight;

//? Ingredients
List<IngredientClass> totalSelectedIngredients = [];
Color dropdownBackgroundColor = Colors.grey.shade300;

//? App state flags
bool isFirstLaunch = false;
