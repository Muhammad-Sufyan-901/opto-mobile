// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consultation_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConsultationHistoryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsultationHistoryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConsultationHistoryState()';
}


}

/// @nodoc
class $ConsultationHistoryStateCopyWith<$Res>  {
$ConsultationHistoryStateCopyWith(ConsultationHistoryState _, $Res Function(ConsultationHistoryState) __);
}


/// Adds pattern-matching-related methods to [ConsultationHistoryState].
extension ConsultationHistoryStatePatterns on ConsultationHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ConsultationHistoryInitial value)?  initial,TResult Function( ConsultationHistoryLoading value)?  loading,TResult Function( ConsultationHistoryLoaded value)?  loaded,TResult Function( ConsultationHistoryError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ConsultationHistoryInitial() when initial != null:
return initial(_that);case ConsultationHistoryLoading() when loading != null:
return loading(_that);case ConsultationHistoryLoaded() when loaded != null:
return loaded(_that);case ConsultationHistoryError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ConsultationHistoryInitial value)  initial,required TResult Function( ConsultationHistoryLoading value)  loading,required TResult Function( ConsultationHistoryLoaded value)  loaded,required TResult Function( ConsultationHistoryError value)  error,}){
final _that = this;
switch (_that) {
case ConsultationHistoryInitial():
return initial(_that);case ConsultationHistoryLoading():
return loading(_that);case ConsultationHistoryLoaded():
return loaded(_that);case ConsultationHistoryError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ConsultationHistoryInitial value)?  initial,TResult? Function( ConsultationHistoryLoading value)?  loading,TResult? Function( ConsultationHistoryLoaded value)?  loaded,TResult? Function( ConsultationHistoryError value)?  error,}){
final _that = this;
switch (_that) {
case ConsultationHistoryInitial() when initial != null:
return initial(_that);case ConsultationHistoryLoading() when loading != null:
return loading(_that);case ConsultationHistoryLoaded() when loaded != null:
return loaded(_that);case ConsultationHistoryError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ConsultationEntity> consultations)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ConsultationHistoryInitial() when initial != null:
return initial();case ConsultationHistoryLoading() when loading != null:
return loading();case ConsultationHistoryLoaded() when loaded != null:
return loaded(_that.consultations);case ConsultationHistoryError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ConsultationEntity> consultations)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ConsultationHistoryInitial():
return initial();case ConsultationHistoryLoading():
return loading();case ConsultationHistoryLoaded():
return loaded(_that.consultations);case ConsultationHistoryError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ConsultationEntity> consultations)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ConsultationHistoryInitial() when initial != null:
return initial();case ConsultationHistoryLoading() when loading != null:
return loading();case ConsultationHistoryLoaded() when loaded != null:
return loaded(_that.consultations);case ConsultationHistoryError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ConsultationHistoryInitial implements ConsultationHistoryState {
  const ConsultationHistoryInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsultationHistoryInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConsultationHistoryState.initial()';
}


}




/// @nodoc


class ConsultationHistoryLoading implements ConsultationHistoryState {
  const ConsultationHistoryLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsultationHistoryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConsultationHistoryState.loading()';
}


}




/// @nodoc


class ConsultationHistoryLoaded implements ConsultationHistoryState {
  const ConsultationHistoryLoaded({required final  List<ConsultationEntity> consultations}): _consultations = consultations;
  

 final  List<ConsultationEntity> _consultations;
 List<ConsultationEntity> get consultations {
  if (_consultations is EqualUnmodifiableListView) return _consultations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_consultations);
}


/// Create a copy of ConsultationHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsultationHistoryLoadedCopyWith<ConsultationHistoryLoaded> get copyWith => _$ConsultationHistoryLoadedCopyWithImpl<ConsultationHistoryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsultationHistoryLoaded&&const DeepCollectionEquality().equals(other._consultations, _consultations));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_consultations));

@override
String toString() {
  return 'ConsultationHistoryState.loaded(consultations: $consultations)';
}


}

/// @nodoc
abstract mixin class $ConsultationHistoryLoadedCopyWith<$Res> implements $ConsultationHistoryStateCopyWith<$Res> {
  factory $ConsultationHistoryLoadedCopyWith(ConsultationHistoryLoaded value, $Res Function(ConsultationHistoryLoaded) _then) = _$ConsultationHistoryLoadedCopyWithImpl;
@useResult
$Res call({
 List<ConsultationEntity> consultations
});




}
/// @nodoc
class _$ConsultationHistoryLoadedCopyWithImpl<$Res>
    implements $ConsultationHistoryLoadedCopyWith<$Res> {
  _$ConsultationHistoryLoadedCopyWithImpl(this._self, this._then);

  final ConsultationHistoryLoaded _self;
  final $Res Function(ConsultationHistoryLoaded) _then;

/// Create a copy of ConsultationHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? consultations = null,}) {
  return _then(ConsultationHistoryLoaded(
consultations: null == consultations ? _self._consultations : consultations // ignore: cast_nullable_to_non_nullable
as List<ConsultationEntity>,
  ));
}


}

/// @nodoc


class ConsultationHistoryError implements ConsultationHistoryState {
  const ConsultationHistoryError(this.message);
  

 final  String message;

/// Create a copy of ConsultationHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsultationHistoryErrorCopyWith<ConsultationHistoryError> get copyWith => _$ConsultationHistoryErrorCopyWithImpl<ConsultationHistoryError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsultationHistoryError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ConsultationHistoryState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ConsultationHistoryErrorCopyWith<$Res> implements $ConsultationHistoryStateCopyWith<$Res> {
  factory $ConsultationHistoryErrorCopyWith(ConsultationHistoryError value, $Res Function(ConsultationHistoryError) _then) = _$ConsultationHistoryErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ConsultationHistoryErrorCopyWithImpl<$Res>
    implements $ConsultationHistoryErrorCopyWith<$Res> {
  _$ConsultationHistoryErrorCopyWithImpl(this._self, this._then);

  final ConsultationHistoryError _self;
  final $Res Function(ConsultationHistoryError) _then;

/// Create a copy of ConsultationHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ConsultationHistoryError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
