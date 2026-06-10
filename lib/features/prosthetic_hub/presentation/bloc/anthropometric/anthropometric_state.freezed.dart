// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anthropometric_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnthropometricState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnthropometricState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnthropometricState()';
}


}

/// @nodoc
class $AnthropometricStateCopyWith<$Res>  {
$AnthropometricStateCopyWith(AnthropometricState _, $Res Function(AnthropometricState) __);
}


/// Adds pattern-matching-related methods to [AnthropometricState].
extension AnthropometricStatePatterns on AnthropometricState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AnthropometricInitial value)?  initial,TResult Function( AnthropometricLoading value)?  loading,TResult Function( AnthropometricLoaded value)?  loaded,TResult Function( AnthropometricSaved value)?  saved,TResult Function( AnthropometricError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AnthropometricInitial() when initial != null:
return initial(_that);case AnthropometricLoading() when loading != null:
return loading(_that);case AnthropometricLoaded() when loaded != null:
return loaded(_that);case AnthropometricSaved() when saved != null:
return saved(_that);case AnthropometricError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AnthropometricInitial value)  initial,required TResult Function( AnthropometricLoading value)  loading,required TResult Function( AnthropometricLoaded value)  loaded,required TResult Function( AnthropometricSaved value)  saved,required TResult Function( AnthropometricError value)  error,}){
final _that = this;
switch (_that) {
case AnthropometricInitial():
return initial(_that);case AnthropometricLoading():
return loading(_that);case AnthropometricLoaded():
return loaded(_that);case AnthropometricSaved():
return saved(_that);case AnthropometricError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AnthropometricInitial value)?  initial,TResult? Function( AnthropometricLoading value)?  loading,TResult? Function( AnthropometricLoaded value)?  loaded,TResult? Function( AnthropometricSaved value)?  saved,TResult? Function( AnthropometricError value)?  error,}){
final _that = this;
switch (_that) {
case AnthropometricInitial() when initial != null:
return initial(_that);case AnthropometricLoading() when loading != null:
return loading(_that);case AnthropometricLoaded() when loaded != null:
return loaded(_that);case AnthropometricSaved() when saved != null:
return saved(_that);case AnthropometricError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( AnthropometricEntity? measurements)?  loaded,TResult Function()?  saved,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AnthropometricInitial() when initial != null:
return initial();case AnthropometricLoading() when loading != null:
return loading();case AnthropometricLoaded() when loaded != null:
return loaded(_that.measurements);case AnthropometricSaved() when saved != null:
return saved();case AnthropometricError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( AnthropometricEntity? measurements)  loaded,required TResult Function()  saved,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case AnthropometricInitial():
return initial();case AnthropometricLoading():
return loading();case AnthropometricLoaded():
return loaded(_that.measurements);case AnthropometricSaved():
return saved();case AnthropometricError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( AnthropometricEntity? measurements)?  loaded,TResult? Function()?  saved,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case AnthropometricInitial() when initial != null:
return initial();case AnthropometricLoading() when loading != null:
return loading();case AnthropometricLoaded() when loaded != null:
return loaded(_that.measurements);case AnthropometricSaved() when saved != null:
return saved();case AnthropometricError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AnthropometricInitial implements AnthropometricState {
  const AnthropometricInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnthropometricInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnthropometricState.initial()';
}


}




/// @nodoc


class AnthropometricLoading implements AnthropometricState {
  const AnthropometricLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnthropometricLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnthropometricState.loading()';
}


}




/// @nodoc


class AnthropometricLoaded implements AnthropometricState {
  const AnthropometricLoaded(this.measurements);
  

 final  AnthropometricEntity? measurements;

/// Create a copy of AnthropometricState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnthropometricLoadedCopyWith<AnthropometricLoaded> get copyWith => _$AnthropometricLoadedCopyWithImpl<AnthropometricLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnthropometricLoaded&&(identical(other.measurements, measurements) || other.measurements == measurements));
}


@override
int get hashCode => Object.hash(runtimeType,measurements);

@override
String toString() {
  return 'AnthropometricState.loaded(measurements: $measurements)';
}


}

/// @nodoc
abstract mixin class $AnthropometricLoadedCopyWith<$Res> implements $AnthropometricStateCopyWith<$Res> {
  factory $AnthropometricLoadedCopyWith(AnthropometricLoaded value, $Res Function(AnthropometricLoaded) _then) = _$AnthropometricLoadedCopyWithImpl;
@useResult
$Res call({
 AnthropometricEntity? measurements
});




}
/// @nodoc
class _$AnthropometricLoadedCopyWithImpl<$Res>
    implements $AnthropometricLoadedCopyWith<$Res> {
  _$AnthropometricLoadedCopyWithImpl(this._self, this._then);

  final AnthropometricLoaded _self;
  final $Res Function(AnthropometricLoaded) _then;

/// Create a copy of AnthropometricState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? measurements = freezed,}) {
  return _then(AnthropometricLoaded(
freezed == measurements ? _self.measurements : measurements // ignore: cast_nullable_to_non_nullable
as AnthropometricEntity?,
  ));
}


}

/// @nodoc


class AnthropometricSaved implements AnthropometricState {
  const AnthropometricSaved();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnthropometricSaved);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnthropometricState.saved()';
}


}




/// @nodoc


class AnthropometricError implements AnthropometricState {
  const AnthropometricError(this.message);
  

 final  String message;

/// Create a copy of AnthropometricState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnthropometricErrorCopyWith<AnthropometricError> get copyWith => _$AnthropometricErrorCopyWithImpl<AnthropometricError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnthropometricError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AnthropometricState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $AnthropometricErrorCopyWith<$Res> implements $AnthropometricStateCopyWith<$Res> {
  factory $AnthropometricErrorCopyWith(AnthropometricError value, $Res Function(AnthropometricError) _then) = _$AnthropometricErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AnthropometricErrorCopyWithImpl<$Res>
    implements $AnthropometricErrorCopyWith<$Res> {
  _$AnthropometricErrorCopyWithImpl(this._self, this._then);

  final AnthropometricError _self;
  final $Res Function(AnthropometricError) _then;

/// Create a copy of AnthropometricState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AnthropometricError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
