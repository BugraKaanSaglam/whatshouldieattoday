// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OnboardingStep {
  String get titleKey => throw _privateConstructorUsedError;
  String get descriptionKey => throw _privateConstructorUsedError;
  IconData get icon => throw _privateConstructorUsedError;
  List<Color> get gradientColors => throw _privateConstructorUsedError;

  /// Create a copy of OnboardingStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingStepCopyWith<OnboardingStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingStepCopyWith<$Res> {
  factory $OnboardingStepCopyWith(
          OnboardingStep value, $Res Function(OnboardingStep) then) =
      _$OnboardingStepCopyWithImpl<$Res, OnboardingStep>;
  @useResult
  $Res call(
      {String titleKey,
      String descriptionKey,
      IconData icon,
      List<Color> gradientColors});
}

/// @nodoc
class _$OnboardingStepCopyWithImpl<$Res, $Val extends OnboardingStep>
    implements $OnboardingStepCopyWith<$Res> {
  _$OnboardingStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? titleKey = null,
    Object? descriptionKey = null,
    Object? icon = null,
    Object? gradientColors = null,
  }) {
    return _then(_value.copyWith(
      titleKey: null == titleKey
          ? _value.titleKey
          : titleKey // ignore: cast_nullable_to_non_nullable
              as String,
      descriptionKey: null == descriptionKey
          ? _value.descriptionKey
          : descriptionKey // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData,
      gradientColors: null == gradientColors
          ? _value.gradientColors
          : gradientColors // ignore: cast_nullable_to_non_nullable
              as List<Color>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnboardingStepImplCopyWith<$Res>
    implements $OnboardingStepCopyWith<$Res> {
  factory _$$OnboardingStepImplCopyWith(_$OnboardingStepImpl value,
          $Res Function(_$OnboardingStepImpl) then) =
      __$$OnboardingStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String titleKey,
      String descriptionKey,
      IconData icon,
      List<Color> gradientColors});
}

/// @nodoc
class __$$OnboardingStepImplCopyWithImpl<$Res>
    extends _$OnboardingStepCopyWithImpl<$Res, _$OnboardingStepImpl>
    implements _$$OnboardingStepImplCopyWith<$Res> {
  __$$OnboardingStepImplCopyWithImpl(
      _$OnboardingStepImpl _value, $Res Function(_$OnboardingStepImpl) _then)
      : super(_value, _then);

  /// Create a copy of OnboardingStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? titleKey = null,
    Object? descriptionKey = null,
    Object? icon = null,
    Object? gradientColors = null,
  }) {
    return _then(_$OnboardingStepImpl(
      titleKey: null == titleKey
          ? _value.titleKey
          : titleKey // ignore: cast_nullable_to_non_nullable
              as String,
      descriptionKey: null == descriptionKey
          ? _value.descriptionKey
          : descriptionKey // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData,
      gradientColors: null == gradientColors
          ? _value._gradientColors
          : gradientColors // ignore: cast_nullable_to_non_nullable
              as List<Color>,
    ));
  }
}

/// @nodoc

class _$OnboardingStepImpl implements _OnboardingStep {
  const _$OnboardingStepImpl(
      {required this.titleKey,
      required this.descriptionKey,
      required this.icon,
      required final List<Color> gradientColors})
      : _gradientColors = gradientColors;

  @override
  final String titleKey;
  @override
  final String descriptionKey;
  @override
  final IconData icon;
  final List<Color> _gradientColors;
  @override
  List<Color> get gradientColors {
    if (_gradientColors is EqualUnmodifiableListView) return _gradientColors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gradientColors);
  }

  @override
  String toString() {
    return 'OnboardingStep(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, gradientColors: $gradientColors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingStepImpl &&
            (identical(other.titleKey, titleKey) ||
                other.titleKey == titleKey) &&
            (identical(other.descriptionKey, descriptionKey) ||
                other.descriptionKey == descriptionKey) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            const DeepCollectionEquality()
                .equals(other._gradientColors, _gradientColors));
  }

  @override
  int get hashCode => Object.hash(runtimeType, titleKey, descriptionKey, icon,
      const DeepCollectionEquality().hash(_gradientColors));

  /// Create a copy of OnboardingStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingStepImplCopyWith<_$OnboardingStepImpl> get copyWith =>
      __$$OnboardingStepImplCopyWithImpl<_$OnboardingStepImpl>(
          this, _$identity);
}

abstract class _OnboardingStep implements OnboardingStep {
  const factory _OnboardingStep(
      {required final String titleKey,
      required final String descriptionKey,
      required final IconData icon,
      required final List<Color> gradientColors}) = _$OnboardingStepImpl;

  @override
  String get titleKey;
  @override
  String get descriptionKey;
  @override
  IconData get icon;
  @override
  List<Color> get gradientColors;

  /// Create a copy of OnboardingStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingStepImplCopyWith<_$OnboardingStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
