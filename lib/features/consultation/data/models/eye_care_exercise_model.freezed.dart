// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'eye_care_exercise_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EyeCareExerciseModel {

/// Primary key (UUID).
 String get id;/// Human-readable exercise title (e.g. "Palming Relaxation").
 String get title;/// Storage path to the audio guidance file.
@JsonKey(name: 'audio_guide_path') String get audioGuidePath;/// Total duration of the exercise in seconds.
@JsonKey(name: 'duration_seconds') int get durationSeconds;/// Medical disclaimer text — MUST be displayed and read aloud before
/// exercise playback.
@JsonKey(name: 'medical_disclaimer') String get medicalDisclaimer;
/// Create a copy of EyeCareExerciseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EyeCareExerciseModelCopyWith<EyeCareExerciseModel> get copyWith => _$EyeCareExerciseModelCopyWithImpl<EyeCareExerciseModel>(this as EyeCareExerciseModel, _$identity);

  /// Serializes this EyeCareExerciseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EyeCareExerciseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.audioGuidePath, audioGuidePath) || other.audioGuidePath == audioGuidePath)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.medicalDisclaimer, medicalDisclaimer) || other.medicalDisclaimer == medicalDisclaimer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,audioGuidePath,durationSeconds,medicalDisclaimer);

@override
String toString() {
  return 'EyeCareExerciseModel(id: $id, title: $title, audioGuidePath: $audioGuidePath, durationSeconds: $durationSeconds, medicalDisclaimer: $medicalDisclaimer)';
}


}

/// @nodoc
abstract mixin class $EyeCareExerciseModelCopyWith<$Res>  {
  factory $EyeCareExerciseModelCopyWith(EyeCareExerciseModel value, $Res Function(EyeCareExerciseModel) _then) = _$EyeCareExerciseModelCopyWithImpl;
@useResult
$Res call({
 String id, String title,@JsonKey(name: 'audio_guide_path') String audioGuidePath,@JsonKey(name: 'duration_seconds') int durationSeconds,@JsonKey(name: 'medical_disclaimer') String medicalDisclaimer
});




}
/// @nodoc
class _$EyeCareExerciseModelCopyWithImpl<$Res>
    implements $EyeCareExerciseModelCopyWith<$Res> {
  _$EyeCareExerciseModelCopyWithImpl(this._self, this._then);

  final EyeCareExerciseModel _self;
  final $Res Function(EyeCareExerciseModel) _then;

/// Create a copy of EyeCareExerciseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? audioGuidePath = null,Object? durationSeconds = null,Object? medicalDisclaimer = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,audioGuidePath: null == audioGuidePath ? _self.audioGuidePath : audioGuidePath // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,medicalDisclaimer: null == medicalDisclaimer ? _self.medicalDisclaimer : medicalDisclaimer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EyeCareExerciseModel].
extension EyeCareExerciseModelPatterns on EyeCareExerciseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EyeCareExerciseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EyeCareExerciseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EyeCareExerciseModel value)  $default,){
final _that = this;
switch (_that) {
case _EyeCareExerciseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EyeCareExerciseModel value)?  $default,){
final _that = this;
switch (_that) {
case _EyeCareExerciseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'audio_guide_path')  String audioGuidePath, @JsonKey(name: 'duration_seconds')  int durationSeconds, @JsonKey(name: 'medical_disclaimer')  String medicalDisclaimer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EyeCareExerciseModel() when $default != null:
return $default(_that.id,_that.title,_that.audioGuidePath,_that.durationSeconds,_that.medicalDisclaimer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'audio_guide_path')  String audioGuidePath, @JsonKey(name: 'duration_seconds')  int durationSeconds, @JsonKey(name: 'medical_disclaimer')  String medicalDisclaimer)  $default,) {final _that = this;
switch (_that) {
case _EyeCareExerciseModel():
return $default(_that.id,_that.title,_that.audioGuidePath,_that.durationSeconds,_that.medicalDisclaimer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title, @JsonKey(name: 'audio_guide_path')  String audioGuidePath, @JsonKey(name: 'duration_seconds')  int durationSeconds, @JsonKey(name: 'medical_disclaimer')  String medicalDisclaimer)?  $default,) {final _that = this;
switch (_that) {
case _EyeCareExerciseModel() when $default != null:
return $default(_that.id,_that.title,_that.audioGuidePath,_that.durationSeconds,_that.medicalDisclaimer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EyeCareExerciseModel implements EyeCareExerciseModel {
  const _EyeCareExerciseModel({required this.id, required this.title, @JsonKey(name: 'audio_guide_path') required this.audioGuidePath, @JsonKey(name: 'duration_seconds') required this.durationSeconds, @JsonKey(name: 'medical_disclaimer') required this.medicalDisclaimer});
  factory _EyeCareExerciseModel.fromJson(Map<String, dynamic> json) => _$EyeCareExerciseModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// Human-readable exercise title (e.g. "Palming Relaxation").
@override final  String title;
/// Storage path to the audio guidance file.
@override@JsonKey(name: 'audio_guide_path') final  String audioGuidePath;
/// Total duration of the exercise in seconds.
@override@JsonKey(name: 'duration_seconds') final  int durationSeconds;
/// Medical disclaimer text — MUST be displayed and read aloud before
/// exercise playback.
@override@JsonKey(name: 'medical_disclaimer') final  String medicalDisclaimer;

/// Create a copy of EyeCareExerciseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EyeCareExerciseModelCopyWith<_EyeCareExerciseModel> get copyWith => __$EyeCareExerciseModelCopyWithImpl<_EyeCareExerciseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EyeCareExerciseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EyeCareExerciseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.audioGuidePath, audioGuidePath) || other.audioGuidePath == audioGuidePath)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.medicalDisclaimer, medicalDisclaimer) || other.medicalDisclaimer == medicalDisclaimer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,audioGuidePath,durationSeconds,medicalDisclaimer);

@override
String toString() {
  return 'EyeCareExerciseModel(id: $id, title: $title, audioGuidePath: $audioGuidePath, durationSeconds: $durationSeconds, medicalDisclaimer: $medicalDisclaimer)';
}


}

/// @nodoc
abstract mixin class _$EyeCareExerciseModelCopyWith<$Res> implements $EyeCareExerciseModelCopyWith<$Res> {
  factory _$EyeCareExerciseModelCopyWith(_EyeCareExerciseModel value, $Res Function(_EyeCareExerciseModel) _then) = __$EyeCareExerciseModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title,@JsonKey(name: 'audio_guide_path') String audioGuidePath,@JsonKey(name: 'duration_seconds') int durationSeconds,@JsonKey(name: 'medical_disclaimer') String medicalDisclaimer
});




}
/// @nodoc
class __$EyeCareExerciseModelCopyWithImpl<$Res>
    implements _$EyeCareExerciseModelCopyWith<$Res> {
  __$EyeCareExerciseModelCopyWithImpl(this._self, this._then);

  final _EyeCareExerciseModel _self;
  final $Res Function(_EyeCareExerciseModel) _then;

/// Create a copy of EyeCareExerciseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? audioGuidePath = null,Object? durationSeconds = null,Object? medicalDisclaimer = null,}) {
  return _then(_EyeCareExerciseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,audioGuidePath: null == audioGuidePath ? _self.audioGuidePath : audioGuidePath // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,medicalDisclaimer: null == medicalDisclaimer ? _self.medicalDisclaimer : medicalDisclaimer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
