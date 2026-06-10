// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tutorials_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TutorialsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TutorialsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TutorialsState()';
}


}

/// @nodoc
class $TutorialsStateCopyWith<$Res>  {
$TutorialsStateCopyWith(TutorialsState _, $Res Function(TutorialsState) __);
}


/// Adds pattern-matching-related methods to [TutorialsState].
extension TutorialsStatePatterns on TutorialsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TutorialsInitial value)?  initial,TResult Function( TutorialsLoading value)?  loading,TResult Function( TutorialsLoaded value)?  loaded,TResult Function( TutorialsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TutorialsInitial() when initial != null:
return initial(_that);case TutorialsLoading() when loading != null:
return loading(_that);case TutorialsLoaded() when loaded != null:
return loaded(_that);case TutorialsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TutorialsInitial value)  initial,required TResult Function( TutorialsLoading value)  loading,required TResult Function( TutorialsLoaded value)  loaded,required TResult Function( TutorialsError value)  error,}){
final _that = this;
switch (_that) {
case TutorialsInitial():
return initial(_that);case TutorialsLoading():
return loading(_that);case TutorialsLoaded():
return loaded(_that);case TutorialsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TutorialsInitial value)?  initial,TResult? Function( TutorialsLoading value)?  loading,TResult? Function( TutorialsLoaded value)?  loaded,TResult? Function( TutorialsError value)?  error,}){
final _that = this;
switch (_that) {
case TutorialsInitial() when initial != null:
return initial(_that);case TutorialsLoading() when loading != null:
return loading(_that);case TutorialsLoaded() when loaded != null:
return loaded(_that);case TutorialsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<CareTutorialEntity> tutorials)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TutorialsInitial() when initial != null:
return initial();case TutorialsLoading() when loading != null:
return loading();case TutorialsLoaded() when loaded != null:
return loaded(_that.tutorials);case TutorialsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<CareTutorialEntity> tutorials)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case TutorialsInitial():
return initial();case TutorialsLoading():
return loading();case TutorialsLoaded():
return loaded(_that.tutorials);case TutorialsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<CareTutorialEntity> tutorials)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case TutorialsInitial() when initial != null:
return initial();case TutorialsLoading() when loading != null:
return loading();case TutorialsLoaded() when loaded != null:
return loaded(_that.tutorials);case TutorialsError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class TutorialsInitial implements TutorialsState {
  const TutorialsInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TutorialsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TutorialsState.initial()';
}


}




/// @nodoc


class TutorialsLoading implements TutorialsState {
  const TutorialsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TutorialsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TutorialsState.loading()';
}


}




/// @nodoc


class TutorialsLoaded implements TutorialsState {
  const TutorialsLoaded(final  List<CareTutorialEntity> tutorials): _tutorials = tutorials;
  

 final  List<CareTutorialEntity> _tutorials;
 List<CareTutorialEntity> get tutorials {
  if (_tutorials is EqualUnmodifiableListView) return _tutorials;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tutorials);
}


/// Create a copy of TutorialsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TutorialsLoadedCopyWith<TutorialsLoaded> get copyWith => _$TutorialsLoadedCopyWithImpl<TutorialsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TutorialsLoaded&&const DeepCollectionEquality().equals(other._tutorials, _tutorials));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tutorials));

@override
String toString() {
  return 'TutorialsState.loaded(tutorials: $tutorials)';
}


}

/// @nodoc
abstract mixin class $TutorialsLoadedCopyWith<$Res> implements $TutorialsStateCopyWith<$Res> {
  factory $TutorialsLoadedCopyWith(TutorialsLoaded value, $Res Function(TutorialsLoaded) _then) = _$TutorialsLoadedCopyWithImpl;
@useResult
$Res call({
 List<CareTutorialEntity> tutorials
});




}
/// @nodoc
class _$TutorialsLoadedCopyWithImpl<$Res>
    implements $TutorialsLoadedCopyWith<$Res> {
  _$TutorialsLoadedCopyWithImpl(this._self, this._then);

  final TutorialsLoaded _self;
  final $Res Function(TutorialsLoaded) _then;

/// Create a copy of TutorialsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tutorials = null,}) {
  return _then(TutorialsLoaded(
null == tutorials ? _self._tutorials : tutorials // ignore: cast_nullable_to_non_nullable
as List<CareTutorialEntity>,
  ));
}


}

/// @nodoc


class TutorialsError implements TutorialsState {
  const TutorialsError(this.message);
  

 final  String message;

/// Create a copy of TutorialsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TutorialsErrorCopyWith<TutorialsError> get copyWith => _$TutorialsErrorCopyWithImpl<TutorialsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TutorialsError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TutorialsState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $TutorialsErrorCopyWith<$Res> implements $TutorialsStateCopyWith<$Res> {
  factory $TutorialsErrorCopyWith(TutorialsError value, $Res Function(TutorialsError) _then) = _$TutorialsErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TutorialsErrorCopyWithImpl<$Res>
    implements $TutorialsErrorCopyWith<$Res> {
  _$TutorialsErrorCopyWithImpl(this._self, this._then);

  final TutorialsError _self;
  final $Res Function(TutorialsError) _then;

/// Create a copy of TutorialsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TutorialsError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
