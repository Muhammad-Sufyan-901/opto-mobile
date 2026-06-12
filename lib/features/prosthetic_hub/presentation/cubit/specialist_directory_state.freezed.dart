// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'specialist_directory_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpecialistDirectoryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpecialistDirectoryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SpecialistDirectoryState()';
}


}

/// @nodoc
class $SpecialistDirectoryStateCopyWith<$Res>  {
$SpecialistDirectoryStateCopyWith(SpecialistDirectoryState _, $Res Function(SpecialistDirectoryState) __);
}


/// Adds pattern-matching-related methods to [SpecialistDirectoryState].
extension SpecialistDirectoryStatePatterns on SpecialistDirectoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SpecialistDirectoryInitial value)?  initial,TResult Function( SpecialistDirectoryLoading value)?  loading,TResult Function( SpecialistDirectoryLoaded value)?  loaded,TResult Function( SpecialistDirectoryError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SpecialistDirectoryInitial() when initial != null:
return initial(_that);case SpecialistDirectoryLoading() when loading != null:
return loading(_that);case SpecialistDirectoryLoaded() when loaded != null:
return loaded(_that);case SpecialistDirectoryError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SpecialistDirectoryInitial value)  initial,required TResult Function( SpecialistDirectoryLoading value)  loading,required TResult Function( SpecialistDirectoryLoaded value)  loaded,required TResult Function( SpecialistDirectoryError value)  error,}){
final _that = this;
switch (_that) {
case SpecialistDirectoryInitial():
return initial(_that);case SpecialistDirectoryLoading():
return loading(_that);case SpecialistDirectoryLoaded():
return loaded(_that);case SpecialistDirectoryError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SpecialistDirectoryInitial value)?  initial,TResult? Function( SpecialistDirectoryLoading value)?  loading,TResult? Function( SpecialistDirectoryLoaded value)?  loaded,TResult? Function( SpecialistDirectoryError value)?  error,}){
final _that = this;
switch (_that) {
case SpecialistDirectoryInitial() when initial != null:
return initial(_that);case SpecialistDirectoryLoading() when loading != null:
return loading(_that);case SpecialistDirectoryLoaded() when loaded != null:
return loaded(_that);case SpecialistDirectoryError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Specialist> recommended,  List<Specialist> all)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SpecialistDirectoryInitial() when initial != null:
return initial();case SpecialistDirectoryLoading() when loading != null:
return loading();case SpecialistDirectoryLoaded() when loaded != null:
return loaded(_that.recommended,_that.all);case SpecialistDirectoryError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Specialist> recommended,  List<Specialist> all)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case SpecialistDirectoryInitial():
return initial();case SpecialistDirectoryLoading():
return loading();case SpecialistDirectoryLoaded():
return loaded(_that.recommended,_that.all);case SpecialistDirectoryError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Specialist> recommended,  List<Specialist> all)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case SpecialistDirectoryInitial() when initial != null:
return initial();case SpecialistDirectoryLoading() when loading != null:
return loading();case SpecialistDirectoryLoaded() when loaded != null:
return loaded(_that.recommended,_that.all);case SpecialistDirectoryError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class SpecialistDirectoryInitial implements SpecialistDirectoryState {
  const SpecialistDirectoryInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpecialistDirectoryInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SpecialistDirectoryState.initial()';
}


}




/// @nodoc


class SpecialistDirectoryLoading implements SpecialistDirectoryState {
  const SpecialistDirectoryLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpecialistDirectoryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SpecialistDirectoryState.loading()';
}


}




/// @nodoc


class SpecialistDirectoryLoaded implements SpecialistDirectoryState {
  const SpecialistDirectoryLoaded({required final  List<Specialist> recommended, required final  List<Specialist> all}): _recommended = recommended,_all = all;
  

 final  List<Specialist> _recommended;
 List<Specialist> get recommended {
  if (_recommended is EqualUnmodifiableListView) return _recommended;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommended);
}

 final  List<Specialist> _all;
 List<Specialist> get all {
  if (_all is EqualUnmodifiableListView) return _all;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_all);
}


/// Create a copy of SpecialistDirectoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpecialistDirectoryLoadedCopyWith<SpecialistDirectoryLoaded> get copyWith => _$SpecialistDirectoryLoadedCopyWithImpl<SpecialistDirectoryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpecialistDirectoryLoaded&&const DeepCollectionEquality().equals(other._recommended, _recommended)&&const DeepCollectionEquality().equals(other._all, _all));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_recommended),const DeepCollectionEquality().hash(_all));

@override
String toString() {
  return 'SpecialistDirectoryState.loaded(recommended: $recommended, all: $all)';
}


}

/// @nodoc
abstract mixin class $SpecialistDirectoryLoadedCopyWith<$Res> implements $SpecialistDirectoryStateCopyWith<$Res> {
  factory $SpecialistDirectoryLoadedCopyWith(SpecialistDirectoryLoaded value, $Res Function(SpecialistDirectoryLoaded) _then) = _$SpecialistDirectoryLoadedCopyWithImpl;
@useResult
$Res call({
 List<Specialist> recommended, List<Specialist> all
});




}
/// @nodoc
class _$SpecialistDirectoryLoadedCopyWithImpl<$Res>
    implements $SpecialistDirectoryLoadedCopyWith<$Res> {
  _$SpecialistDirectoryLoadedCopyWithImpl(this._self, this._then);

  final SpecialistDirectoryLoaded _self;
  final $Res Function(SpecialistDirectoryLoaded) _then;

/// Create a copy of SpecialistDirectoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? recommended = null,Object? all = null,}) {
  return _then(SpecialistDirectoryLoaded(
recommended: null == recommended ? _self._recommended : recommended // ignore: cast_nullable_to_non_nullable
as List<Specialist>,all: null == all ? _self._all : all // ignore: cast_nullable_to_non_nullable
as List<Specialist>,
  ));
}


}

/// @nodoc


class SpecialistDirectoryError implements SpecialistDirectoryState {
  const SpecialistDirectoryError(this.message);
  

 final  String message;

/// Create a copy of SpecialistDirectoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpecialistDirectoryErrorCopyWith<SpecialistDirectoryError> get copyWith => _$SpecialistDirectoryErrorCopyWithImpl<SpecialistDirectoryError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpecialistDirectoryError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'SpecialistDirectoryState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $SpecialistDirectoryErrorCopyWith<$Res> implements $SpecialistDirectoryStateCopyWith<$Res> {
  factory $SpecialistDirectoryErrorCopyWith(SpecialistDirectoryError value, $Res Function(SpecialistDirectoryError) _then) = _$SpecialistDirectoryErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SpecialistDirectoryErrorCopyWithImpl<$Res>
    implements $SpecialistDirectoryErrorCopyWith<$Res> {
  _$SpecialistDirectoryErrorCopyWithImpl(this._self, this._then);

  final SpecialistDirectoryError _self;
  final $Res Function(SpecialistDirectoryError) _then;

/// Create a copy of SpecialistDirectoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SpecialistDirectoryError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
