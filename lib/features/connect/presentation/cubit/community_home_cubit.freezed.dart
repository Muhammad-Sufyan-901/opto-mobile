// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_home_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommunityHomeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityHomeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CommunityHomeState()';
}


}

/// @nodoc
class $CommunityHomeStateCopyWith<$Res>  {
$CommunityHomeStateCopyWith(CommunityHomeState _, $Res Function(CommunityHomeState) __);
}


/// Adds pattern-matching-related methods to [CommunityHomeState].
extension CommunityHomeStatePatterns on CommunityHomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CommunityHomeInitial value)?  initial,TResult Function( CommunityHomeLoading value)?  loading,TResult Function( CommunityHomeLoaded value)?  loaded,TResult Function( CommunityHomeError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CommunityHomeInitial() when initial != null:
return initial(_that);case CommunityHomeLoading() when loading != null:
return loading(_that);case CommunityHomeLoaded() when loaded != null:
return loaded(_that);case CommunityHomeError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CommunityHomeInitial value)  initial,required TResult Function( CommunityHomeLoading value)  loading,required TResult Function( CommunityHomeLoaded value)  loaded,required TResult Function( CommunityHomeError value)  error,}){
final _that = this;
switch (_that) {
case CommunityHomeInitial():
return initial(_that);case CommunityHomeLoading():
return loading(_that);case CommunityHomeLoaded():
return loaded(_that);case CommunityHomeError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CommunityHomeInitial value)?  initial,TResult? Function( CommunityHomeLoading value)?  loading,TResult? Function( CommunityHomeLoaded value)?  loaded,TResult? Function( CommunityHomeError value)?  error,}){
final _that = this;
switch (_that) {
case CommunityHomeInitial() when initial != null:
return initial(_that);case CommunityHomeLoading() when loading != null:
return loading(_that);case CommunityHomeLoaded() when loaded != null:
return loaded(_that);case CommunityHomeError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( PostEntity? featuredPost,  List<CircleEntity> circles,  List<PostEntity> trendingPosts)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CommunityHomeInitial() when initial != null:
return initial();case CommunityHomeLoading() when loading != null:
return loading();case CommunityHomeLoaded() when loaded != null:
return loaded(_that.featuredPost,_that.circles,_that.trendingPosts);case CommunityHomeError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( PostEntity? featuredPost,  List<CircleEntity> circles,  List<PostEntity> trendingPosts)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case CommunityHomeInitial():
return initial();case CommunityHomeLoading():
return loading();case CommunityHomeLoaded():
return loaded(_that.featuredPost,_that.circles,_that.trendingPosts);case CommunityHomeError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( PostEntity? featuredPost,  List<CircleEntity> circles,  List<PostEntity> trendingPosts)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case CommunityHomeInitial() when initial != null:
return initial();case CommunityHomeLoading() when loading != null:
return loading();case CommunityHomeLoaded() when loaded != null:
return loaded(_that.featuredPost,_that.circles,_that.trendingPosts);case CommunityHomeError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class CommunityHomeInitial implements CommunityHomeState {
  const CommunityHomeInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityHomeInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CommunityHomeState.initial()';
}


}




/// @nodoc


class CommunityHomeLoading implements CommunityHomeState {
  const CommunityHomeLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityHomeLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CommunityHomeState.loading()';
}


}




/// @nodoc


class CommunityHomeLoaded implements CommunityHomeState {
  const CommunityHomeLoaded({required this.featuredPost, required final  List<CircleEntity> circles, required final  List<PostEntity> trendingPosts}): _circles = circles,_trendingPosts = trendingPosts;
  

 final  PostEntity? featuredPost;
 final  List<CircleEntity> _circles;
 List<CircleEntity> get circles {
  if (_circles is EqualUnmodifiableListView) return _circles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_circles);
}

 final  List<PostEntity> _trendingPosts;
 List<PostEntity> get trendingPosts {
  if (_trendingPosts is EqualUnmodifiableListView) return _trendingPosts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trendingPosts);
}


/// Create a copy of CommunityHomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityHomeLoadedCopyWith<CommunityHomeLoaded> get copyWith => _$CommunityHomeLoadedCopyWithImpl<CommunityHomeLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityHomeLoaded&&(identical(other.featuredPost, featuredPost) || other.featuredPost == featuredPost)&&const DeepCollectionEquality().equals(other._circles, _circles)&&const DeepCollectionEquality().equals(other._trendingPosts, _trendingPosts));
}


@override
int get hashCode => Object.hash(runtimeType,featuredPost,const DeepCollectionEquality().hash(_circles),const DeepCollectionEquality().hash(_trendingPosts));

@override
String toString() {
  return 'CommunityHomeState.loaded(featuredPost: $featuredPost, circles: $circles, trendingPosts: $trendingPosts)';
}


}

/// @nodoc
abstract mixin class $CommunityHomeLoadedCopyWith<$Res> implements $CommunityHomeStateCopyWith<$Res> {
  factory $CommunityHomeLoadedCopyWith(CommunityHomeLoaded value, $Res Function(CommunityHomeLoaded) _then) = _$CommunityHomeLoadedCopyWithImpl;
@useResult
$Res call({
 PostEntity? featuredPost, List<CircleEntity> circles, List<PostEntity> trendingPosts
});




}
/// @nodoc
class _$CommunityHomeLoadedCopyWithImpl<$Res>
    implements $CommunityHomeLoadedCopyWith<$Res> {
  _$CommunityHomeLoadedCopyWithImpl(this._self, this._then);

  final CommunityHomeLoaded _self;
  final $Res Function(CommunityHomeLoaded) _then;

/// Create a copy of CommunityHomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? featuredPost = freezed,Object? circles = null,Object? trendingPosts = null,}) {
  return _then(CommunityHomeLoaded(
featuredPost: freezed == featuredPost ? _self.featuredPost : featuredPost // ignore: cast_nullable_to_non_nullable
as PostEntity?,circles: null == circles ? _self._circles : circles // ignore: cast_nullable_to_non_nullable
as List<CircleEntity>,trendingPosts: null == trendingPosts ? _self._trendingPosts : trendingPosts // ignore: cast_nullable_to_non_nullable
as List<PostEntity>,
  ));
}


}

/// @nodoc


class CommunityHomeError implements CommunityHomeState {
  const CommunityHomeError({required this.message});
  

 final  String message;

/// Create a copy of CommunityHomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityHomeErrorCopyWith<CommunityHomeError> get copyWith => _$CommunityHomeErrorCopyWithImpl<CommunityHomeError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityHomeError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'CommunityHomeState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $CommunityHomeErrorCopyWith<$Res> implements $CommunityHomeStateCopyWith<$Res> {
  factory $CommunityHomeErrorCopyWith(CommunityHomeError value, $Res Function(CommunityHomeError) _then) = _$CommunityHomeErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CommunityHomeErrorCopyWithImpl<$Res>
    implements $CommunityHomeErrorCopyWith<$Res> {
  _$CommunityHomeErrorCopyWithImpl(this._self, this._then);

  final CommunityHomeError _self;
  final $Res Function(CommunityHomeError) _then;

/// Create a copy of CommunityHomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CommunityHomeError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
