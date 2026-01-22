// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Food _$FoodFromJson(Map<String, dynamic> json) {
  return _Food.fromJson(json);
}

/// @nodoc
mixin _$Food {
  @JsonKey(name: 'id')
  int get recipeId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_tr')
  String get nameTr => throw _privateConstructorUsedError;
  double? get ratingValue => throw _privateConstructorUsedError;
  int? get ratingCount => throw _privateConstructorUsedError;
  int? get prepTimeMinutes => throw _privateConstructorUsedError;
  int? get cookTimeMinutes => throw _privateConstructorUsedError;
  List<String> get categories => throw _privateConstructorUsedError;
  List<String> get cuisines => throw _privateConstructorUsedError;
  List<Ingredient> get ingredients => throw _privateConstructorUsedError;
  @JsonKey(name: 'ingredients_tr')
  List<Ingredient> get ingredientsTr => throw _privateConstructorUsedError;
  List<String> get ingredientsRaw => throw _privateConstructorUsedError;
  @JsonKey(name: 'ingredients_raw_tr')
  List<String> get ingredientsRawTr => throw _privateConstructorUsedError;
  List<String> get instructions => throw _privateConstructorUsedError;
  @JsonKey(name: 'instructions_tr')
  List<String> get instructionsTr => throw _privateConstructorUsedError;
  List<String> get cookingMethods => throw _privateConstructorUsedError;
  @JsonKey(name: 'implements')
  List<String> get implementsList => throw _privateConstructorUsedError;
  int? get numberOfSteps => throw _privateConstructorUsedError;
  String? get servings => throw _privateConstructorUsedError;
  @JsonKey(name: 'servings_tr')
  String? get servingsTr => throw _privateConstructorUsedError;
  double? get calories => throw _privateConstructorUsedError;
  double? get carbohydrates => throw _privateConstructorUsedError;
  double? get cholesterol => throw _privateConstructorUsedError;
  double? get fiber => throw _privateConstructorUsedError;
  double? get protein => throw _privateConstructorUsedError;
  double? get saturatedFat => throw _privateConstructorUsedError;
  double? get sodium => throw _privateConstructorUsedError;
  double? get sugar => throw _privateConstructorUsedError;
  double? get fat => throw _privateConstructorUsedError;
  double? get unsaturatedFat => throw _privateConstructorUsedError;
  @JsonKey(name: 'nutrition_raw')
  Map<String, String> get nutritionRaw => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  CategoriesEnum get recipeCategory => throw _privateConstructorUsedError;

  /// Serializes this Food to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Food
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodCopyWith<Food> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodCopyWith<$Res> {
  factory $FoodCopyWith(Food value, $Res Function(Food) then) =
      _$FoodCopyWithImpl<$Res, Food>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int recipeId,
      String name,
      @JsonKey(name: 'name_tr') String nameTr,
      double? ratingValue,
      int? ratingCount,
      int? prepTimeMinutes,
      int? cookTimeMinutes,
      List<String> categories,
      List<String> cuisines,
      List<Ingredient> ingredients,
      @JsonKey(name: 'ingredients_tr') List<Ingredient> ingredientsTr,
      List<String> ingredientsRaw,
      @JsonKey(name: 'ingredients_raw_tr') List<String> ingredientsRawTr,
      List<String> instructions,
      @JsonKey(name: 'instructions_tr') List<String> instructionsTr,
      List<String> cookingMethods,
      @JsonKey(name: 'implements') List<String> implementsList,
      int? numberOfSteps,
      String? servings,
      @JsonKey(name: 'servings_tr') String? servingsTr,
      double? calories,
      double? carbohydrates,
      double? cholesterol,
      double? fiber,
      double? protein,
      double? saturatedFat,
      double? sodium,
      double? sugar,
      double? fat,
      double? unsaturatedFat,
      @JsonKey(name: 'nutrition_raw') Map<String, String> nutritionRaw,
      String? url,
      @JsonKey(includeFromJson: false, includeToJson: false)
      CategoriesEnum recipeCategory});
}

/// @nodoc
class _$FoodCopyWithImpl<$Res, $Val extends Food>
    implements $FoodCopyWith<$Res> {
  _$FoodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Food
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipeId = null,
    Object? name = null,
    Object? nameTr = null,
    Object? ratingValue = freezed,
    Object? ratingCount = freezed,
    Object? prepTimeMinutes = freezed,
    Object? cookTimeMinutes = freezed,
    Object? categories = null,
    Object? cuisines = null,
    Object? ingredients = null,
    Object? ingredientsTr = null,
    Object? ingredientsRaw = null,
    Object? ingredientsRawTr = null,
    Object? instructions = null,
    Object? instructionsTr = null,
    Object? cookingMethods = null,
    Object? implementsList = null,
    Object? numberOfSteps = freezed,
    Object? servings = freezed,
    Object? servingsTr = freezed,
    Object? calories = freezed,
    Object? carbohydrates = freezed,
    Object? cholesterol = freezed,
    Object? fiber = freezed,
    Object? protein = freezed,
    Object? saturatedFat = freezed,
    Object? sodium = freezed,
    Object? sugar = freezed,
    Object? fat = freezed,
    Object? unsaturatedFat = freezed,
    Object? nutritionRaw = null,
    Object? url = freezed,
    Object? recipeCategory = null,
  }) {
    return _then(_value.copyWith(
      recipeId: null == recipeId
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameTr: null == nameTr
          ? _value.nameTr
          : nameTr // ignore: cast_nullable_to_non_nullable
              as String,
      ratingValue: freezed == ratingValue
          ? _value.ratingValue
          : ratingValue // ignore: cast_nullable_to_non_nullable
              as double?,
      ratingCount: freezed == ratingCount
          ? _value.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int?,
      prepTimeMinutes: freezed == prepTimeMinutes
          ? _value.prepTimeMinutes
          : prepTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      cookTimeMinutes: freezed == cookTimeMinutes
          ? _value.cookTimeMinutes
          : cookTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cuisines: null == cuisines
          ? _value.cuisines
          : cuisines // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      ingredientsTr: null == ingredientsTr
          ? _value.ingredientsTr
          : ingredientsTr // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      ingredientsRaw: null == ingredientsRaw
          ? _value.ingredientsRaw
          : ingredientsRaw // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ingredientsRawTr: null == ingredientsRawTr
          ? _value.ingredientsRawTr
          : ingredientsRawTr // ignore: cast_nullable_to_non_nullable
              as List<String>,
      instructions: null == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      instructionsTr: null == instructionsTr
          ? _value.instructionsTr
          : instructionsTr // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cookingMethods: null == cookingMethods
          ? _value.cookingMethods
          : cookingMethods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      implementsList: null == implementsList
          ? _value.implementsList
          : implementsList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      numberOfSteps: freezed == numberOfSteps
          ? _value.numberOfSteps
          : numberOfSteps // ignore: cast_nullable_to_non_nullable
              as int?,
      servings: freezed == servings
          ? _value.servings
          : servings // ignore: cast_nullable_to_non_nullable
              as String?,
      servingsTr: freezed == servingsTr
          ? _value.servingsTr
          : servingsTr // ignore: cast_nullable_to_non_nullable
              as String?,
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double?,
      carbohydrates: freezed == carbohydrates
          ? _value.carbohydrates
          : carbohydrates // ignore: cast_nullable_to_non_nullable
              as double?,
      cholesterol: freezed == cholesterol
          ? _value.cholesterol
          : cholesterol // ignore: cast_nullable_to_non_nullable
              as double?,
      fiber: freezed == fiber
          ? _value.fiber
          : fiber // ignore: cast_nullable_to_non_nullable
              as double?,
      protein: freezed == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double?,
      saturatedFat: freezed == saturatedFat
          ? _value.saturatedFat
          : saturatedFat // ignore: cast_nullable_to_non_nullable
              as double?,
      sodium: freezed == sodium
          ? _value.sodium
          : sodium // ignore: cast_nullable_to_non_nullable
              as double?,
      sugar: freezed == sugar
          ? _value.sugar
          : sugar // ignore: cast_nullable_to_non_nullable
              as double?,
      fat: freezed == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double?,
      unsaturatedFat: freezed == unsaturatedFat
          ? _value.unsaturatedFat
          : unsaturatedFat // ignore: cast_nullable_to_non_nullable
              as double?,
      nutritionRaw: null == nutritionRaw
          ? _value.nutritionRaw
          : nutritionRaw // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      recipeCategory: null == recipeCategory
          ? _value.recipeCategory
          : recipeCategory // ignore: cast_nullable_to_non_nullable
              as CategoriesEnum,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodImplCopyWith<$Res> implements $FoodCopyWith<$Res> {
  factory _$$FoodImplCopyWith(
          _$FoodImpl value, $Res Function(_$FoodImpl) then) =
      __$$FoodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int recipeId,
      String name,
      @JsonKey(name: 'name_tr') String nameTr,
      double? ratingValue,
      int? ratingCount,
      int? prepTimeMinutes,
      int? cookTimeMinutes,
      List<String> categories,
      List<String> cuisines,
      List<Ingredient> ingredients,
      @JsonKey(name: 'ingredients_tr') List<Ingredient> ingredientsTr,
      List<String> ingredientsRaw,
      @JsonKey(name: 'ingredients_raw_tr') List<String> ingredientsRawTr,
      List<String> instructions,
      @JsonKey(name: 'instructions_tr') List<String> instructionsTr,
      List<String> cookingMethods,
      @JsonKey(name: 'implements') List<String> implementsList,
      int? numberOfSteps,
      String? servings,
      @JsonKey(name: 'servings_tr') String? servingsTr,
      double? calories,
      double? carbohydrates,
      double? cholesterol,
      double? fiber,
      double? protein,
      double? saturatedFat,
      double? sodium,
      double? sugar,
      double? fat,
      double? unsaturatedFat,
      @JsonKey(name: 'nutrition_raw') Map<String, String> nutritionRaw,
      String? url,
      @JsonKey(includeFromJson: false, includeToJson: false)
      CategoriesEnum recipeCategory});
}

/// @nodoc
class __$$FoodImplCopyWithImpl<$Res>
    extends _$FoodCopyWithImpl<$Res, _$FoodImpl>
    implements _$$FoodImplCopyWith<$Res> {
  __$$FoodImplCopyWithImpl(_$FoodImpl _value, $Res Function(_$FoodImpl) _then)
      : super(_value, _then);

  /// Create a copy of Food
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipeId = null,
    Object? name = null,
    Object? nameTr = null,
    Object? ratingValue = freezed,
    Object? ratingCount = freezed,
    Object? prepTimeMinutes = freezed,
    Object? cookTimeMinutes = freezed,
    Object? categories = null,
    Object? cuisines = null,
    Object? ingredients = null,
    Object? ingredientsTr = null,
    Object? ingredientsRaw = null,
    Object? ingredientsRawTr = null,
    Object? instructions = null,
    Object? instructionsTr = null,
    Object? cookingMethods = null,
    Object? implementsList = null,
    Object? numberOfSteps = freezed,
    Object? servings = freezed,
    Object? servingsTr = freezed,
    Object? calories = freezed,
    Object? carbohydrates = freezed,
    Object? cholesterol = freezed,
    Object? fiber = freezed,
    Object? protein = freezed,
    Object? saturatedFat = freezed,
    Object? sodium = freezed,
    Object? sugar = freezed,
    Object? fat = freezed,
    Object? unsaturatedFat = freezed,
    Object? nutritionRaw = null,
    Object? url = freezed,
    Object? recipeCategory = null,
  }) {
    return _then(_$FoodImpl(
      recipeId: null == recipeId
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameTr: null == nameTr
          ? _value.nameTr
          : nameTr // ignore: cast_nullable_to_non_nullable
              as String,
      ratingValue: freezed == ratingValue
          ? _value.ratingValue
          : ratingValue // ignore: cast_nullable_to_non_nullable
              as double?,
      ratingCount: freezed == ratingCount
          ? _value.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int?,
      prepTimeMinutes: freezed == prepTimeMinutes
          ? _value.prepTimeMinutes
          : prepTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      cookTimeMinutes: freezed == cookTimeMinutes
          ? _value.cookTimeMinutes
          : cookTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cuisines: null == cuisines
          ? _value._cuisines
          : cuisines // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      ingredientsTr: null == ingredientsTr
          ? _value._ingredientsTr
          : ingredientsTr // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      ingredientsRaw: null == ingredientsRaw
          ? _value._ingredientsRaw
          : ingredientsRaw // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ingredientsRawTr: null == ingredientsRawTr
          ? _value._ingredientsRawTr
          : ingredientsRawTr // ignore: cast_nullable_to_non_nullable
              as List<String>,
      instructions: null == instructions
          ? _value._instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      instructionsTr: null == instructionsTr
          ? _value._instructionsTr
          : instructionsTr // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cookingMethods: null == cookingMethods
          ? _value._cookingMethods
          : cookingMethods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      implementsList: null == implementsList
          ? _value._implementsList
          : implementsList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      numberOfSteps: freezed == numberOfSteps
          ? _value.numberOfSteps
          : numberOfSteps // ignore: cast_nullable_to_non_nullable
              as int?,
      servings: freezed == servings
          ? _value.servings
          : servings // ignore: cast_nullable_to_non_nullable
              as String?,
      servingsTr: freezed == servingsTr
          ? _value.servingsTr
          : servingsTr // ignore: cast_nullable_to_non_nullable
              as String?,
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double?,
      carbohydrates: freezed == carbohydrates
          ? _value.carbohydrates
          : carbohydrates // ignore: cast_nullable_to_non_nullable
              as double?,
      cholesterol: freezed == cholesterol
          ? _value.cholesterol
          : cholesterol // ignore: cast_nullable_to_non_nullable
              as double?,
      fiber: freezed == fiber
          ? _value.fiber
          : fiber // ignore: cast_nullable_to_non_nullable
              as double?,
      protein: freezed == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double?,
      saturatedFat: freezed == saturatedFat
          ? _value.saturatedFat
          : saturatedFat // ignore: cast_nullable_to_non_nullable
              as double?,
      sodium: freezed == sodium
          ? _value.sodium
          : sodium // ignore: cast_nullable_to_non_nullable
              as double?,
      sugar: freezed == sugar
          ? _value.sugar
          : sugar // ignore: cast_nullable_to_non_nullable
              as double?,
      fat: freezed == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double?,
      unsaturatedFat: freezed == unsaturatedFat
          ? _value.unsaturatedFat
          : unsaturatedFat // ignore: cast_nullable_to_non_nullable
              as double?,
      nutritionRaw: null == nutritionRaw
          ? _value._nutritionRaw
          : nutritionRaw // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      recipeCategory: null == recipeCategory
          ? _value.recipeCategory
          : recipeCategory // ignore: cast_nullable_to_non_nullable
              as CategoriesEnum,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodImpl extends _Food {
  const _$FoodImpl(
      {@JsonKey(name: 'id') required this.recipeId,
      required this.name,
      @JsonKey(name: 'name_tr') required this.nameTr,
      this.ratingValue,
      this.ratingCount,
      this.prepTimeMinutes,
      this.cookTimeMinutes,
      final List<String> categories = const <String>[],
      final List<String> cuisines = const <String>[],
      final List<Ingredient> ingredients = const <Ingredient>[],
      @JsonKey(name: 'ingredients_tr')
      final List<Ingredient> ingredientsTr = const <Ingredient>[],
      final List<String> ingredientsRaw = const <String>[],
      @JsonKey(name: 'ingredients_raw_tr')
      final List<String> ingredientsRawTr = const <String>[],
      final List<String> instructions = const <String>[],
      @JsonKey(name: 'instructions_tr')
      final List<String> instructionsTr = const <String>[],
      final List<String> cookingMethods = const <String>[],
      @JsonKey(name: 'implements')
      final List<String> implementsList = const <String>[],
      this.numberOfSteps,
      this.servings,
      @JsonKey(name: 'servings_tr') this.servingsTr,
      this.calories,
      this.carbohydrates,
      this.cholesterol,
      this.fiber,
      this.protein,
      this.saturatedFat,
      this.sodium,
      this.sugar,
      this.fat,
      this.unsaturatedFat,
      @JsonKey(name: 'nutrition_raw')
      final Map<String, String> nutritionRaw = const <String, String>{},
      this.url,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.recipeCategory = CategoriesEnum.none})
      : _categories = categories,
        _cuisines = cuisines,
        _ingredients = ingredients,
        _ingredientsTr = ingredientsTr,
        _ingredientsRaw = ingredientsRaw,
        _ingredientsRawTr = ingredientsRawTr,
        _instructions = instructions,
        _instructionsTr = instructionsTr,
        _cookingMethods = cookingMethods,
        _implementsList = implementsList,
        _nutritionRaw = nutritionRaw,
        super._();

  factory _$FoodImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int recipeId;
  @override
  final String name;
  @override
  @JsonKey(name: 'name_tr')
  final String nameTr;
  @override
  final double? ratingValue;
  @override
  final int? ratingCount;
  @override
  final int? prepTimeMinutes;
  @override
  final int? cookTimeMinutes;
  final List<String> _categories;
  @override
  @JsonKey()
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<String> _cuisines;
  @override
  @JsonKey()
  List<String> get cuisines {
    if (_cuisines is EqualUnmodifiableListView) return _cuisines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cuisines);
  }

  final List<Ingredient> _ingredients;
  @override
  @JsonKey()
  List<Ingredient> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  final List<Ingredient> _ingredientsTr;
  @override
  @JsonKey(name: 'ingredients_tr')
  List<Ingredient> get ingredientsTr {
    if (_ingredientsTr is EqualUnmodifiableListView) return _ingredientsTr;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredientsTr);
  }

  final List<String> _ingredientsRaw;
  @override
  @JsonKey()
  List<String> get ingredientsRaw {
    if (_ingredientsRaw is EqualUnmodifiableListView) return _ingredientsRaw;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredientsRaw);
  }

  final List<String> _ingredientsRawTr;
  @override
  @JsonKey(name: 'ingredients_raw_tr')
  List<String> get ingredientsRawTr {
    if (_ingredientsRawTr is EqualUnmodifiableListView)
      return _ingredientsRawTr;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredientsRawTr);
  }

  final List<String> _instructions;
  @override
  @JsonKey()
  List<String> get instructions {
    if (_instructions is EqualUnmodifiableListView) return _instructions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_instructions);
  }

  final List<String> _instructionsTr;
  @override
  @JsonKey(name: 'instructions_tr')
  List<String> get instructionsTr {
    if (_instructionsTr is EqualUnmodifiableListView) return _instructionsTr;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_instructionsTr);
  }

  final List<String> _cookingMethods;
  @override
  @JsonKey()
  List<String> get cookingMethods {
    if (_cookingMethods is EqualUnmodifiableListView) return _cookingMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cookingMethods);
  }

  final List<String> _implementsList;
  @override
  @JsonKey(name: 'implements')
  List<String> get implementsList {
    if (_implementsList is EqualUnmodifiableListView) return _implementsList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_implementsList);
  }

  @override
  final int? numberOfSteps;
  @override
  final String? servings;
  @override
  @JsonKey(name: 'servings_tr')
  final String? servingsTr;
  @override
  final double? calories;
  @override
  final double? carbohydrates;
  @override
  final double? cholesterol;
  @override
  final double? fiber;
  @override
  final double? protein;
  @override
  final double? saturatedFat;
  @override
  final double? sodium;
  @override
  final double? sugar;
  @override
  final double? fat;
  @override
  final double? unsaturatedFat;
  final Map<String, String> _nutritionRaw;
  @override
  @JsonKey(name: 'nutrition_raw')
  Map<String, String> get nutritionRaw {
    if (_nutritionRaw is EqualUnmodifiableMapView) return _nutritionRaw;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionRaw);
  }

  @override
  final String? url;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final CategoriesEnum recipeCategory;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodImpl &&
            (identical(other.recipeId, recipeId) ||
                other.recipeId == recipeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameTr, nameTr) || other.nameTr == nameTr) &&
            (identical(other.ratingValue, ratingValue) ||
                other.ratingValue == ratingValue) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.prepTimeMinutes, prepTimeMinutes) ||
                other.prepTimeMinutes == prepTimeMinutes) &&
            (identical(other.cookTimeMinutes, cookTimeMinutes) ||
                other.cookTimeMinutes == cookTimeMinutes) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality().equals(other._cuisines, _cuisines) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            const DeepCollectionEquality()
                .equals(other._ingredientsTr, _ingredientsTr) &&
            const DeepCollectionEquality()
                .equals(other._ingredientsRaw, _ingredientsRaw) &&
            const DeepCollectionEquality()
                .equals(other._ingredientsRawTr, _ingredientsRawTr) &&
            const DeepCollectionEquality()
                .equals(other._instructions, _instructions) &&
            const DeepCollectionEquality()
                .equals(other._instructionsTr, _instructionsTr) &&
            const DeepCollectionEquality()
                .equals(other._cookingMethods, _cookingMethods) &&
            const DeepCollectionEquality()
                .equals(other._implementsList, _implementsList) &&
            (identical(other.numberOfSteps, numberOfSteps) ||
                other.numberOfSteps == numberOfSteps) &&
            (identical(other.servings, servings) ||
                other.servings == servings) &&
            (identical(other.servingsTr, servingsTr) ||
                other.servingsTr == servingsTr) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.carbohydrates, carbohydrates) ||
                other.carbohydrates == carbohydrates) &&
            (identical(other.cholesterol, cholesterol) ||
                other.cholesterol == cholesterol) &&
            (identical(other.fiber, fiber) || other.fiber == fiber) &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.saturatedFat, saturatedFat) ||
                other.saturatedFat == saturatedFat) &&
            (identical(other.sodium, sodium) || other.sodium == sodium) &&
            (identical(other.sugar, sugar) || other.sugar == sugar) &&
            (identical(other.fat, fat) || other.fat == fat) &&
            (identical(other.unsaturatedFat, unsaturatedFat) ||
                other.unsaturatedFat == unsaturatedFat) &&
            const DeepCollectionEquality()
                .equals(other._nutritionRaw, _nutritionRaw) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.recipeCategory, recipeCategory) ||
                other.recipeCategory == recipeCategory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        recipeId,
        name,
        nameTr,
        ratingValue,
        ratingCount,
        prepTimeMinutes,
        cookTimeMinutes,
        const DeepCollectionEquality().hash(_categories),
        const DeepCollectionEquality().hash(_cuisines),
        const DeepCollectionEquality().hash(_ingredients),
        const DeepCollectionEquality().hash(_ingredientsTr),
        const DeepCollectionEquality().hash(_ingredientsRaw),
        const DeepCollectionEquality().hash(_ingredientsRawTr),
        const DeepCollectionEquality().hash(_instructions),
        const DeepCollectionEquality().hash(_instructionsTr),
        const DeepCollectionEquality().hash(_cookingMethods),
        const DeepCollectionEquality().hash(_implementsList),
        numberOfSteps,
        servings,
        servingsTr,
        calories,
        carbohydrates,
        cholesterol,
        fiber,
        protein,
        saturatedFat,
        sodium,
        sugar,
        fat,
        unsaturatedFat,
        const DeepCollectionEquality().hash(_nutritionRaw),
        url,
        recipeCategory
      ]);

  /// Create a copy of Food
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodImplCopyWith<_$FoodImpl> get copyWith =>
      __$$FoodImplCopyWithImpl<_$FoodImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodImplToJson(
      this,
    );
  }
}

abstract class _Food extends Food {
  const factory _Food(
      {@JsonKey(name: 'id') required final int recipeId,
      required final String name,
      @JsonKey(name: 'name_tr') required final String nameTr,
      final double? ratingValue,
      final int? ratingCount,
      final int? prepTimeMinutes,
      final int? cookTimeMinutes,
      final List<String> categories,
      final List<String> cuisines,
      final List<Ingredient> ingredients,
      @JsonKey(name: 'ingredients_tr') final List<Ingredient> ingredientsTr,
      final List<String> ingredientsRaw,
      @JsonKey(name: 'ingredients_raw_tr') final List<String> ingredientsRawTr,
      final List<String> instructions,
      @JsonKey(name: 'instructions_tr') final List<String> instructionsTr,
      final List<String> cookingMethods,
      @JsonKey(name: 'implements') final List<String> implementsList,
      final int? numberOfSteps,
      final String? servings,
      @JsonKey(name: 'servings_tr') final String? servingsTr,
      final double? calories,
      final double? carbohydrates,
      final double? cholesterol,
      final double? fiber,
      final double? protein,
      final double? saturatedFat,
      final double? sodium,
      final double? sugar,
      final double? fat,
      final double? unsaturatedFat,
      @JsonKey(name: 'nutrition_raw') final Map<String, String> nutritionRaw,
      final String? url,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final CategoriesEnum recipeCategory}) = _$FoodImpl;
  const _Food._() : super._();

  factory _Food.fromJson(Map<String, dynamic> json) = _$FoodImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get recipeId;
  @override
  String get name;
  @override
  @JsonKey(name: 'name_tr')
  String get nameTr;
  @override
  double? get ratingValue;
  @override
  int? get ratingCount;
  @override
  int? get prepTimeMinutes;
  @override
  int? get cookTimeMinutes;
  @override
  List<String> get categories;
  @override
  List<String> get cuisines;
  @override
  List<Ingredient> get ingredients;
  @override
  @JsonKey(name: 'ingredients_tr')
  List<Ingredient> get ingredientsTr;
  @override
  List<String> get ingredientsRaw;
  @override
  @JsonKey(name: 'ingredients_raw_tr')
  List<String> get ingredientsRawTr;
  @override
  List<String> get instructions;
  @override
  @JsonKey(name: 'instructions_tr')
  List<String> get instructionsTr;
  @override
  List<String> get cookingMethods;
  @override
  @JsonKey(name: 'implements')
  List<String> get implementsList;
  @override
  int? get numberOfSteps;
  @override
  String? get servings;
  @override
  @JsonKey(name: 'servings_tr')
  String? get servingsTr;
  @override
  double? get calories;
  @override
  double? get carbohydrates;
  @override
  double? get cholesterol;
  @override
  double? get fiber;
  @override
  double? get protein;
  @override
  double? get saturatedFat;
  @override
  double? get sodium;
  @override
  double? get sugar;
  @override
  double? get fat;
  @override
  double? get unsaturatedFat;
  @override
  @JsonKey(name: 'nutrition_raw')
  Map<String, String> get nutritionRaw;
  @override
  String? get url;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  CategoriesEnum get recipeCategory;

  /// Create a copy of Food
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodImplCopyWith<_$FoodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
