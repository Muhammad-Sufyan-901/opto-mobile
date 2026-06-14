// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_reply_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostReplyModel {

/// Primary key (UUID).
 String get id;/// FK → `posts.id` — the post this reply belongs to.
@JsonKey(name: 'post_id') String get postId;/// FK → `profiles.id` — the reply author.
@JsonKey(name: 'author_id') String get authorId;/// Text body of the reply.
 String get body;/// Row creation timestamp — set by Postgres default.
@JsonKey(name: 'created_at') DateTime get createdAt;/// FK → `post_replies.id` — parent reply for one-level nesting; null for
/// top-level replies.
@JsonKey(name: 'parent_reply_id') String? get parentReplyId;/// Whether the OP author has marked this as the best answer.
@JsonKey(name: 'is_best_answer') bool get isBestAnswer;/// Optional voice-note recording URL.
@JsonKey(name: 'voice_url') String? get voiceUrl;
/// Create a copy of PostReplyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostReplyModelCopyWith<PostReplyModel> get copyWith => _$PostReplyModelCopyWithImpl<PostReplyModel>(this as PostReplyModel, _$identity);

  /// Serializes this PostReplyModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostReplyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.parentReplyId, parentReplyId) || other.parentReplyId == parentReplyId)&&(identical(other.isBestAnswer, isBestAnswer) || other.isBestAnswer == isBestAnswer)&&(identical(other.voiceUrl, voiceUrl) || other.voiceUrl == voiceUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,authorId,body,createdAt,parentReplyId,isBestAnswer,voiceUrl);

@override
String toString() {
  return 'PostReplyModel(id: $id, postId: $postId, authorId: $authorId, body: $body, createdAt: $createdAt, parentReplyId: $parentReplyId, isBestAnswer: $isBestAnswer, voiceUrl: $voiceUrl)';
}


}

/// @nodoc
abstract mixin class $PostReplyModelCopyWith<$Res>  {
  factory $PostReplyModelCopyWith(PostReplyModel value, $Res Function(PostReplyModel) _then) = _$PostReplyModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'post_id') String postId,@JsonKey(name: 'author_id') String authorId, String body,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'parent_reply_id') String? parentReplyId,@JsonKey(name: 'is_best_answer') bool isBestAnswer,@JsonKey(name: 'voice_url') String? voiceUrl
});




}
/// @nodoc
class _$PostReplyModelCopyWithImpl<$Res>
    implements $PostReplyModelCopyWith<$Res> {
  _$PostReplyModelCopyWithImpl(this._self, this._then);

  final PostReplyModel _self;
  final $Res Function(PostReplyModel) _then;

/// Create a copy of PostReplyModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? postId = null,Object? authorId = null,Object? body = null,Object? createdAt = null,Object? parentReplyId = freezed,Object? isBestAnswer = null,Object? voiceUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,parentReplyId: freezed == parentReplyId ? _self.parentReplyId : parentReplyId // ignore: cast_nullable_to_non_nullable
as String?,isBestAnswer: null == isBestAnswer ? _self.isBestAnswer : isBestAnswer // ignore: cast_nullable_to_non_nullable
as bool,voiceUrl: freezed == voiceUrl ? _self.voiceUrl : voiceUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PostReplyModel].
extension PostReplyModelPatterns on PostReplyModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostReplyModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostReplyModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostReplyModel value)  $default,){
final _that = this;
switch (_that) {
case _PostReplyModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostReplyModel value)?  $default,){
final _that = this;
switch (_that) {
case _PostReplyModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'post_id')  String postId, @JsonKey(name: 'author_id')  String authorId,  String body, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'parent_reply_id')  String? parentReplyId, @JsonKey(name: 'is_best_answer')  bool isBestAnswer, @JsonKey(name: 'voice_url')  String? voiceUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostReplyModel() when $default != null:
return $default(_that.id,_that.postId,_that.authorId,_that.body,_that.createdAt,_that.parentReplyId,_that.isBestAnswer,_that.voiceUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'post_id')  String postId, @JsonKey(name: 'author_id')  String authorId,  String body, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'parent_reply_id')  String? parentReplyId, @JsonKey(name: 'is_best_answer')  bool isBestAnswer, @JsonKey(name: 'voice_url')  String? voiceUrl)  $default,) {final _that = this;
switch (_that) {
case _PostReplyModel():
return $default(_that.id,_that.postId,_that.authorId,_that.body,_that.createdAt,_that.parentReplyId,_that.isBestAnswer,_that.voiceUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'post_id')  String postId, @JsonKey(name: 'author_id')  String authorId,  String body, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'parent_reply_id')  String? parentReplyId, @JsonKey(name: 'is_best_answer')  bool isBestAnswer, @JsonKey(name: 'voice_url')  String? voiceUrl)?  $default,) {final _that = this;
switch (_that) {
case _PostReplyModel() when $default != null:
return $default(_that.id,_that.postId,_that.authorId,_that.body,_that.createdAt,_that.parentReplyId,_that.isBestAnswer,_that.voiceUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostReplyModel implements PostReplyModel {
  const _PostReplyModel({required this.id, @JsonKey(name: 'post_id') required this.postId, @JsonKey(name: 'author_id') required this.authorId, required this.body, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'parent_reply_id') this.parentReplyId, @JsonKey(name: 'is_best_answer') this.isBestAnswer = false, @JsonKey(name: 'voice_url') this.voiceUrl});
  factory _PostReplyModel.fromJson(Map<String, dynamic> json) => _$PostReplyModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// FK → `posts.id` — the post this reply belongs to.
@override@JsonKey(name: 'post_id') final  String postId;
/// FK → `profiles.id` — the reply author.
@override@JsonKey(name: 'author_id') final  String authorId;
/// Text body of the reply.
@override final  String body;
/// Row creation timestamp — set by Postgres default.
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
/// FK → `post_replies.id` — parent reply for one-level nesting; null for
/// top-level replies.
@override@JsonKey(name: 'parent_reply_id') final  String? parentReplyId;
/// Whether the OP author has marked this as the best answer.
@override@JsonKey(name: 'is_best_answer') final  bool isBestAnswer;
/// Optional voice-note recording URL.
@override@JsonKey(name: 'voice_url') final  String? voiceUrl;

/// Create a copy of PostReplyModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostReplyModelCopyWith<_PostReplyModel> get copyWith => __$PostReplyModelCopyWithImpl<_PostReplyModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostReplyModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostReplyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.parentReplyId, parentReplyId) || other.parentReplyId == parentReplyId)&&(identical(other.isBestAnswer, isBestAnswer) || other.isBestAnswer == isBestAnswer)&&(identical(other.voiceUrl, voiceUrl) || other.voiceUrl == voiceUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,authorId,body,createdAt,parentReplyId,isBestAnswer,voiceUrl);

@override
String toString() {
  return 'PostReplyModel(id: $id, postId: $postId, authorId: $authorId, body: $body, createdAt: $createdAt, parentReplyId: $parentReplyId, isBestAnswer: $isBestAnswer, voiceUrl: $voiceUrl)';
}


}

/// @nodoc
abstract mixin class _$PostReplyModelCopyWith<$Res> implements $PostReplyModelCopyWith<$Res> {
  factory _$PostReplyModelCopyWith(_PostReplyModel value, $Res Function(_PostReplyModel) _then) = __$PostReplyModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'post_id') String postId,@JsonKey(name: 'author_id') String authorId, String body,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'parent_reply_id') String? parentReplyId,@JsonKey(name: 'is_best_answer') bool isBestAnswer,@JsonKey(name: 'voice_url') String? voiceUrl
});




}
/// @nodoc
class __$PostReplyModelCopyWithImpl<$Res>
    implements _$PostReplyModelCopyWith<$Res> {
  __$PostReplyModelCopyWithImpl(this._self, this._then);

  final _PostReplyModel _self;
  final $Res Function(_PostReplyModel) _then;

/// Create a copy of PostReplyModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? postId = null,Object? authorId = null,Object? body = null,Object? createdAt = null,Object? parentReplyId = freezed,Object? isBestAnswer = null,Object? voiceUrl = freezed,}) {
  return _then(_PostReplyModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,parentReplyId: freezed == parentReplyId ? _self.parentReplyId : parentReplyId // ignore: cast_nullable_to_non_nullable
as String?,isBestAnswer: null == isBestAnswer ? _self.isBestAnswer : isBestAnswer // ignore: cast_nullable_to_non_nullable
as bool,voiceUrl: freezed == voiceUrl ? _self.voiceUrl : voiceUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
