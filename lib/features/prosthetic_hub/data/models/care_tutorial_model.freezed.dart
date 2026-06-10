// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_tutorial_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CareTutorialModel {

/// Primary key (UUID).
 String get id;/// Human-readable tutorial title.
 String get title;/// Care-task category — mirrors the `tutorial_category` Postgres enum.
@JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson) TutorialCategory get category;/// Supabase Storage path for the tutorial video (nullable).
@JsonKey(name: 'video_path') String? get videoPath;/// Supabase Storage path for the audio narration (nullable).
@JsonKey(name: 'audio_narration_path') String? get audioNarrationPath;/// Full text transcript — always present (WCAG equivalent alternative).
 String get transcript;/// Display order within a category (ascending).
@JsonKey(name: 'sort_order') int get sortOrder;
/// Create a copy of CareTutorialModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareTutorialModelCopyWith<CareTutorialModel> get copyWith => _$CareTutorialModelCopyWithImpl<CareTutorialModel>(this as CareTutorialModel, _$identity);

  /// Serializes this CareTutorialModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareTutorialModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.videoPath, videoPath) || other.videoPath == videoPath)&&(identical(other.audioNarrationPath, audioNarrationPath) || other.audioNarrationPath == audioNarrationPath)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,videoPath,audioNarrationPath,transcript,sortOrder);

@override
String toString() {
  return 'CareTutorialModel(id: $id, title: $title, category: $category, videoPath: $videoPath, audioNarrationPath: $audioNarrationPath, transcript: $transcript, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $CareTutorialModelCopyWith<$Res>  {
  factory $CareTutorialModelCopyWith(CareTutorialModel value, $Res Function(CareTutorialModel) _then) = _$CareTutorialModelCopyWithImpl;
@useResult
$Res call({
 String id, String title,@JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson) TutorialCategory category,@JsonKey(name: 'video_path') String? videoPath,@JsonKey(name: 'audio_narration_path') String? audioNarrationPath, String transcript,@JsonKey(name: 'sort_order') int sortOrder
});




}
/// @nodoc
class _$CareTutorialModelCopyWithImpl<$Res>
    implements $CareTutorialModelCopyWith<$Res> {
  _$CareTutorialModelCopyWithImpl(this._self, this._then);

  final CareTutorialModel _self;
  final $Res Function(CareTutorialModel) _then;

/// Create a copy of CareTutorialModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? category = null,Object? videoPath = freezed,Object? audioNarrationPath = freezed,Object? transcript = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TutorialCategory,videoPath: freezed == videoPath ? _self.videoPath : videoPath // ignore: cast_nullable_to_non_nullable
as String?,audioNarrationPath: freezed == audioNarrationPath ? _self.audioNarrationPath : audioNarrationPath // ignore: cast_nullable_to_non_nullable
as String?,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CareTutorialModel].
extension CareTutorialModelPatterns on CareTutorialModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareTutorialModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareTutorialModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareTutorialModel value)  $default,){
final _that = this;
switch (_that) {
case _CareTutorialModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareTutorialModel value)?  $default,){
final _that = this;
switch (_that) {
case _CareTutorialModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)  TutorialCategory category, @JsonKey(name: 'video_path')  String? videoPath, @JsonKey(name: 'audio_narration_path')  String? audioNarrationPath,  String transcript, @JsonKey(name: 'sort_order')  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareTutorialModel() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.videoPath,_that.audioNarrationPath,_that.transcript,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)  TutorialCategory category, @JsonKey(name: 'video_path')  String? videoPath, @JsonKey(name: 'audio_narration_path')  String? audioNarrationPath,  String transcript, @JsonKey(name: 'sort_order')  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _CareTutorialModel():
return $default(_that.id,_that.title,_that.category,_that.videoPath,_that.audioNarrationPath,_that.transcript,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title, @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)  TutorialCategory category, @JsonKey(name: 'video_path')  String? videoPath, @JsonKey(name: 'audio_narration_path')  String? audioNarrationPath,  String transcript, @JsonKey(name: 'sort_order')  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _CareTutorialModel() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.videoPath,_that.audioNarrationPath,_that.transcript,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CareTutorialModel implements CareTutorialModel {
  const _CareTutorialModel({required this.id, required this.title, @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson) required this.category, @JsonKey(name: 'video_path') this.videoPath, @JsonKey(name: 'audio_narration_path') this.audioNarrationPath, required this.transcript, @JsonKey(name: 'sort_order') this.sortOrder = 0});
  factory _CareTutorialModel.fromJson(Map<String, dynamic> json) => _$CareTutorialModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// Human-readable tutorial title.
@override final  String title;
/// Care-task category — mirrors the `tutorial_category` Postgres enum.
@override@JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson) final  TutorialCategory category;
/// Supabase Storage path for the tutorial video (nullable).
@override@JsonKey(name: 'video_path') final  String? videoPath;
/// Supabase Storage path for the audio narration (nullable).
@override@JsonKey(name: 'audio_narration_path') final  String? audioNarrationPath;
/// Full text transcript — always present (WCAG equivalent alternative).
@override final  String transcript;
/// Display order within a category (ascending).
@override@JsonKey(name: 'sort_order') final  int sortOrder;

/// Create a copy of CareTutorialModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareTutorialModelCopyWith<_CareTutorialModel> get copyWith => __$CareTutorialModelCopyWithImpl<_CareTutorialModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CareTutorialModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareTutorialModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.videoPath, videoPath) || other.videoPath == videoPath)&&(identical(other.audioNarrationPath, audioNarrationPath) || other.audioNarrationPath == audioNarrationPath)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,videoPath,audioNarrationPath,transcript,sortOrder);

@override
String toString() {
  return 'CareTutorialModel(id: $id, title: $title, category: $category, videoPath: $videoPath, audioNarrationPath: $audioNarrationPath, transcript: $transcript, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$CareTutorialModelCopyWith<$Res> implements $CareTutorialModelCopyWith<$Res> {
  factory _$CareTutorialModelCopyWith(_CareTutorialModel value, $Res Function(_CareTutorialModel) _then) = __$CareTutorialModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title,@JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson) TutorialCategory category,@JsonKey(name: 'video_path') String? videoPath,@JsonKey(name: 'audio_narration_path') String? audioNarrationPath, String transcript,@JsonKey(name: 'sort_order') int sortOrder
});




}
/// @nodoc
class __$CareTutorialModelCopyWithImpl<$Res>
    implements _$CareTutorialModelCopyWith<$Res> {
  __$CareTutorialModelCopyWithImpl(this._self, this._then);

  final _CareTutorialModel _self;
  final $Res Function(_CareTutorialModel) _then;

/// Create a copy of CareTutorialModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? category = null,Object? videoPath = freezed,Object? audioNarrationPath = freezed,Object? transcript = null,Object? sortOrder = null,}) {
  return _then(_CareTutorialModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TutorialCategory,videoPath: freezed == videoPath ? _self.videoPath : videoPath // ignore: cast_nullable_to_non_nullable
as String?,audioNarrationPath: freezed == audioNarrationPath ? _self.audioNarrationPath : audioNarrationPath // ignore: cast_nullable_to_non_nullable
as String?,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
