// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_thread_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostThreadState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostThreadState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PostThreadState()';
}


}

/// @nodoc
class $PostThreadStateCopyWith<$Res>  {
$PostThreadStateCopyWith(PostThreadState _, $Res Function(PostThreadState) __);
}


/// Adds pattern-matching-related methods to [PostThreadState].
extension PostThreadStatePatterns on PostThreadState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PostThreadInitial value)?  initial,TResult Function( PostThreadLoading value)?  loading,TResult Function( PostThreadLoaded value)?  loaded,TResult Function( PostThreadError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PostThreadInitial() when initial != null:
return initial(_that);case PostThreadLoading() when loading != null:
return loading(_that);case PostThreadLoaded() when loaded != null:
return loaded(_that);case PostThreadError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PostThreadInitial value)  initial,required TResult Function( PostThreadLoading value)  loading,required TResult Function( PostThreadLoaded value)  loaded,required TResult Function( PostThreadError value)  error,}){
final _that = this;
switch (_that) {
case PostThreadInitial():
return initial(_that);case PostThreadLoading():
return loading(_that);case PostThreadLoaded():
return loaded(_that);case PostThreadError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PostThreadInitial value)?  initial,TResult? Function( PostThreadLoading value)?  loading,TResult? Function( PostThreadLoaded value)?  loaded,TResult? Function( PostThreadError value)?  error,}){
final _that = this;
switch (_that) {
case PostThreadInitial() when initial != null:
return initial(_that);case PostThreadLoading() when loading != null:
return loading(_that);case PostThreadLoaded() when loaded != null:
return loaded(_that);case PostThreadError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( PostEntity? seedPost)?  loading,TResult Function( PostEntity post,  List<PostReplyEntity> topLevel,  Map<String, List<PostReplyEntity>> nested)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PostThreadInitial() when initial != null:
return initial();case PostThreadLoading() when loading != null:
return loading(_that.seedPost);case PostThreadLoaded() when loaded != null:
return loaded(_that.post,_that.topLevel,_that.nested);case PostThreadError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( PostEntity? seedPost)  loading,required TResult Function( PostEntity post,  List<PostReplyEntity> topLevel,  Map<String, List<PostReplyEntity>> nested)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case PostThreadInitial():
return initial();case PostThreadLoading():
return loading(_that.seedPost);case PostThreadLoaded():
return loaded(_that.post,_that.topLevel,_that.nested);case PostThreadError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( PostEntity? seedPost)?  loading,TResult? Function( PostEntity post,  List<PostReplyEntity> topLevel,  Map<String, List<PostReplyEntity>> nested)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case PostThreadInitial() when initial != null:
return initial();case PostThreadLoading() when loading != null:
return loading(_that.seedPost);case PostThreadLoaded() when loaded != null:
return loaded(_that.post,_that.topLevel,_that.nested);case PostThreadError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class PostThreadInitial implements PostThreadState {
  const PostThreadInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostThreadInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PostThreadState.initial()';
}


}




/// @nodoc


class PostThreadLoading implements PostThreadState {
  const PostThreadLoading({this.seedPost});
  

 final  PostEntity? seedPost;

/// Create a copy of PostThreadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostThreadLoadingCopyWith<PostThreadLoading> get copyWith => _$PostThreadLoadingCopyWithImpl<PostThreadLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostThreadLoading&&(identical(other.seedPost, seedPost) || other.seedPost == seedPost));
}


@override
int get hashCode => Object.hash(runtimeType,seedPost);

@override
String toString() {
  return 'PostThreadState.loading(seedPost: $seedPost)';
}


}

/// @nodoc
abstract mixin class $PostThreadLoadingCopyWith<$Res> implements $PostThreadStateCopyWith<$Res> {
  factory $PostThreadLoadingCopyWith(PostThreadLoading value, $Res Function(PostThreadLoading) _then) = _$PostThreadLoadingCopyWithImpl;
@useResult
$Res call({
 PostEntity? seedPost
});




}
/// @nodoc
class _$PostThreadLoadingCopyWithImpl<$Res>
    implements $PostThreadLoadingCopyWith<$Res> {
  _$PostThreadLoadingCopyWithImpl(this._self, this._then);

  final PostThreadLoading _self;
  final $Res Function(PostThreadLoading) _then;

/// Create a copy of PostThreadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? seedPost = freezed,}) {
  return _then(PostThreadLoading(
seedPost: freezed == seedPost ? _self.seedPost : seedPost // ignore: cast_nullable_to_non_nullable
as PostEntity?,
  ));
}


}

/// @nodoc


class PostThreadLoaded implements PostThreadState {
  const PostThreadLoaded({required this.post, required final  List<PostReplyEntity> topLevel, required final  Map<String, List<PostReplyEntity>> nested}): _topLevel = topLevel,_nested = nested;
  

 final  PostEntity post;
 final  List<PostReplyEntity> _topLevel;
 List<PostReplyEntity> get topLevel {
  if (_topLevel is EqualUnmodifiableListView) return _topLevel;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topLevel);
}

 final  Map<String, List<PostReplyEntity>> _nested;
 Map<String, List<PostReplyEntity>> get nested {
  if (_nested is EqualUnmodifiableMapView) return _nested;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_nested);
}


/// Create a copy of PostThreadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostThreadLoadedCopyWith<PostThreadLoaded> get copyWith => _$PostThreadLoadedCopyWithImpl<PostThreadLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostThreadLoaded&&(identical(other.post, post) || other.post == post)&&const DeepCollectionEquality().equals(other._topLevel, _topLevel)&&const DeepCollectionEquality().equals(other._nested, _nested));
}


@override
int get hashCode => Object.hash(runtimeType,post,const DeepCollectionEquality().hash(_topLevel),const DeepCollectionEquality().hash(_nested));

@override
String toString() {
  return 'PostThreadState.loaded(post: $post, topLevel: $topLevel, nested: $nested)';
}


}

/// @nodoc
abstract mixin class $PostThreadLoadedCopyWith<$Res> implements $PostThreadStateCopyWith<$Res> {
  factory $PostThreadLoadedCopyWith(PostThreadLoaded value, $Res Function(PostThreadLoaded) _then) = _$PostThreadLoadedCopyWithImpl;
@useResult
$Res call({
 PostEntity post, List<PostReplyEntity> topLevel, Map<String, List<PostReplyEntity>> nested
});




}
/// @nodoc
class _$PostThreadLoadedCopyWithImpl<$Res>
    implements $PostThreadLoadedCopyWith<$Res> {
  _$PostThreadLoadedCopyWithImpl(this._self, this._then);

  final PostThreadLoaded _self;
  final $Res Function(PostThreadLoaded) _then;

/// Create a copy of PostThreadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? post = null,Object? topLevel = null,Object? nested = null,}) {
  return _then(PostThreadLoaded(
post: null == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as PostEntity,topLevel: null == topLevel ? _self._topLevel : topLevel // ignore: cast_nullable_to_non_nullable
as List<PostReplyEntity>,nested: null == nested ? _self._nested : nested // ignore: cast_nullable_to_non_nullable
as Map<String, List<PostReplyEntity>>,
  ));
}


}

/// @nodoc


class PostThreadError implements PostThreadState {
  const PostThreadError({required this.message});
  

 final  String message;

/// Create a copy of PostThreadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostThreadErrorCopyWith<PostThreadError> get copyWith => _$PostThreadErrorCopyWithImpl<PostThreadError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostThreadError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'PostThreadState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $PostThreadErrorCopyWith<$Res> implements $PostThreadStateCopyWith<$Res> {
  factory $PostThreadErrorCopyWith(PostThreadError value, $Res Function(PostThreadError) _then) = _$PostThreadErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PostThreadErrorCopyWithImpl<$Res>
    implements $PostThreadErrorCopyWith<$Res> {
  _$PostThreadErrorCopyWithImpl(this._self, this._then);

  final PostThreadError _self;
  final $Res Function(PostThreadError) _then;

/// Create a copy of PostThreadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PostThreadError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
