// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nearby_pois_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NearbyPoisState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearbyPoisState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NearbyPoisState()';
}


}

/// @nodoc
class $NearbyPoisStateCopyWith<$Res>  {
$NearbyPoisStateCopyWith(NearbyPoisState _, $Res Function(NearbyPoisState) __);
}


/// Adds pattern-matching-related methods to [NearbyPoisState].
extension NearbyPoisStatePatterns on NearbyPoisState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NearbyPoisInitial value)?  initial,TResult Function( NearbyPoisLoading value)?  loading,TResult Function( NearbyPoisLoaded value)?  loaded,TResult Function( NearbyPoisError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NearbyPoisInitial() when initial != null:
return initial(_that);case NearbyPoisLoading() when loading != null:
return loading(_that);case NearbyPoisLoaded() when loaded != null:
return loaded(_that);case NearbyPoisError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NearbyPoisInitial value)  initial,required TResult Function( NearbyPoisLoading value)  loading,required TResult Function( NearbyPoisLoaded value)  loaded,required TResult Function( NearbyPoisError value)  error,}){
final _that = this;
switch (_that) {
case NearbyPoisInitial():
return initial(_that);case NearbyPoisLoading():
return loading(_that);case NearbyPoisLoaded():
return loaded(_that);case NearbyPoisError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NearbyPoisInitial value)?  initial,TResult? Function( NearbyPoisLoading value)?  loading,TResult? Function( NearbyPoisLoaded value)?  loaded,TResult? Function( NearbyPoisError value)?  error,}){
final _that = this;
switch (_that) {
case NearbyPoisInitial() when initial != null:
return initial(_that);case NearbyPoisLoading() when loading != null:
return loading(_that);case NearbyPoisLoaded() when loaded != null:
return loaded(_that);case NearbyPoisError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<AccessibilityPoiEntity> pois,  bool locationAvailable)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NearbyPoisInitial() when initial != null:
return initial();case NearbyPoisLoading() when loading != null:
return loading();case NearbyPoisLoaded() when loaded != null:
return loaded(_that.pois,_that.locationAvailable);case NearbyPoisError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<AccessibilityPoiEntity> pois,  bool locationAvailable)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case NearbyPoisInitial():
return initial();case NearbyPoisLoading():
return loading();case NearbyPoisLoaded():
return loaded(_that.pois,_that.locationAvailable);case NearbyPoisError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<AccessibilityPoiEntity> pois,  bool locationAvailable)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case NearbyPoisInitial() when initial != null:
return initial();case NearbyPoisLoading() when loading != null:
return loading();case NearbyPoisLoaded() when loaded != null:
return loaded(_that.pois,_that.locationAvailable);case NearbyPoisError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class NearbyPoisInitial implements NearbyPoisState {
  const NearbyPoisInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearbyPoisInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NearbyPoisState.initial()';
}


}




/// @nodoc


class NearbyPoisLoading implements NearbyPoisState {
  const NearbyPoisLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearbyPoisLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NearbyPoisState.loading()';
}


}




/// @nodoc


class NearbyPoisLoaded implements NearbyPoisState {
  const NearbyPoisLoaded({required final  List<AccessibilityPoiEntity> pois, this.locationAvailable = false}): _pois = pois;
  

 final  List<AccessibilityPoiEntity> _pois;
 List<AccessibilityPoiEntity> get pois {
  if (_pois is EqualUnmodifiableListView) return _pois;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pois);
}

@JsonKey() final  bool locationAvailable;

/// Create a copy of NearbyPoisState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NearbyPoisLoadedCopyWith<NearbyPoisLoaded> get copyWith => _$NearbyPoisLoadedCopyWithImpl<NearbyPoisLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearbyPoisLoaded&&const DeepCollectionEquality().equals(other._pois, _pois)&&(identical(other.locationAvailable, locationAvailable) || other.locationAvailable == locationAvailable));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_pois),locationAvailable);

@override
String toString() {
  return 'NearbyPoisState.loaded(pois: $pois, locationAvailable: $locationAvailable)';
}


}

/// @nodoc
abstract mixin class $NearbyPoisLoadedCopyWith<$Res> implements $NearbyPoisStateCopyWith<$Res> {
  factory $NearbyPoisLoadedCopyWith(NearbyPoisLoaded value, $Res Function(NearbyPoisLoaded) _then) = _$NearbyPoisLoadedCopyWithImpl;
@useResult
$Res call({
 List<AccessibilityPoiEntity> pois, bool locationAvailable
});




}
/// @nodoc
class _$NearbyPoisLoadedCopyWithImpl<$Res>
    implements $NearbyPoisLoadedCopyWith<$Res> {
  _$NearbyPoisLoadedCopyWithImpl(this._self, this._then);

  final NearbyPoisLoaded _self;
  final $Res Function(NearbyPoisLoaded) _then;

/// Create a copy of NearbyPoisState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? pois = null,Object? locationAvailable = null,}) {
  return _then(NearbyPoisLoaded(
pois: null == pois ? _self._pois : pois // ignore: cast_nullable_to_non_nullable
as List<AccessibilityPoiEntity>,locationAvailable: null == locationAvailable ? _self.locationAvailable : locationAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class NearbyPoisError implements NearbyPoisState {
  const NearbyPoisError(this.message);
  

 final  String message;

/// Create a copy of NearbyPoisState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NearbyPoisErrorCopyWith<NearbyPoisError> get copyWith => _$NearbyPoisErrorCopyWithImpl<NearbyPoisError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearbyPoisError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'NearbyPoisState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $NearbyPoisErrorCopyWith<$Res> implements $NearbyPoisStateCopyWith<$Res> {
  factory $NearbyPoisErrorCopyWith(NearbyPoisError value, $Res Function(NearbyPoisError) _then) = _$NearbyPoisErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$NearbyPoisErrorCopyWithImpl<$Res>
    implements $NearbyPoisErrorCopyWith<$Res> {
  _$NearbyPoisErrorCopyWithImpl(this._self, this._then);

  final NearbyPoisError _self;
  final $Res Function(NearbyPoisError) _then;

/// Create a copy of NearbyPoisState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(NearbyPoisError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
