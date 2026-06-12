// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_guides_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CareGuidesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareGuidesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CareGuidesState()';
}


}

/// @nodoc
class $CareGuidesStateCopyWith<$Res>  {
$CareGuidesStateCopyWith(CareGuidesState _, $Res Function(CareGuidesState) __);
}


/// Adds pattern-matching-related methods to [CareGuidesState].
extension CareGuidesStatePatterns on CareGuidesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CareGuidesInitial value)?  initial,TResult Function( CareGuidesLoading value)?  loading,TResult Function( CareGuidesLoaded value)?  loaded,TResult Function( CareGuidesError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CareGuidesInitial() when initial != null:
return initial(_that);case CareGuidesLoading() when loading != null:
return loading(_that);case CareGuidesLoaded() when loaded != null:
return loaded(_that);case CareGuidesError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CareGuidesInitial value)  initial,required TResult Function( CareGuidesLoading value)  loading,required TResult Function( CareGuidesLoaded value)  loaded,required TResult Function( CareGuidesError value)  error,}){
final _that = this;
switch (_that) {
case CareGuidesInitial():
return initial(_that);case CareGuidesLoading():
return loading(_that);case CareGuidesLoaded():
return loaded(_that);case CareGuidesError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CareGuidesInitial value)?  initial,TResult? Function( CareGuidesLoading value)?  loading,TResult? Function( CareGuidesLoaded value)?  loaded,TResult? Function( CareGuidesError value)?  error,}){
final _that = this;
switch (_that) {
case CareGuidesInitial() when initial != null:
return initial(_that);case CareGuidesLoading() when loading != null:
return loading(_that);case CareGuidesLoaded() when loaded != null:
return loaded(_that);case CareGuidesError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<CareGuide> guides)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CareGuidesInitial() when initial != null:
return initial();case CareGuidesLoading() when loading != null:
return loading();case CareGuidesLoaded() when loaded != null:
return loaded(_that.guides);case CareGuidesError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<CareGuide> guides)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case CareGuidesInitial():
return initial();case CareGuidesLoading():
return loading();case CareGuidesLoaded():
return loaded(_that.guides);case CareGuidesError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<CareGuide> guides)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case CareGuidesInitial() when initial != null:
return initial();case CareGuidesLoading() when loading != null:
return loading();case CareGuidesLoaded() when loaded != null:
return loaded(_that.guides);case CareGuidesError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class CareGuidesInitial implements CareGuidesState {
  const CareGuidesInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareGuidesInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CareGuidesState.initial()';
}


}




/// @nodoc


class CareGuidesLoading implements CareGuidesState {
  const CareGuidesLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareGuidesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CareGuidesState.loading()';
}


}




/// @nodoc


class CareGuidesLoaded implements CareGuidesState {
  const CareGuidesLoaded(final  List<CareGuide> guides): _guides = guides;
  

 final  List<CareGuide> _guides;
 List<CareGuide> get guides {
  if (_guides is EqualUnmodifiableListView) return _guides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_guides);
}


/// Create a copy of CareGuidesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareGuidesLoadedCopyWith<CareGuidesLoaded> get copyWith => _$CareGuidesLoadedCopyWithImpl<CareGuidesLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareGuidesLoaded&&const DeepCollectionEquality().equals(other._guides, _guides));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_guides));

@override
String toString() {
  return 'CareGuidesState.loaded(guides: $guides)';
}


}

/// @nodoc
abstract mixin class $CareGuidesLoadedCopyWith<$Res> implements $CareGuidesStateCopyWith<$Res> {
  factory $CareGuidesLoadedCopyWith(CareGuidesLoaded value, $Res Function(CareGuidesLoaded) _then) = _$CareGuidesLoadedCopyWithImpl;
@useResult
$Res call({
 List<CareGuide> guides
});




}
/// @nodoc
class _$CareGuidesLoadedCopyWithImpl<$Res>
    implements $CareGuidesLoadedCopyWith<$Res> {
  _$CareGuidesLoadedCopyWithImpl(this._self, this._then);

  final CareGuidesLoaded _self;
  final $Res Function(CareGuidesLoaded) _then;

/// Create a copy of CareGuidesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? guides = null,}) {
  return _then(CareGuidesLoaded(
null == guides ? _self._guides : guides // ignore: cast_nullable_to_non_nullable
as List<CareGuide>,
  ));
}


}

/// @nodoc


class CareGuidesError implements CareGuidesState {
  const CareGuidesError(this.message);
  

 final  String message;

/// Create a copy of CareGuidesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareGuidesErrorCopyWith<CareGuidesError> get copyWith => _$CareGuidesErrorCopyWithImpl<CareGuidesError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareGuidesError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'CareGuidesState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $CareGuidesErrorCopyWith<$Res> implements $CareGuidesStateCopyWith<$Res> {
  factory $CareGuidesErrorCopyWith(CareGuidesError value, $Res Function(CareGuidesError) _then) = _$CareGuidesErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CareGuidesErrorCopyWithImpl<$Res>
    implements $CareGuidesErrorCopyWith<$Res> {
  _$CareGuidesErrorCopyWithImpl(this._self, this._then);

  final CareGuidesError _self;
  final $Res Function(CareGuidesError) _then;

/// Create a copy of CareGuidesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CareGuidesError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
