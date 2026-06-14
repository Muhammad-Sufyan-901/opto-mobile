// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CircleModel {

/// Primary key (UUID).
 String get id;/// URL-safe unique identifier for the circle (= posts.topic value).
 String get slug;/// Display name of the circle.
 String get name;/// Short one-line description shown in circle cards.
 String? get description;/// Longer markdown-capable body shown on the circle detail screen.
 String? get about;/// Icon identifier from the Opto icon catalog.
@JsonKey(name: 'icon_key') String? get iconKey;/// Color token key used to tint the circle card.
@JsonKey(name: 'color_key') String? get colorKey;/// Pinned moderator note displayed at the top of the circle feed.
@JsonKey(name: 'pinned_note') String? get pinnedNote;/// Row creation timestamp — set by Postgres default.
@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of CircleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircleModelCopyWith<CircleModel> get copyWith => _$CircleModelCopyWithImpl<CircleModel>(this as CircleModel, _$identity);

  /// Serializes this CircleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.about, about) || other.about == about)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.colorKey, colorKey) || other.colorKey == colorKey)&&(identical(other.pinnedNote, pinnedNote) || other.pinnedNote == pinnedNote)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,name,description,about,iconKey,colorKey,pinnedNote,createdAt);

@override
String toString() {
  return 'CircleModel(id: $id, slug: $slug, name: $name, description: $description, about: $about, iconKey: $iconKey, colorKey: $colorKey, pinnedNote: $pinnedNote, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CircleModelCopyWith<$Res>  {
  factory $CircleModelCopyWith(CircleModel value, $Res Function(CircleModel) _then) = _$CircleModelCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String name, String? description, String? about,@JsonKey(name: 'icon_key') String? iconKey,@JsonKey(name: 'color_key') String? colorKey,@JsonKey(name: 'pinned_note') String? pinnedNote,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$CircleModelCopyWithImpl<$Res>
    implements $CircleModelCopyWith<$Res> {
  _$CircleModelCopyWithImpl(this._self, this._then);

  final CircleModel _self;
  final $Res Function(CircleModel) _then;

/// Create a copy of CircleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? description = freezed,Object? about = freezed,Object? iconKey = freezed,Object? colorKey = freezed,Object? pinnedNote = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,about: freezed == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String?,iconKey: freezed == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String?,colorKey: freezed == colorKey ? _self.colorKey : colorKey // ignore: cast_nullable_to_non_nullable
as String?,pinnedNote: freezed == pinnedNote ? _self.pinnedNote : pinnedNote // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CircleModel].
extension CircleModelPatterns on CircleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircleModel value)  $default,){
final _that = this;
switch (_that) {
case _CircleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircleModel value)?  $default,){
final _that = this;
switch (_that) {
case _CircleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String? description,  String? about, @JsonKey(name: 'icon_key')  String? iconKey, @JsonKey(name: 'color_key')  String? colorKey, @JsonKey(name: 'pinned_note')  String? pinnedNote, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CircleModel() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.description,_that.about,_that.iconKey,_that.colorKey,_that.pinnedNote,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String? description,  String? about, @JsonKey(name: 'icon_key')  String? iconKey, @JsonKey(name: 'color_key')  String? colorKey, @JsonKey(name: 'pinned_note')  String? pinnedNote, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CircleModel():
return $default(_that.id,_that.slug,_that.name,_that.description,_that.about,_that.iconKey,_that.colorKey,_that.pinnedNote,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String name,  String? description,  String? about, @JsonKey(name: 'icon_key')  String? iconKey, @JsonKey(name: 'color_key')  String? colorKey, @JsonKey(name: 'pinned_note')  String? pinnedNote, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CircleModel() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.description,_that.about,_that.iconKey,_that.colorKey,_that.pinnedNote,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CircleModel implements CircleModel {
  const _CircleModel({required this.id, required this.slug, required this.name, this.description, this.about, @JsonKey(name: 'icon_key') this.iconKey, @JsonKey(name: 'color_key') this.colorKey, @JsonKey(name: 'pinned_note') this.pinnedNote, @JsonKey(name: 'created_at') required this.createdAt});
  factory _CircleModel.fromJson(Map<String, dynamic> json) => _$CircleModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// URL-safe unique identifier for the circle (= posts.topic value).
@override final  String slug;
/// Display name of the circle.
@override final  String name;
/// Short one-line description shown in circle cards.
@override final  String? description;
/// Longer markdown-capable body shown on the circle detail screen.
@override final  String? about;
/// Icon identifier from the Opto icon catalog.
@override@JsonKey(name: 'icon_key') final  String? iconKey;
/// Color token key used to tint the circle card.
@override@JsonKey(name: 'color_key') final  String? colorKey;
/// Pinned moderator note displayed at the top of the circle feed.
@override@JsonKey(name: 'pinned_note') final  String? pinnedNote;
/// Row creation timestamp — set by Postgres default.
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of CircleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircleModelCopyWith<_CircleModel> get copyWith => __$CircleModelCopyWithImpl<_CircleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CircleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.about, about) || other.about == about)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.colorKey, colorKey) || other.colorKey == colorKey)&&(identical(other.pinnedNote, pinnedNote) || other.pinnedNote == pinnedNote)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,name,description,about,iconKey,colorKey,pinnedNote,createdAt);

@override
String toString() {
  return 'CircleModel(id: $id, slug: $slug, name: $name, description: $description, about: $about, iconKey: $iconKey, colorKey: $colorKey, pinnedNote: $pinnedNote, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CircleModelCopyWith<$Res> implements $CircleModelCopyWith<$Res> {
  factory _$CircleModelCopyWith(_CircleModel value, $Res Function(_CircleModel) _then) = __$CircleModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String name, String? description, String? about,@JsonKey(name: 'icon_key') String? iconKey,@JsonKey(name: 'color_key') String? colorKey,@JsonKey(name: 'pinned_note') String? pinnedNote,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$CircleModelCopyWithImpl<$Res>
    implements _$CircleModelCopyWith<$Res> {
  __$CircleModelCopyWithImpl(this._self, this._then);

  final _CircleModel _self;
  final $Res Function(_CircleModel) _then;

/// Create a copy of CircleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? description = freezed,Object? about = freezed,Object? iconKey = freezed,Object? colorKey = freezed,Object? pinnedNote = freezed,Object? createdAt = null,}) {
  return _then(_CircleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,about: freezed == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String?,iconKey: freezed == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String?,colorKey: freezed == colorKey ? _self.colorKey : colorKey // ignore: cast_nullable_to_non_nullable
as String?,pinnedNote: freezed == pinnedNote ? _self.pinnedNote : pinnedNote // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
