// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Food {

@JsonKey(name: 'id') int get recipeId; String get name;@JsonKey(name: 'name_tr') String get nameTr; double? get ratingValue; int? get ratingCount; int? get prepTimeMinutes; int? get cookTimeMinutes; List<String> get categories; List<String> get cuisines; List<Ingredient> get ingredients;@JsonKey(name: 'ingredients_tr') List<Ingredient> get ingredientsTr; List<String> get ingredientsRaw;@JsonKey(name: 'ingredients_raw_tr') List<String> get ingredientsRawTr; List<String> get instructions;@JsonKey(name: 'instructions_tr') List<String> get instructionsTr; List<String> get cookingMethods;@JsonKey(name: 'implements') List<String> get implementsList; int? get numberOfSteps; String? get servings;@JsonKey(name: 'servings_tr') String? get servingsTr; double? get calories; double? get carbohydrates; double? get cholesterol; double? get fiber; double? get protein; double? get saturatedFat; double? get sodium; double? get sugar; double? get fat; double? get unsaturatedFat;@JsonKey(name: 'nutrition_raw') Map<String, String> get nutritionRaw; String? get url;@JsonKey(includeFromJson: false, includeToJson: false) CategoriesEnum get recipeCategory;
/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodCopyWith<Food> get copyWith => _$FoodCopyWithImpl<Food>(this as Food, _$identity);

  /// Serializes this Food to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Food&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameTr, nameTr) || other.nameTr == nameTr)&&(identical(other.ratingValue, ratingValue) || other.ratingValue == ratingValue)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.prepTimeMinutes, prepTimeMinutes) || other.prepTimeMinutes == prepTimeMinutes)&&(identical(other.cookTimeMinutes, cookTimeMinutes) || other.cookTimeMinutes == cookTimeMinutes)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.cuisines, cuisines)&&const DeepCollectionEquality().equals(other.ingredients, ingredients)&&const DeepCollectionEquality().equals(other.ingredientsTr, ingredientsTr)&&const DeepCollectionEquality().equals(other.ingredientsRaw, ingredientsRaw)&&const DeepCollectionEquality().equals(other.ingredientsRawTr, ingredientsRawTr)&&const DeepCollectionEquality().equals(other.instructions, instructions)&&const DeepCollectionEquality().equals(other.instructionsTr, instructionsTr)&&const DeepCollectionEquality().equals(other.cookingMethods, cookingMethods)&&const DeepCollectionEquality().equals(other.implementsList, implementsList)&&(identical(other.numberOfSteps, numberOfSteps) || other.numberOfSteps == numberOfSteps)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.servingsTr, servingsTr) || other.servingsTr == servingsTr)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.carbohydrates, carbohydrates) || other.carbohydrates == carbohydrates)&&(identical(other.cholesterol, cholesterol) || other.cholesterol == cholesterol)&&(identical(other.fiber, fiber) || other.fiber == fiber)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.saturatedFat, saturatedFat) || other.saturatedFat == saturatedFat)&&(identical(other.sodium, sodium) || other.sodium == sodium)&&(identical(other.sugar, sugar) || other.sugar == sugar)&&(identical(other.fat, fat) || other.fat == fat)&&(identical(other.unsaturatedFat, unsaturatedFat) || other.unsaturatedFat == unsaturatedFat)&&const DeepCollectionEquality().equals(other.nutritionRaw, nutritionRaw)&&(identical(other.url, url) || other.url == url)&&(identical(other.recipeCategory, recipeCategory) || other.recipeCategory == recipeCategory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,recipeId,name,nameTr,ratingValue,ratingCount,prepTimeMinutes,cookTimeMinutes,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(cuisines),const DeepCollectionEquality().hash(ingredients),const DeepCollectionEquality().hash(ingredientsTr),const DeepCollectionEquality().hash(ingredientsRaw),const DeepCollectionEquality().hash(ingredientsRawTr),const DeepCollectionEquality().hash(instructions),const DeepCollectionEquality().hash(instructionsTr),const DeepCollectionEquality().hash(cookingMethods),const DeepCollectionEquality().hash(implementsList),numberOfSteps,servings,servingsTr,calories,carbohydrates,cholesterol,fiber,protein,saturatedFat,sodium,sugar,fat,unsaturatedFat,const DeepCollectionEquality().hash(nutritionRaw),url,recipeCategory]);



}

/// @nodoc
abstract mixin class $FoodCopyWith<$Res>  {
  factory $FoodCopyWith(Food value, $Res Function(Food) _then) = _$FoodCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int recipeId, String name,@JsonKey(name: 'name_tr') String nameTr, double? ratingValue, int? ratingCount, int? prepTimeMinutes, int? cookTimeMinutes, List<String> categories, List<String> cuisines, List<Ingredient> ingredients,@JsonKey(name: 'ingredients_tr') List<Ingredient> ingredientsTr, List<String> ingredientsRaw,@JsonKey(name: 'ingredients_raw_tr') List<String> ingredientsRawTr, List<String> instructions,@JsonKey(name: 'instructions_tr') List<String> instructionsTr, List<String> cookingMethods,@JsonKey(name: 'implements') List<String> implementsList, int? numberOfSteps, String? servings,@JsonKey(name: 'servings_tr') String? servingsTr, double? calories, double? carbohydrates, double? cholesterol, double? fiber, double? protein, double? saturatedFat, double? sodium, double? sugar, double? fat, double? unsaturatedFat,@JsonKey(name: 'nutrition_raw') Map<String, String> nutritionRaw, String? url,@JsonKey(includeFromJson: false, includeToJson: false) CategoriesEnum recipeCategory
});




}
/// @nodoc
class _$FoodCopyWithImpl<$Res>
    implements $FoodCopyWith<$Res> {
  _$FoodCopyWithImpl(this._self, this._then);

  final Food _self;
  final $Res Function(Food) _then;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recipeId = null,Object? name = null,Object? nameTr = null,Object? ratingValue = freezed,Object? ratingCount = freezed,Object? prepTimeMinutes = freezed,Object? cookTimeMinutes = freezed,Object? categories = null,Object? cuisines = null,Object? ingredients = null,Object? ingredientsTr = null,Object? ingredientsRaw = null,Object? ingredientsRawTr = null,Object? instructions = null,Object? instructionsTr = null,Object? cookingMethods = null,Object? implementsList = null,Object? numberOfSteps = freezed,Object? servings = freezed,Object? servingsTr = freezed,Object? calories = freezed,Object? carbohydrates = freezed,Object? cholesterol = freezed,Object? fiber = freezed,Object? protein = freezed,Object? saturatedFat = freezed,Object? sodium = freezed,Object? sugar = freezed,Object? fat = freezed,Object? unsaturatedFat = freezed,Object? nutritionRaw = null,Object? url = freezed,Object? recipeCategory = null,}) {
  return _then(_self.copyWith(
recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameTr: null == nameTr ? _self.nameTr : nameTr // ignore: cast_nullable_to_non_nullable
as String,ratingValue: freezed == ratingValue ? _self.ratingValue : ratingValue // ignore: cast_nullable_to_non_nullable
as double?,ratingCount: freezed == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int?,prepTimeMinutes: freezed == prepTimeMinutes ? _self.prepTimeMinutes : prepTimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,cookTimeMinutes: freezed == cookTimeMinutes ? _self.cookTimeMinutes : cookTimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,cuisines: null == cuisines ? _self.cuisines : cuisines // ignore: cast_nullable_to_non_nullable
as List<String>,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,ingredientsTr: null == ingredientsTr ? _self.ingredientsTr : ingredientsTr // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,ingredientsRaw: null == ingredientsRaw ? _self.ingredientsRaw : ingredientsRaw // ignore: cast_nullable_to_non_nullable
as List<String>,ingredientsRawTr: null == ingredientsRawTr ? _self.ingredientsRawTr : ingredientsRawTr // ignore: cast_nullable_to_non_nullable
as List<String>,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<String>,instructionsTr: null == instructionsTr ? _self.instructionsTr : instructionsTr // ignore: cast_nullable_to_non_nullable
as List<String>,cookingMethods: null == cookingMethods ? _self.cookingMethods : cookingMethods // ignore: cast_nullable_to_non_nullable
as List<String>,implementsList: null == implementsList ? _self.implementsList : implementsList // ignore: cast_nullable_to_non_nullable
as List<String>,numberOfSteps: freezed == numberOfSteps ? _self.numberOfSteps : numberOfSteps // ignore: cast_nullable_to_non_nullable
as int?,servings: freezed == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as String?,servingsTr: freezed == servingsTr ? _self.servingsTr : servingsTr // ignore: cast_nullable_to_non_nullable
as String?,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double?,carbohydrates: freezed == carbohydrates ? _self.carbohydrates : carbohydrates // ignore: cast_nullable_to_non_nullable
as double?,cholesterol: freezed == cholesterol ? _self.cholesterol : cholesterol // ignore: cast_nullable_to_non_nullable
as double?,fiber: freezed == fiber ? _self.fiber : fiber // ignore: cast_nullable_to_non_nullable
as double?,protein: freezed == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double?,saturatedFat: freezed == saturatedFat ? _self.saturatedFat : saturatedFat // ignore: cast_nullable_to_non_nullable
as double?,sodium: freezed == sodium ? _self.sodium : sodium // ignore: cast_nullable_to_non_nullable
as double?,sugar: freezed == sugar ? _self.sugar : sugar // ignore: cast_nullable_to_non_nullable
as double?,fat: freezed == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double?,unsaturatedFat: freezed == unsaturatedFat ? _self.unsaturatedFat : unsaturatedFat // ignore: cast_nullable_to_non_nullable
as double?,nutritionRaw: null == nutritionRaw ? _self.nutritionRaw : nutritionRaw // ignore: cast_nullable_to_non_nullable
as Map<String, String>,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,recipeCategory: null == recipeCategory ? _self.recipeCategory : recipeCategory // ignore: cast_nullable_to_non_nullable
as CategoriesEnum,
  ));
}

}


/// Adds pattern-matching-related methods to [Food].
extension FoodPatterns on Food {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Food value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Food value)  $default,){
final _that = this;
switch (_that) {
case _Food():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Food value)?  $default,){
final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int recipeId,  String name, @JsonKey(name: 'name_tr')  String nameTr,  double? ratingValue,  int? ratingCount,  int? prepTimeMinutes,  int? cookTimeMinutes,  List<String> categories,  List<String> cuisines,  List<Ingredient> ingredients, @JsonKey(name: 'ingredients_tr')  List<Ingredient> ingredientsTr,  List<String> ingredientsRaw, @JsonKey(name: 'ingredients_raw_tr')  List<String> ingredientsRawTr,  List<String> instructions, @JsonKey(name: 'instructions_tr')  List<String> instructionsTr,  List<String> cookingMethods, @JsonKey(name: 'implements')  List<String> implementsList,  int? numberOfSteps,  String? servings, @JsonKey(name: 'servings_tr')  String? servingsTr,  double? calories,  double? carbohydrates,  double? cholesterol,  double? fiber,  double? protein,  double? saturatedFat,  double? sodium,  double? sugar,  double? fat,  double? unsaturatedFat, @JsonKey(name: 'nutrition_raw')  Map<String, String> nutritionRaw,  String? url, @JsonKey(includeFromJson: false, includeToJson: false)  CategoriesEnum recipeCategory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that.recipeId,_that.name,_that.nameTr,_that.ratingValue,_that.ratingCount,_that.prepTimeMinutes,_that.cookTimeMinutes,_that.categories,_that.cuisines,_that.ingredients,_that.ingredientsTr,_that.ingredientsRaw,_that.ingredientsRawTr,_that.instructions,_that.instructionsTr,_that.cookingMethods,_that.implementsList,_that.numberOfSteps,_that.servings,_that.servingsTr,_that.calories,_that.carbohydrates,_that.cholesterol,_that.fiber,_that.protein,_that.saturatedFat,_that.sodium,_that.sugar,_that.fat,_that.unsaturatedFat,_that.nutritionRaw,_that.url,_that.recipeCategory);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int recipeId,  String name, @JsonKey(name: 'name_tr')  String nameTr,  double? ratingValue,  int? ratingCount,  int? prepTimeMinutes,  int? cookTimeMinutes,  List<String> categories,  List<String> cuisines,  List<Ingredient> ingredients, @JsonKey(name: 'ingredients_tr')  List<Ingredient> ingredientsTr,  List<String> ingredientsRaw, @JsonKey(name: 'ingredients_raw_tr')  List<String> ingredientsRawTr,  List<String> instructions, @JsonKey(name: 'instructions_tr')  List<String> instructionsTr,  List<String> cookingMethods, @JsonKey(name: 'implements')  List<String> implementsList,  int? numberOfSteps,  String? servings, @JsonKey(name: 'servings_tr')  String? servingsTr,  double? calories,  double? carbohydrates,  double? cholesterol,  double? fiber,  double? protein,  double? saturatedFat,  double? sodium,  double? sugar,  double? fat,  double? unsaturatedFat, @JsonKey(name: 'nutrition_raw')  Map<String, String> nutritionRaw,  String? url, @JsonKey(includeFromJson: false, includeToJson: false)  CategoriesEnum recipeCategory)  $default,) {final _that = this;
switch (_that) {
case _Food():
return $default(_that.recipeId,_that.name,_that.nameTr,_that.ratingValue,_that.ratingCount,_that.prepTimeMinutes,_that.cookTimeMinutes,_that.categories,_that.cuisines,_that.ingredients,_that.ingredientsTr,_that.ingredientsRaw,_that.ingredientsRawTr,_that.instructions,_that.instructionsTr,_that.cookingMethods,_that.implementsList,_that.numberOfSteps,_that.servings,_that.servingsTr,_that.calories,_that.carbohydrates,_that.cholesterol,_that.fiber,_that.protein,_that.saturatedFat,_that.sodium,_that.sugar,_that.fat,_that.unsaturatedFat,_that.nutritionRaw,_that.url,_that.recipeCategory);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int recipeId,  String name, @JsonKey(name: 'name_tr')  String nameTr,  double? ratingValue,  int? ratingCount,  int? prepTimeMinutes,  int? cookTimeMinutes,  List<String> categories,  List<String> cuisines,  List<Ingredient> ingredients, @JsonKey(name: 'ingredients_tr')  List<Ingredient> ingredientsTr,  List<String> ingredientsRaw, @JsonKey(name: 'ingredients_raw_tr')  List<String> ingredientsRawTr,  List<String> instructions, @JsonKey(name: 'instructions_tr')  List<String> instructionsTr,  List<String> cookingMethods, @JsonKey(name: 'implements')  List<String> implementsList,  int? numberOfSteps,  String? servings, @JsonKey(name: 'servings_tr')  String? servingsTr,  double? calories,  double? carbohydrates,  double? cholesterol,  double? fiber,  double? protein,  double? saturatedFat,  double? sodium,  double? sugar,  double? fat,  double? unsaturatedFat, @JsonKey(name: 'nutrition_raw')  Map<String, String> nutritionRaw,  String? url, @JsonKey(includeFromJson: false, includeToJson: false)  CategoriesEnum recipeCategory)?  $default,) {final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that.recipeId,_that.name,_that.nameTr,_that.ratingValue,_that.ratingCount,_that.prepTimeMinutes,_that.cookTimeMinutes,_that.categories,_that.cuisines,_that.ingredients,_that.ingredientsTr,_that.ingredientsRaw,_that.ingredientsRawTr,_that.instructions,_that.instructionsTr,_that.cookingMethods,_that.implementsList,_that.numberOfSteps,_that.servings,_that.servingsTr,_that.calories,_that.carbohydrates,_that.cholesterol,_that.fiber,_that.protein,_that.saturatedFat,_that.sodium,_that.sugar,_that.fat,_that.unsaturatedFat,_that.nutritionRaw,_that.url,_that.recipeCategory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Food extends Food {
  const _Food({@JsonKey(name: 'id') required this.recipeId, required this.name, @JsonKey(name: 'name_tr') required this.nameTr, this.ratingValue, this.ratingCount, this.prepTimeMinutes, this.cookTimeMinutes, final  List<String> categories = const <String>[], final  List<String> cuisines = const <String>[], final  List<Ingredient> ingredients = const <Ingredient>[], @JsonKey(name: 'ingredients_tr') final  List<Ingredient> ingredientsTr = const <Ingredient>[], final  List<String> ingredientsRaw = const <String>[], @JsonKey(name: 'ingredients_raw_tr') final  List<String> ingredientsRawTr = const <String>[], final  List<String> instructions = const <String>[], @JsonKey(name: 'instructions_tr') final  List<String> instructionsTr = const <String>[], final  List<String> cookingMethods = const <String>[], @JsonKey(name: 'implements') final  List<String> implementsList = const <String>[], this.numberOfSteps, this.servings, @JsonKey(name: 'servings_tr') this.servingsTr, this.calories, this.carbohydrates, this.cholesterol, this.fiber, this.protein, this.saturatedFat, this.sodium, this.sugar, this.fat, this.unsaturatedFat, @JsonKey(name: 'nutrition_raw') final  Map<String, String> nutritionRaw = const <String, String>{}, this.url, @JsonKey(includeFromJson: false, includeToJson: false) this.recipeCategory = CategoriesEnum.none}): _categories = categories,_cuisines = cuisines,_ingredients = ingredients,_ingredientsTr = ingredientsTr,_ingredientsRaw = ingredientsRaw,_ingredientsRawTr = ingredientsRawTr,_instructions = instructions,_instructionsTr = instructionsTr,_cookingMethods = cookingMethods,_implementsList = implementsList,_nutritionRaw = nutritionRaw,super._();
  factory _Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);

@override@JsonKey(name: 'id') final  int recipeId;
@override final  String name;
@override@JsonKey(name: 'name_tr') final  String nameTr;
@override final  double? ratingValue;
@override final  int? ratingCount;
@override final  int? prepTimeMinutes;
@override final  int? cookTimeMinutes;
 final  List<String> _categories;
@override@JsonKey() List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<String> _cuisines;
@override@JsonKey() List<String> get cuisines {
  if (_cuisines is EqualUnmodifiableListView) return _cuisines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cuisines);
}

 final  List<Ingredient> _ingredients;
@override@JsonKey() List<Ingredient> get ingredients {
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredients);
}

 final  List<Ingredient> _ingredientsTr;
@override@JsonKey(name: 'ingredients_tr') List<Ingredient> get ingredientsTr {
  if (_ingredientsTr is EqualUnmodifiableListView) return _ingredientsTr;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredientsTr);
}

 final  List<String> _ingredientsRaw;
@override@JsonKey() List<String> get ingredientsRaw {
  if (_ingredientsRaw is EqualUnmodifiableListView) return _ingredientsRaw;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredientsRaw);
}

 final  List<String> _ingredientsRawTr;
@override@JsonKey(name: 'ingredients_raw_tr') List<String> get ingredientsRawTr {
  if (_ingredientsRawTr is EqualUnmodifiableListView) return _ingredientsRawTr;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredientsRawTr);
}

 final  List<String> _instructions;
@override@JsonKey() List<String> get instructions {
  if (_instructions is EqualUnmodifiableListView) return _instructions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_instructions);
}

 final  List<String> _instructionsTr;
@override@JsonKey(name: 'instructions_tr') List<String> get instructionsTr {
  if (_instructionsTr is EqualUnmodifiableListView) return _instructionsTr;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_instructionsTr);
}

 final  List<String> _cookingMethods;
@override@JsonKey() List<String> get cookingMethods {
  if (_cookingMethods is EqualUnmodifiableListView) return _cookingMethods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cookingMethods);
}

 final  List<String> _implementsList;
@override@JsonKey(name: 'implements') List<String> get implementsList {
  if (_implementsList is EqualUnmodifiableListView) return _implementsList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_implementsList);
}

@override final  int? numberOfSteps;
@override final  String? servings;
@override@JsonKey(name: 'servings_tr') final  String? servingsTr;
@override final  double? calories;
@override final  double? carbohydrates;
@override final  double? cholesterol;
@override final  double? fiber;
@override final  double? protein;
@override final  double? saturatedFat;
@override final  double? sodium;
@override final  double? sugar;
@override final  double? fat;
@override final  double? unsaturatedFat;
 final  Map<String, String> _nutritionRaw;
@override@JsonKey(name: 'nutrition_raw') Map<String, String> get nutritionRaw {
  if (_nutritionRaw is EqualUnmodifiableMapView) return _nutritionRaw;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_nutritionRaw);
}

@override final  String? url;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  CategoriesEnum recipeCategory;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodCopyWith<_Food> get copyWith => __$FoodCopyWithImpl<_Food>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FoodToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Food&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameTr, nameTr) || other.nameTr == nameTr)&&(identical(other.ratingValue, ratingValue) || other.ratingValue == ratingValue)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.prepTimeMinutes, prepTimeMinutes) || other.prepTimeMinutes == prepTimeMinutes)&&(identical(other.cookTimeMinutes, cookTimeMinutes) || other.cookTimeMinutes == cookTimeMinutes)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._cuisines, _cuisines)&&const DeepCollectionEquality().equals(other._ingredients, _ingredients)&&const DeepCollectionEquality().equals(other._ingredientsTr, _ingredientsTr)&&const DeepCollectionEquality().equals(other._ingredientsRaw, _ingredientsRaw)&&const DeepCollectionEquality().equals(other._ingredientsRawTr, _ingredientsRawTr)&&const DeepCollectionEquality().equals(other._instructions, _instructions)&&const DeepCollectionEquality().equals(other._instructionsTr, _instructionsTr)&&const DeepCollectionEquality().equals(other._cookingMethods, _cookingMethods)&&const DeepCollectionEquality().equals(other._implementsList, _implementsList)&&(identical(other.numberOfSteps, numberOfSteps) || other.numberOfSteps == numberOfSteps)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.servingsTr, servingsTr) || other.servingsTr == servingsTr)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.carbohydrates, carbohydrates) || other.carbohydrates == carbohydrates)&&(identical(other.cholesterol, cholesterol) || other.cholesterol == cholesterol)&&(identical(other.fiber, fiber) || other.fiber == fiber)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.saturatedFat, saturatedFat) || other.saturatedFat == saturatedFat)&&(identical(other.sodium, sodium) || other.sodium == sodium)&&(identical(other.sugar, sugar) || other.sugar == sugar)&&(identical(other.fat, fat) || other.fat == fat)&&(identical(other.unsaturatedFat, unsaturatedFat) || other.unsaturatedFat == unsaturatedFat)&&const DeepCollectionEquality().equals(other._nutritionRaw, _nutritionRaw)&&(identical(other.url, url) || other.url == url)&&(identical(other.recipeCategory, recipeCategory) || other.recipeCategory == recipeCategory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,recipeId,name,nameTr,ratingValue,ratingCount,prepTimeMinutes,cookTimeMinutes,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_cuisines),const DeepCollectionEquality().hash(_ingredients),const DeepCollectionEquality().hash(_ingredientsTr),const DeepCollectionEquality().hash(_ingredientsRaw),const DeepCollectionEquality().hash(_ingredientsRawTr),const DeepCollectionEquality().hash(_instructions),const DeepCollectionEquality().hash(_instructionsTr),const DeepCollectionEquality().hash(_cookingMethods),const DeepCollectionEquality().hash(_implementsList),numberOfSteps,servings,servingsTr,calories,carbohydrates,cholesterol,fiber,protein,saturatedFat,sodium,sugar,fat,unsaturatedFat,const DeepCollectionEquality().hash(_nutritionRaw),url,recipeCategory]);



}

/// @nodoc
abstract mixin class _$FoodCopyWith<$Res> implements $FoodCopyWith<$Res> {
  factory _$FoodCopyWith(_Food value, $Res Function(_Food) _then) = __$FoodCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int recipeId, String name,@JsonKey(name: 'name_tr') String nameTr, double? ratingValue, int? ratingCount, int? prepTimeMinutes, int? cookTimeMinutes, List<String> categories, List<String> cuisines, List<Ingredient> ingredients,@JsonKey(name: 'ingredients_tr') List<Ingredient> ingredientsTr, List<String> ingredientsRaw,@JsonKey(name: 'ingredients_raw_tr') List<String> ingredientsRawTr, List<String> instructions,@JsonKey(name: 'instructions_tr') List<String> instructionsTr, List<String> cookingMethods,@JsonKey(name: 'implements') List<String> implementsList, int? numberOfSteps, String? servings,@JsonKey(name: 'servings_tr') String? servingsTr, double? calories, double? carbohydrates, double? cholesterol, double? fiber, double? protein, double? saturatedFat, double? sodium, double? sugar, double? fat, double? unsaturatedFat,@JsonKey(name: 'nutrition_raw') Map<String, String> nutritionRaw, String? url,@JsonKey(includeFromJson: false, includeToJson: false) CategoriesEnum recipeCategory
});




}
/// @nodoc
class __$FoodCopyWithImpl<$Res>
    implements _$FoodCopyWith<$Res> {
  __$FoodCopyWithImpl(this._self, this._then);

  final _Food _self;
  final $Res Function(_Food) _then;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recipeId = null,Object? name = null,Object? nameTr = null,Object? ratingValue = freezed,Object? ratingCount = freezed,Object? prepTimeMinutes = freezed,Object? cookTimeMinutes = freezed,Object? categories = null,Object? cuisines = null,Object? ingredients = null,Object? ingredientsTr = null,Object? ingredientsRaw = null,Object? ingredientsRawTr = null,Object? instructions = null,Object? instructionsTr = null,Object? cookingMethods = null,Object? implementsList = null,Object? numberOfSteps = freezed,Object? servings = freezed,Object? servingsTr = freezed,Object? calories = freezed,Object? carbohydrates = freezed,Object? cholesterol = freezed,Object? fiber = freezed,Object? protein = freezed,Object? saturatedFat = freezed,Object? sodium = freezed,Object? sugar = freezed,Object? fat = freezed,Object? unsaturatedFat = freezed,Object? nutritionRaw = null,Object? url = freezed,Object? recipeCategory = null,}) {
  return _then(_Food(
recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameTr: null == nameTr ? _self.nameTr : nameTr // ignore: cast_nullable_to_non_nullable
as String,ratingValue: freezed == ratingValue ? _self.ratingValue : ratingValue // ignore: cast_nullable_to_non_nullable
as double?,ratingCount: freezed == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int?,prepTimeMinutes: freezed == prepTimeMinutes ? _self.prepTimeMinutes : prepTimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,cookTimeMinutes: freezed == cookTimeMinutes ? _self.cookTimeMinutes : cookTimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,cuisines: null == cuisines ? _self._cuisines : cuisines // ignore: cast_nullable_to_non_nullable
as List<String>,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,ingredientsTr: null == ingredientsTr ? _self._ingredientsTr : ingredientsTr // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,ingredientsRaw: null == ingredientsRaw ? _self._ingredientsRaw : ingredientsRaw // ignore: cast_nullable_to_non_nullable
as List<String>,ingredientsRawTr: null == ingredientsRawTr ? _self._ingredientsRawTr : ingredientsRawTr // ignore: cast_nullable_to_non_nullable
as List<String>,instructions: null == instructions ? _self._instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<String>,instructionsTr: null == instructionsTr ? _self._instructionsTr : instructionsTr // ignore: cast_nullable_to_non_nullable
as List<String>,cookingMethods: null == cookingMethods ? _self._cookingMethods : cookingMethods // ignore: cast_nullable_to_non_nullable
as List<String>,implementsList: null == implementsList ? _self._implementsList : implementsList // ignore: cast_nullable_to_non_nullable
as List<String>,numberOfSteps: freezed == numberOfSteps ? _self.numberOfSteps : numberOfSteps // ignore: cast_nullable_to_non_nullable
as int?,servings: freezed == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as String?,servingsTr: freezed == servingsTr ? _self.servingsTr : servingsTr // ignore: cast_nullable_to_non_nullable
as String?,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double?,carbohydrates: freezed == carbohydrates ? _self.carbohydrates : carbohydrates // ignore: cast_nullable_to_non_nullable
as double?,cholesterol: freezed == cholesterol ? _self.cholesterol : cholesterol // ignore: cast_nullable_to_non_nullable
as double?,fiber: freezed == fiber ? _self.fiber : fiber // ignore: cast_nullable_to_non_nullable
as double?,protein: freezed == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double?,saturatedFat: freezed == saturatedFat ? _self.saturatedFat : saturatedFat // ignore: cast_nullable_to_non_nullable
as double?,sodium: freezed == sodium ? _self.sodium : sodium // ignore: cast_nullable_to_non_nullable
as double?,sugar: freezed == sugar ? _self.sugar : sugar // ignore: cast_nullable_to_non_nullable
as double?,fat: freezed == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double?,unsaturatedFat: freezed == unsaturatedFat ? _self.unsaturatedFat : unsaturatedFat // ignore: cast_nullable_to_non_nullable
as double?,nutritionRaw: null == nutritionRaw ? _self._nutritionRaw : nutritionRaw // ignore: cast_nullable_to_non_nullable
as Map<String, String>,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,recipeCategory: null == recipeCategory ? _self.recipeCategory : recipeCategory // ignore: cast_nullable_to_non_nullable
as CategoriesEnum,
  ));
}


}

// dart format on
