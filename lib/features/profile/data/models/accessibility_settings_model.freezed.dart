// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accessibility_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccessibilitySettingsModel {

/// Foreign key to `profiles.id` (UUID).
@JsonKey(name: 'user_id') String get userId;/// Active theme; defaults to [AppThemeMode.light] (canonical blue-on-white).
@_AppThemeModeConverter() AppThemeMode get theme;/// Text scale multiplier — 1.0 to 3.0; default 1.0.
@JsonKey(name: 'text_scale') double get textScale;/// Primary typeface; defaults to the Opto design system font.
@JsonKey(name: 'font_family') String get fontFamily;/// Haptic feedback intensity; defaults to [HapticLevel.full].
@JsonKey(name: 'haptic_intensity')@_HapticLevelConverter() HapticLevel get hapticIntensity;/// Whether Aura Voice is enabled; defaults to true.
@JsonKey(name: 'voice_enabled') bool get voiceEnabled;/// Whether the always-on hotword listener is active; defaults to false.
@JsonKey(name: 'hotword_enabled') bool get hotwordEnabled;/// Whether spoken guidance (TTS feedback) is enabled; defaults to true.
@JsonKey(name: 'spoken_guidance_enabled') bool get spokenGuidanceEnabled;/// TTS speaking rate multiplier — 0.0 (slowest) to 1.0 (fastest); default 0.45.
@JsonKey(name: 'speaking_rate') double get speakingRate;/// DB column `sound_effects_enabled` (not null, default true).
@JsonKey(name: 'sound_effects_enabled') bool get soundEffectsEnabled;/// Timestamp of the last settings update (nullable if never explicitly saved).
@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of AccessibilitySettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccessibilitySettingsModelCopyWith<AccessibilitySettingsModel> get copyWith => _$AccessibilitySettingsModelCopyWithImpl<AccessibilitySettingsModel>(this as AccessibilitySettingsModel, _$identity);

  /// Serializes this AccessibilitySettingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccessibilitySettingsModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.textScale, textScale) || other.textScale == textScale)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.hapticIntensity, hapticIntensity) || other.hapticIntensity == hapticIntensity)&&(identical(other.voiceEnabled, voiceEnabled) || other.voiceEnabled == voiceEnabled)&&(identical(other.hotwordEnabled, hotwordEnabled) || other.hotwordEnabled == hotwordEnabled)&&(identical(other.spokenGuidanceEnabled, spokenGuidanceEnabled) || other.spokenGuidanceEnabled == spokenGuidanceEnabled)&&(identical(other.speakingRate, speakingRate) || other.speakingRate == speakingRate)&&(identical(other.soundEffectsEnabled, soundEffectsEnabled) || other.soundEffectsEnabled == soundEffectsEnabled)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,theme,textScale,fontFamily,hapticIntensity,voiceEnabled,hotwordEnabled,spokenGuidanceEnabled,speakingRate,soundEffectsEnabled,updatedAt);

@override
String toString() {
  return 'AccessibilitySettingsModel(userId: $userId, theme: $theme, textScale: $textScale, fontFamily: $fontFamily, hapticIntensity: $hapticIntensity, voiceEnabled: $voiceEnabled, hotwordEnabled: $hotwordEnabled, spokenGuidanceEnabled: $spokenGuidanceEnabled, speakingRate: $speakingRate, soundEffectsEnabled: $soundEffectsEnabled, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AccessibilitySettingsModelCopyWith<$Res>  {
  factory $AccessibilitySettingsModelCopyWith(AccessibilitySettingsModel value, $Res Function(AccessibilitySettingsModel) _then) = _$AccessibilitySettingsModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@_AppThemeModeConverter() AppThemeMode theme,@JsonKey(name: 'text_scale') double textScale,@JsonKey(name: 'font_family') String fontFamily,@JsonKey(name: 'haptic_intensity')@_HapticLevelConverter() HapticLevel hapticIntensity,@JsonKey(name: 'voice_enabled') bool voiceEnabled,@JsonKey(name: 'hotword_enabled') bool hotwordEnabled,@JsonKey(name: 'spoken_guidance_enabled') bool spokenGuidanceEnabled,@JsonKey(name: 'speaking_rate') double speakingRate,@JsonKey(name: 'sound_effects_enabled') bool soundEffectsEnabled,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$AccessibilitySettingsModelCopyWithImpl<$Res>
    implements $AccessibilitySettingsModelCopyWith<$Res> {
  _$AccessibilitySettingsModelCopyWithImpl(this._self, this._then);

  final AccessibilitySettingsModel _self;
  final $Res Function(AccessibilitySettingsModel) _then;

/// Create a copy of AccessibilitySettingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? theme = null,Object? textScale = null,Object? fontFamily = null,Object? hapticIntensity = null,Object? voiceEnabled = null,Object? hotwordEnabled = null,Object? spokenGuidanceEnabled = null,Object? speakingRate = null,Object? soundEffectsEnabled = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as AppThemeMode,textScale: null == textScale ? _self.textScale : textScale // ignore: cast_nullable_to_non_nullable
as double,fontFamily: null == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String,hapticIntensity: null == hapticIntensity ? _self.hapticIntensity : hapticIntensity // ignore: cast_nullable_to_non_nullable
as HapticLevel,voiceEnabled: null == voiceEnabled ? _self.voiceEnabled : voiceEnabled // ignore: cast_nullable_to_non_nullable
as bool,hotwordEnabled: null == hotwordEnabled ? _self.hotwordEnabled : hotwordEnabled // ignore: cast_nullable_to_non_nullable
as bool,spokenGuidanceEnabled: null == spokenGuidanceEnabled ? _self.spokenGuidanceEnabled : spokenGuidanceEnabled // ignore: cast_nullable_to_non_nullable
as bool,speakingRate: null == speakingRate ? _self.speakingRate : speakingRate // ignore: cast_nullable_to_non_nullable
as double,soundEffectsEnabled: null == soundEffectsEnabled ? _self.soundEffectsEnabled : soundEffectsEnabled // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccessibilitySettingsModel].
extension AccessibilitySettingsModelPatterns on AccessibilitySettingsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccessibilitySettingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccessibilitySettingsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccessibilitySettingsModel value)  $default,){
final _that = this;
switch (_that) {
case _AccessibilitySettingsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccessibilitySettingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _AccessibilitySettingsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @_AppThemeModeConverter()  AppThemeMode theme, @JsonKey(name: 'text_scale')  double textScale, @JsonKey(name: 'font_family')  String fontFamily, @JsonKey(name: 'haptic_intensity')@_HapticLevelConverter()  HapticLevel hapticIntensity, @JsonKey(name: 'voice_enabled')  bool voiceEnabled, @JsonKey(name: 'hotword_enabled')  bool hotwordEnabled, @JsonKey(name: 'spoken_guidance_enabled')  bool spokenGuidanceEnabled, @JsonKey(name: 'speaking_rate')  double speakingRate, @JsonKey(name: 'sound_effects_enabled')  bool soundEffectsEnabled, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccessibilitySettingsModel() when $default != null:
return $default(_that.userId,_that.theme,_that.textScale,_that.fontFamily,_that.hapticIntensity,_that.voiceEnabled,_that.hotwordEnabled,_that.spokenGuidanceEnabled,_that.speakingRate,_that.soundEffectsEnabled,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @_AppThemeModeConverter()  AppThemeMode theme, @JsonKey(name: 'text_scale')  double textScale, @JsonKey(name: 'font_family')  String fontFamily, @JsonKey(name: 'haptic_intensity')@_HapticLevelConverter()  HapticLevel hapticIntensity, @JsonKey(name: 'voice_enabled')  bool voiceEnabled, @JsonKey(name: 'hotword_enabled')  bool hotwordEnabled, @JsonKey(name: 'spoken_guidance_enabled')  bool spokenGuidanceEnabled, @JsonKey(name: 'speaking_rate')  double speakingRate, @JsonKey(name: 'sound_effects_enabled')  bool soundEffectsEnabled, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AccessibilitySettingsModel():
return $default(_that.userId,_that.theme,_that.textScale,_that.fontFamily,_that.hapticIntensity,_that.voiceEnabled,_that.hotwordEnabled,_that.spokenGuidanceEnabled,_that.speakingRate,_that.soundEffectsEnabled,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId, @_AppThemeModeConverter()  AppThemeMode theme, @JsonKey(name: 'text_scale')  double textScale, @JsonKey(name: 'font_family')  String fontFamily, @JsonKey(name: 'haptic_intensity')@_HapticLevelConverter()  HapticLevel hapticIntensity, @JsonKey(name: 'voice_enabled')  bool voiceEnabled, @JsonKey(name: 'hotword_enabled')  bool hotwordEnabled, @JsonKey(name: 'spoken_guidance_enabled')  bool spokenGuidanceEnabled, @JsonKey(name: 'speaking_rate')  double speakingRate, @JsonKey(name: 'sound_effects_enabled')  bool soundEffectsEnabled, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AccessibilitySettingsModel() when $default != null:
return $default(_that.userId,_that.theme,_that.textScale,_that.fontFamily,_that.hapticIntensity,_that.voiceEnabled,_that.hotwordEnabled,_that.spokenGuidanceEnabled,_that.speakingRate,_that.soundEffectsEnabled,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccessibilitySettingsModel implements AccessibilitySettingsModel {
  const _AccessibilitySettingsModel({@JsonKey(name: 'user_id') required this.userId, @_AppThemeModeConverter() this.theme = AppThemeMode.light, @JsonKey(name: 'text_scale') this.textScale = 1.0, @JsonKey(name: 'font_family') this.fontFamily = 'AtkinsonHyperlegible', @JsonKey(name: 'haptic_intensity')@_HapticLevelConverter() this.hapticIntensity = HapticLevel.full, @JsonKey(name: 'voice_enabled') this.voiceEnabled = true, @JsonKey(name: 'hotword_enabled') this.hotwordEnabled = false, @JsonKey(name: 'spoken_guidance_enabled') this.spokenGuidanceEnabled = true, @JsonKey(name: 'speaking_rate') this.speakingRate = 0.45, @JsonKey(name: 'sound_effects_enabled') this.soundEffectsEnabled = true, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _AccessibilitySettingsModel.fromJson(Map<String, dynamic> json) => _$AccessibilitySettingsModelFromJson(json);

/// Foreign key to `profiles.id` (UUID).
@override@JsonKey(name: 'user_id') final  String userId;
/// Active theme; defaults to [AppThemeMode.light] (canonical blue-on-white).
@override@JsonKey()@_AppThemeModeConverter() final  AppThemeMode theme;
/// Text scale multiplier — 1.0 to 3.0; default 1.0.
@override@JsonKey(name: 'text_scale') final  double textScale;
/// Primary typeface; defaults to the Opto design system font.
@override@JsonKey(name: 'font_family') final  String fontFamily;
/// Haptic feedback intensity; defaults to [HapticLevel.full].
@override@JsonKey(name: 'haptic_intensity')@_HapticLevelConverter() final  HapticLevel hapticIntensity;
/// Whether Aura Voice is enabled; defaults to true.
@override@JsonKey(name: 'voice_enabled') final  bool voiceEnabled;
/// Whether the always-on hotword listener is active; defaults to false.
@override@JsonKey(name: 'hotword_enabled') final  bool hotwordEnabled;
/// Whether spoken guidance (TTS feedback) is enabled; defaults to true.
@override@JsonKey(name: 'spoken_guidance_enabled') final  bool spokenGuidanceEnabled;
/// TTS speaking rate multiplier — 0.0 (slowest) to 1.0 (fastest); default 0.45.
@override@JsonKey(name: 'speaking_rate') final  double speakingRate;
/// DB column `sound_effects_enabled` (not null, default true).
@override@JsonKey(name: 'sound_effects_enabled') final  bool soundEffectsEnabled;
/// Timestamp of the last settings update (nullable if never explicitly saved).
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of AccessibilitySettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccessibilitySettingsModelCopyWith<_AccessibilitySettingsModel> get copyWith => __$AccessibilitySettingsModelCopyWithImpl<_AccessibilitySettingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccessibilitySettingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccessibilitySettingsModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.textScale, textScale) || other.textScale == textScale)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.hapticIntensity, hapticIntensity) || other.hapticIntensity == hapticIntensity)&&(identical(other.voiceEnabled, voiceEnabled) || other.voiceEnabled == voiceEnabled)&&(identical(other.hotwordEnabled, hotwordEnabled) || other.hotwordEnabled == hotwordEnabled)&&(identical(other.spokenGuidanceEnabled, spokenGuidanceEnabled) || other.spokenGuidanceEnabled == spokenGuidanceEnabled)&&(identical(other.speakingRate, speakingRate) || other.speakingRate == speakingRate)&&(identical(other.soundEffectsEnabled, soundEffectsEnabled) || other.soundEffectsEnabled == soundEffectsEnabled)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,theme,textScale,fontFamily,hapticIntensity,voiceEnabled,hotwordEnabled,spokenGuidanceEnabled,speakingRate,soundEffectsEnabled,updatedAt);

@override
String toString() {
  return 'AccessibilitySettingsModel(userId: $userId, theme: $theme, textScale: $textScale, fontFamily: $fontFamily, hapticIntensity: $hapticIntensity, voiceEnabled: $voiceEnabled, hotwordEnabled: $hotwordEnabled, spokenGuidanceEnabled: $spokenGuidanceEnabled, speakingRate: $speakingRate, soundEffectsEnabled: $soundEffectsEnabled, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AccessibilitySettingsModelCopyWith<$Res> implements $AccessibilitySettingsModelCopyWith<$Res> {
  factory _$AccessibilitySettingsModelCopyWith(_AccessibilitySettingsModel value, $Res Function(_AccessibilitySettingsModel) _then) = __$AccessibilitySettingsModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@_AppThemeModeConverter() AppThemeMode theme,@JsonKey(name: 'text_scale') double textScale,@JsonKey(name: 'font_family') String fontFamily,@JsonKey(name: 'haptic_intensity')@_HapticLevelConverter() HapticLevel hapticIntensity,@JsonKey(name: 'voice_enabled') bool voiceEnabled,@JsonKey(name: 'hotword_enabled') bool hotwordEnabled,@JsonKey(name: 'spoken_guidance_enabled') bool spokenGuidanceEnabled,@JsonKey(name: 'speaking_rate') double speakingRate,@JsonKey(name: 'sound_effects_enabled') bool soundEffectsEnabled,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$AccessibilitySettingsModelCopyWithImpl<$Res>
    implements _$AccessibilitySettingsModelCopyWith<$Res> {
  __$AccessibilitySettingsModelCopyWithImpl(this._self, this._then);

  final _AccessibilitySettingsModel _self;
  final $Res Function(_AccessibilitySettingsModel) _then;

/// Create a copy of AccessibilitySettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? theme = null,Object? textScale = null,Object? fontFamily = null,Object? hapticIntensity = null,Object? voiceEnabled = null,Object? hotwordEnabled = null,Object? spokenGuidanceEnabled = null,Object? speakingRate = null,Object? soundEffectsEnabled = null,Object? updatedAt = freezed,}) {
  return _then(_AccessibilitySettingsModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as AppThemeMode,textScale: null == textScale ? _self.textScale : textScale // ignore: cast_nullable_to_non_nullable
as double,fontFamily: null == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String,hapticIntensity: null == hapticIntensity ? _self.hapticIntensity : hapticIntensity // ignore: cast_nullable_to_non_nullable
as HapticLevel,voiceEnabled: null == voiceEnabled ? _self.voiceEnabled : voiceEnabled // ignore: cast_nullable_to_non_nullable
as bool,hotwordEnabled: null == hotwordEnabled ? _self.hotwordEnabled : hotwordEnabled // ignore: cast_nullable_to_non_nullable
as bool,spokenGuidanceEnabled: null == spokenGuidanceEnabled ? _self.spokenGuidanceEnabled : spokenGuidanceEnabled // ignore: cast_nullable_to_non_nullable
as bool,speakingRate: null == speakingRate ? _self.speakingRate : speakingRate // ignore: cast_nullable_to_non_nullable
as double,soundEffectsEnabled: null == soundEffectsEnabled ? _self.soundEffectsEnabled : soundEffectsEnabled // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
