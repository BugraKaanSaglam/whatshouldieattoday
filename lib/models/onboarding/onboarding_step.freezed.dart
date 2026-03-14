// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingStep {

 String get titleKey; String get descriptionKey; IconData get icon; List<Color> get gradientColors;
/// Create a copy of OnboardingStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStepCopyWith<OnboardingStep> get copyWith => _$OnboardingStepCopyWithImpl<OnboardingStep>(this as OnboardingStep, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingStep&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other.gradientColors, gradientColors));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,const DeepCollectionEquality().hash(gradientColors));

@override
String toString() {
  return 'OnboardingStep(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, gradientColors: $gradientColors)';
}


}

/// @nodoc
abstract mixin class $OnboardingStepCopyWith<$Res>  {
  factory $OnboardingStepCopyWith(OnboardingStep value, $Res Function(OnboardingStep) _then) = _$OnboardingStepCopyWithImpl;
@useResult
$Res call({
 String titleKey, String descriptionKey, IconData icon, List<Color> gradientColors
});




}
/// @nodoc
class _$OnboardingStepCopyWithImpl<$Res>
    implements $OnboardingStepCopyWith<$Res> {
  _$OnboardingStepCopyWithImpl(this._self, this._then);

  final OnboardingStep _self;
  final $Res Function(OnboardingStep) _then;

/// Create a copy of OnboardingStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titleKey = null,Object? descriptionKey = null,Object? icon = null,Object? gradientColors = null,}) {
  return _then(_self.copyWith(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: null == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,gradientColors: null == gradientColors ? _self.gradientColors : gradientColors // ignore: cast_nullable_to_non_nullable
as List<Color>,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingStep].
extension OnboardingStepPatterns on OnboardingStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingStep value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingStep value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String titleKey,  String descriptionKey,  IconData icon,  List<Color> gradientColors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingStep() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.gradientColors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String titleKey,  String descriptionKey,  IconData icon,  List<Color> gradientColors)  $default,) {final _that = this;
switch (_that) {
case _OnboardingStep():
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.gradientColors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String titleKey,  String descriptionKey,  IconData icon,  List<Color> gradientColors)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingStep() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.gradientColors);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingStep implements OnboardingStep {
  const _OnboardingStep({required this.titleKey, required this.descriptionKey, required this.icon, required final  List<Color> gradientColors}): _gradientColors = gradientColors;
  

@override final  String titleKey;
@override final  String descriptionKey;
@override final  IconData icon;
 final  List<Color> _gradientColors;
@override List<Color> get gradientColors {
  if (_gradientColors is EqualUnmodifiableListView) return _gradientColors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gradientColors);
}


/// Create a copy of OnboardingStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStepCopyWith<_OnboardingStep> get copyWith => __$OnboardingStepCopyWithImpl<_OnboardingStep>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingStep&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other._gradientColors, _gradientColors));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,const DeepCollectionEquality().hash(_gradientColors));

@override
String toString() {
  return 'OnboardingStep(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, gradientColors: $gradientColors)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStepCopyWith<$Res> implements $OnboardingStepCopyWith<$Res> {
  factory _$OnboardingStepCopyWith(_OnboardingStep value, $Res Function(_OnboardingStep) _then) = __$OnboardingStepCopyWithImpl;
@override @useResult
$Res call({
 String titleKey, String descriptionKey, IconData icon, List<Color> gradientColors
});




}
/// @nodoc
class __$OnboardingStepCopyWithImpl<$Res>
    implements _$OnboardingStepCopyWith<$Res> {
  __$OnboardingStepCopyWithImpl(this._self, this._then);

  final _OnboardingStep _self;
  final $Res Function(_OnboardingStep) _then;

/// Create a copy of OnboardingStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titleKey = null,Object? descriptionKey = null,Object? icon = null,Object? gradientColors = null,}) {
  return _then(_OnboardingStep(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: null == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,gradientColors: null == gradientColors ? _self._gradientColors : gradientColors // ignore: cast_nullable_to_non_nullable
as List<Color>,
  ));
}


}

// dart format on
