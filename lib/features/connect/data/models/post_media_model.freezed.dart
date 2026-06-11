// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_media_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostMediaModel {

/// Primary key (UUID).
 String get id;/// FK → `posts.id`.
@JsonKey(name: 'post_id') String get postId;/// Supabase Storage path for the media asset.
@JsonKey(name: 'storage_path') String get storagePath;/// Non-empty alt-text for accessibility — required by both DB and app.
@JsonKey(name: 'alt_text') String get altText;
/// Create a copy of PostMediaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostMediaModelCopyWith<PostMediaModel> get copyWith => _$PostMediaModelCopyWithImpl<PostMediaModel>(this as PostMediaModel, _$identity);

  /// Serializes this PostMediaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostMediaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.altText, altText) || other.altText == altText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,storagePath,altText);

@override
String toString() {
  return 'PostMediaModel(id: $id, postId: $postId, storagePath: $storagePath, altText: $altText)';
}


}

/// @nodoc
abstract mixin class $PostMediaModelCopyWith<$Res>  {
  factory $PostMediaModelCopyWith(PostMediaModel value, $Res Function(PostMediaModel) _then) = _$PostMediaModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'post_id') String postId,@JsonKey(name: 'storage_path') String storagePath,@JsonKey(name: 'alt_text') String altText
});




}
/// @nodoc
class _$PostMediaModelCopyWithImpl<$Res>
    implements $PostMediaModelCopyWith<$Res> {
  _$PostMediaModelCopyWithImpl(this._self, this._then);

  final PostMediaModel _self;
  final $Res Function(PostMediaModel) _then;

/// Create a copy of PostMediaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? postId = null,Object? storagePath = null,Object? altText = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,altText: null == altText ? _self.altText : altText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PostMediaModel].
extension PostMediaModelPatterns on PostMediaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostMediaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostMediaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostMediaModel value)  $default,){
final _that = this;
switch (_that) {
case _PostMediaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostMediaModel value)?  $default,){
final _that = this;
switch (_that) {
case _PostMediaModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'post_id')  String postId, @JsonKey(name: 'storage_path')  String storagePath, @JsonKey(name: 'alt_text')  String altText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostMediaModel() when $default != null:
return $default(_that.id,_that.postId,_that.storagePath,_that.altText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'post_id')  String postId, @JsonKey(name: 'storage_path')  String storagePath, @JsonKey(name: 'alt_text')  String altText)  $default,) {final _that = this;
switch (_that) {
case _PostMediaModel():
return $default(_that.id,_that.postId,_that.storagePath,_that.altText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'post_id')  String postId, @JsonKey(name: 'storage_path')  String storagePath, @JsonKey(name: 'alt_text')  String altText)?  $default,) {final _that = this;
switch (_that) {
case _PostMediaModel() when $default != null:
return $default(_that.id,_that.postId,_that.storagePath,_that.altText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostMediaModel implements PostMediaModel {
  const _PostMediaModel({required this.id, @JsonKey(name: 'post_id') required this.postId, @JsonKey(name: 'storage_path') required this.storagePath, @JsonKey(name: 'alt_text') required this.altText});
  factory _PostMediaModel.fromJson(Map<String, dynamic> json) => _$PostMediaModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// FK → `posts.id`.
@override@JsonKey(name: 'post_id') final  String postId;
/// Supabase Storage path for the media asset.
@override@JsonKey(name: 'storage_path') final  String storagePath;
/// Non-empty alt-text for accessibility — required by both DB and app.
@override@JsonKey(name: 'alt_text') final  String altText;

/// Create a copy of PostMediaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostMediaModelCopyWith<_PostMediaModel> get copyWith => __$PostMediaModelCopyWithImpl<_PostMediaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostMediaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostMediaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.altText, altText) || other.altText == altText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,storagePath,altText);

@override
String toString() {
  return 'PostMediaModel(id: $id, postId: $postId, storagePath: $storagePath, altText: $altText)';
}


}

/// @nodoc
abstract mixin class _$PostMediaModelCopyWith<$Res> implements $PostMediaModelCopyWith<$Res> {
  factory _$PostMediaModelCopyWith(_PostMediaModel value, $Res Function(_PostMediaModel) _then) = __$PostMediaModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'post_id') String postId,@JsonKey(name: 'storage_path') String storagePath,@JsonKey(name: 'alt_text') String altText
});




}
/// @nodoc
class __$PostMediaModelCopyWithImpl<$Res>
    implements _$PostMediaModelCopyWith<$Res> {
  __$PostMediaModelCopyWithImpl(this._self, this._then);

  final _PostMediaModel _self;
  final $Res Function(_PostMediaModel) _then;

/// Create a copy of PostMediaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? postId = null,Object? storagePath = null,Object? altText = null,}) {
  return _then(_PostMediaModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,altText: null == altText ? _self.altText : altText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
