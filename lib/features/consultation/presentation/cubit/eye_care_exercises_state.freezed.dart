// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'eye_care_exercises_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EyeCareExercisesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EyeCareExercisesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EyeCareExercisesState()';
}


}

/// @nodoc
class $EyeCareExercisesStateCopyWith<$Res>  {
$EyeCareExercisesStateCopyWith(EyeCareExercisesState _, $Res Function(EyeCareExercisesState) __);
}


/// Adds pattern-matching-related methods to [EyeCareExercisesState].
extension EyeCareExercisesStatePatterns on EyeCareExercisesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EyeCareExercisesInitial value)?  initial,TResult Function( EyeCareExercisesLoading value)?  loading,TResult Function( EyeCareExercisesLoaded value)?  loaded,TResult Function( EyeCareExercisesError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EyeCareExercisesInitial() when initial != null:
return initial(_that);case EyeCareExercisesLoading() when loading != null:
return loading(_that);case EyeCareExercisesLoaded() when loaded != null:
return loaded(_that);case EyeCareExercisesError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EyeCareExercisesInitial value)  initial,required TResult Function( EyeCareExercisesLoading value)  loading,required TResult Function( EyeCareExercisesLoaded value)  loaded,required TResult Function( EyeCareExercisesError value)  error,}){
final _that = this;
switch (_that) {
case EyeCareExercisesInitial():
return initial(_that);case EyeCareExercisesLoading():
return loading(_that);case EyeCareExercisesLoaded():
return loaded(_that);case EyeCareExercisesError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EyeCareExercisesInitial value)?  initial,TResult? Function( EyeCareExercisesLoading value)?  loading,TResult? Function( EyeCareExercisesLoaded value)?  loaded,TResult? Function( EyeCareExercisesError value)?  error,}){
final _that = this;
switch (_that) {
case EyeCareExercisesInitial() when initial != null:
return initial(_that);case EyeCareExercisesLoading() when loading != null:
return loading(_that);case EyeCareExercisesLoaded() when loaded != null:
return loaded(_that);case EyeCareExercisesError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<EyeCareExerciseEntity> exercises)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EyeCareExercisesInitial() when initial != null:
return initial();case EyeCareExercisesLoading() when loading != null:
return loading();case EyeCareExercisesLoaded() when loaded != null:
return loaded(_that.exercises);case EyeCareExercisesError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<EyeCareExerciseEntity> exercises)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case EyeCareExercisesInitial():
return initial();case EyeCareExercisesLoading():
return loading();case EyeCareExercisesLoaded():
return loaded(_that.exercises);case EyeCareExercisesError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<EyeCareExerciseEntity> exercises)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case EyeCareExercisesInitial() when initial != null:
return initial();case EyeCareExercisesLoading() when loading != null:
return loading();case EyeCareExercisesLoaded() when loaded != null:
return loaded(_that.exercises);case EyeCareExercisesError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class EyeCareExercisesInitial implements EyeCareExercisesState {
  const EyeCareExercisesInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EyeCareExercisesInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EyeCareExercisesState.initial()';
}


}




/// @nodoc


class EyeCareExercisesLoading implements EyeCareExercisesState {
  const EyeCareExercisesLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EyeCareExercisesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EyeCareExercisesState.loading()';
}


}




/// @nodoc


class EyeCareExercisesLoaded implements EyeCareExercisesState {
  const EyeCareExercisesLoaded({required final  List<EyeCareExerciseEntity> exercises}): _exercises = exercises;
  

 final  List<EyeCareExerciseEntity> _exercises;
 List<EyeCareExerciseEntity> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}


/// Create a copy of EyeCareExercisesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EyeCareExercisesLoadedCopyWith<EyeCareExercisesLoaded> get copyWith => _$EyeCareExercisesLoadedCopyWithImpl<EyeCareExercisesLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EyeCareExercisesLoaded&&const DeepCollectionEquality().equals(other._exercises, _exercises));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_exercises));

@override
String toString() {
  return 'EyeCareExercisesState.loaded(exercises: $exercises)';
}


}

/// @nodoc
abstract mixin class $EyeCareExercisesLoadedCopyWith<$Res> implements $EyeCareExercisesStateCopyWith<$Res> {
  factory $EyeCareExercisesLoadedCopyWith(EyeCareExercisesLoaded value, $Res Function(EyeCareExercisesLoaded) _then) = _$EyeCareExercisesLoadedCopyWithImpl;
@useResult
$Res call({
 List<EyeCareExerciseEntity> exercises
});




}
/// @nodoc
class _$EyeCareExercisesLoadedCopyWithImpl<$Res>
    implements $EyeCareExercisesLoadedCopyWith<$Res> {
  _$EyeCareExercisesLoadedCopyWithImpl(this._self, this._then);

  final EyeCareExercisesLoaded _self;
  final $Res Function(EyeCareExercisesLoaded) _then;

/// Create a copy of EyeCareExercisesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? exercises = null,}) {
  return _then(EyeCareExercisesLoaded(
exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<EyeCareExerciseEntity>,
  ));
}


}

/// @nodoc


class EyeCareExercisesError implements EyeCareExercisesState {
  const EyeCareExercisesError(this.message);
  

 final  String message;

/// Create a copy of EyeCareExercisesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EyeCareExercisesErrorCopyWith<EyeCareExercisesError> get copyWith => _$EyeCareExercisesErrorCopyWithImpl<EyeCareExercisesError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EyeCareExercisesError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'EyeCareExercisesState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $EyeCareExercisesErrorCopyWith<$Res> implements $EyeCareExercisesStateCopyWith<$Res> {
  factory $EyeCareExercisesErrorCopyWith(EyeCareExercisesError value, $Res Function(EyeCareExercisesError) _then) = _$EyeCareExercisesErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$EyeCareExercisesErrorCopyWithImpl<$Res>
    implements $EyeCareExercisesErrorCopyWith<$Res> {
  _$EyeCareExercisesErrorCopyWithImpl(this._self, this._then);

  final EyeCareExercisesError _self;
  final $Res Function(EyeCareExercisesError) _then;

/// Create a copy of EyeCareExercisesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(EyeCareExercisesError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
