// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circle_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CircleDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CircleDetailState()';
}


}

/// @nodoc
class $CircleDetailStateCopyWith<$Res>  {
$CircleDetailStateCopyWith(CircleDetailState _, $Res Function(CircleDetailState) __);
}


/// Adds pattern-matching-related methods to [CircleDetailState].
extension CircleDetailStatePatterns on CircleDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CircleDetailInitial value)?  initial,TResult Function( CircleDetailLoading value)?  loading,TResult Function( CircleDetailLoaded value)?  loaded,TResult Function( CircleDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CircleDetailInitial() when initial != null:
return initial(_that);case CircleDetailLoading() when loading != null:
return loading(_that);case CircleDetailLoaded() when loaded != null:
return loaded(_that);case CircleDetailError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CircleDetailInitial value)  initial,required TResult Function( CircleDetailLoading value)  loading,required TResult Function( CircleDetailLoaded value)  loaded,required TResult Function( CircleDetailError value)  error,}){
final _that = this;
switch (_that) {
case CircleDetailInitial():
return initial(_that);case CircleDetailLoading():
return loading(_that);case CircleDetailLoaded():
return loaded(_that);case CircleDetailError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CircleDetailInitial value)?  initial,TResult? Function( CircleDetailLoading value)?  loading,TResult? Function( CircleDetailLoaded value)?  loaded,TResult? Function( CircleDetailError value)?  error,}){
final _that = this;
switch (_that) {
case CircleDetailInitial() when initial != null:
return initial(_that);case CircleDetailLoading() when loading != null:
return loading(_that);case CircleDetailLoaded() when loaded != null:
return loaded(_that);case CircleDetailError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( CircleEntity circle,  List<PostEntity> recentThreads)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CircleDetailInitial() when initial != null:
return initial();case CircleDetailLoading() when loading != null:
return loading();case CircleDetailLoaded() when loaded != null:
return loaded(_that.circle,_that.recentThreads);case CircleDetailError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( CircleEntity circle,  List<PostEntity> recentThreads)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case CircleDetailInitial():
return initial();case CircleDetailLoading():
return loading();case CircleDetailLoaded():
return loaded(_that.circle,_that.recentThreads);case CircleDetailError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( CircleEntity circle,  List<PostEntity> recentThreads)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case CircleDetailInitial() when initial != null:
return initial();case CircleDetailLoading() when loading != null:
return loading();case CircleDetailLoaded() when loaded != null:
return loaded(_that.circle,_that.recentThreads);case CircleDetailError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class CircleDetailInitial implements CircleDetailState {
  const CircleDetailInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CircleDetailState.initial()';
}


}




/// @nodoc


class CircleDetailLoading implements CircleDetailState {
  const CircleDetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CircleDetailState.loading()';
}


}




/// @nodoc


class CircleDetailLoaded implements CircleDetailState {
  const CircleDetailLoaded({required this.circle, required final  List<PostEntity> recentThreads}): _recentThreads = recentThreads;
  

 final  CircleEntity circle;
 final  List<PostEntity> _recentThreads;
 List<PostEntity> get recentThreads {
  if (_recentThreads is EqualUnmodifiableListView) return _recentThreads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentThreads);
}


/// Create a copy of CircleDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircleDetailLoadedCopyWith<CircleDetailLoaded> get copyWith => _$CircleDetailLoadedCopyWithImpl<CircleDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleDetailLoaded&&(identical(other.circle, circle) || other.circle == circle)&&const DeepCollectionEquality().equals(other._recentThreads, _recentThreads));
}


@override
int get hashCode => Object.hash(runtimeType,circle,const DeepCollectionEquality().hash(_recentThreads));

@override
String toString() {
  return 'CircleDetailState.loaded(circle: $circle, recentThreads: $recentThreads)';
}


}

/// @nodoc
abstract mixin class $CircleDetailLoadedCopyWith<$Res> implements $CircleDetailStateCopyWith<$Res> {
  factory $CircleDetailLoadedCopyWith(CircleDetailLoaded value, $Res Function(CircleDetailLoaded) _then) = _$CircleDetailLoadedCopyWithImpl;
@useResult
$Res call({
 CircleEntity circle, List<PostEntity> recentThreads
});




}
/// @nodoc
class _$CircleDetailLoadedCopyWithImpl<$Res>
    implements $CircleDetailLoadedCopyWith<$Res> {
  _$CircleDetailLoadedCopyWithImpl(this._self, this._then);

  final CircleDetailLoaded _self;
  final $Res Function(CircleDetailLoaded) _then;

/// Create a copy of CircleDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? circle = null,Object? recentThreads = null,}) {
  return _then(CircleDetailLoaded(
circle: null == circle ? _self.circle : circle // ignore: cast_nullable_to_non_nullable
as CircleEntity,recentThreads: null == recentThreads ? _self._recentThreads : recentThreads // ignore: cast_nullable_to_non_nullable
as List<PostEntity>,
  ));
}


}

/// @nodoc


class CircleDetailError implements CircleDetailState {
  const CircleDetailError({required this.message});
  

 final  String message;

/// Create a copy of CircleDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircleDetailErrorCopyWith<CircleDetailError> get copyWith => _$CircleDetailErrorCopyWithImpl<CircleDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'CircleDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $CircleDetailErrorCopyWith<$Res> implements $CircleDetailStateCopyWith<$Res> {
  factory $CircleDetailErrorCopyWith(CircleDetailError value, $Res Function(CircleDetailError) _then) = _$CircleDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CircleDetailErrorCopyWithImpl<$Res>
    implements $CircleDetailErrorCopyWith<$Res> {
  _$CircleDetailErrorCopyWithImpl(this._self, this._then);

  final CircleDetailError _self;
  final $Res Function(CircleDetailError) _then;

/// Create a copy of CircleDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CircleDetailError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
