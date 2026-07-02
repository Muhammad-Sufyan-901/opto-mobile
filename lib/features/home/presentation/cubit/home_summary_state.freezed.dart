// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_summary_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeSummaryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeSummaryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeSummaryState()';
}


}

/// @nodoc
class $HomeSummaryStateCopyWith<$Res>  {
$HomeSummaryStateCopyWith(HomeSummaryState _, $Res Function(HomeSummaryState) __);
}


/// Adds pattern-matching-related methods to [HomeSummaryState].
extension HomeSummaryStatePatterns on HomeSummaryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HomeSummaryInitial value)?  initial,TResult Function( HomeSummaryLoading value)?  loading,TResult Function( HomeSummaryLoaded value)?  loaded,TResult Function( HomeSummaryError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HomeSummaryInitial() when initial != null:
return initial(_that);case HomeSummaryLoading() when loading != null:
return loading(_that);case HomeSummaryLoaded() when loaded != null:
return loaded(_that);case HomeSummaryError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HomeSummaryInitial value)  initial,required TResult Function( HomeSummaryLoading value)  loading,required TResult Function( HomeSummaryLoaded value)  loaded,required TResult Function( HomeSummaryError value)  error,}){
final _that = this;
switch (_that) {
case HomeSummaryInitial():
return initial(_that);case HomeSummaryLoading():
return loading(_that);case HomeSummaryLoaded():
return loaded(_that);case HomeSummaryError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HomeSummaryInitial value)?  initial,TResult? Function( HomeSummaryLoading value)?  loading,TResult? Function( HomeSummaryLoaded value)?  loaded,TResult? Function( HomeSummaryError value)?  error,}){
final _that = this;
switch (_that) {
case HomeSummaryInitial() when initial != null:
return initial(_that);case HomeSummaryLoading() when loading != null:
return loading(_that);case HomeSummaryLoaded() when loaded != null:
return loaded(_that);case HomeSummaryError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<HomeSummaryItem> upNext,  List<HomeSummaryItem> recentActivity)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HomeSummaryInitial() when initial != null:
return initial();case HomeSummaryLoading() when loading != null:
return loading();case HomeSummaryLoaded() when loaded != null:
return loaded(_that.upNext,_that.recentActivity);case HomeSummaryError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<HomeSummaryItem> upNext,  List<HomeSummaryItem> recentActivity)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case HomeSummaryInitial():
return initial();case HomeSummaryLoading():
return loading();case HomeSummaryLoaded():
return loaded(_that.upNext,_that.recentActivity);case HomeSummaryError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<HomeSummaryItem> upNext,  List<HomeSummaryItem> recentActivity)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case HomeSummaryInitial() when initial != null:
return initial();case HomeSummaryLoading() when loading != null:
return loading();case HomeSummaryLoaded() when loaded != null:
return loaded(_that.upNext,_that.recentActivity);case HomeSummaryError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class HomeSummaryInitial implements HomeSummaryState {
  const HomeSummaryInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeSummaryInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeSummaryState.initial()';
}


}




/// @nodoc


class HomeSummaryLoading implements HomeSummaryState {
  const HomeSummaryLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeSummaryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeSummaryState.loading()';
}


}




/// @nodoc


class HomeSummaryLoaded implements HomeSummaryState {
  const HomeSummaryLoaded({required final  List<HomeSummaryItem> upNext, required final  List<HomeSummaryItem> recentActivity}): _upNext = upNext,_recentActivity = recentActivity;
  

 final  List<HomeSummaryItem> _upNext;
 List<HomeSummaryItem> get upNext {
  if (_upNext is EqualUnmodifiableListView) return _upNext;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upNext);
}

 final  List<HomeSummaryItem> _recentActivity;
 List<HomeSummaryItem> get recentActivity {
  if (_recentActivity is EqualUnmodifiableListView) return _recentActivity;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentActivity);
}


/// Create a copy of HomeSummaryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeSummaryLoadedCopyWith<HomeSummaryLoaded> get copyWith => _$HomeSummaryLoadedCopyWithImpl<HomeSummaryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeSummaryLoaded&&const DeepCollectionEquality().equals(other._upNext, _upNext)&&const DeepCollectionEquality().equals(other._recentActivity, _recentActivity));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_upNext),const DeepCollectionEquality().hash(_recentActivity));

@override
String toString() {
  return 'HomeSummaryState.loaded(upNext: $upNext, recentActivity: $recentActivity)';
}


}

/// @nodoc
abstract mixin class $HomeSummaryLoadedCopyWith<$Res> implements $HomeSummaryStateCopyWith<$Res> {
  factory $HomeSummaryLoadedCopyWith(HomeSummaryLoaded value, $Res Function(HomeSummaryLoaded) _then) = _$HomeSummaryLoadedCopyWithImpl;
@useResult
$Res call({
 List<HomeSummaryItem> upNext, List<HomeSummaryItem> recentActivity
});




}
/// @nodoc
class _$HomeSummaryLoadedCopyWithImpl<$Res>
    implements $HomeSummaryLoadedCopyWith<$Res> {
  _$HomeSummaryLoadedCopyWithImpl(this._self, this._then);

  final HomeSummaryLoaded _self;
  final $Res Function(HomeSummaryLoaded) _then;

/// Create a copy of HomeSummaryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? upNext = null,Object? recentActivity = null,}) {
  return _then(HomeSummaryLoaded(
upNext: null == upNext ? _self._upNext : upNext // ignore: cast_nullable_to_non_nullable
as List<HomeSummaryItem>,recentActivity: null == recentActivity ? _self._recentActivity : recentActivity // ignore: cast_nullable_to_non_nullable
as List<HomeSummaryItem>,
  ));
}


}

/// @nodoc


class HomeSummaryError implements HomeSummaryState {
  const HomeSummaryError(this.message);
  

 final  String message;

/// Create a copy of HomeSummaryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeSummaryErrorCopyWith<HomeSummaryError> get copyWith => _$HomeSummaryErrorCopyWithImpl<HomeSummaryError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeSummaryError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'HomeSummaryState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $HomeSummaryErrorCopyWith<$Res> implements $HomeSummaryStateCopyWith<$Res> {
  factory $HomeSummaryErrorCopyWith(HomeSummaryError value, $Res Function(HomeSummaryError) _then) = _$HomeSummaryErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$HomeSummaryErrorCopyWithImpl<$Res>
    implements $HomeSummaryErrorCopyWith<$Res> {
  _$HomeSummaryErrorCopyWithImpl(this._self, this._then);

  final HomeSummaryError _self;
  final $Res Function(HomeSummaryError) _then;

/// Create a copy of HomeSummaryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(HomeSummaryError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
