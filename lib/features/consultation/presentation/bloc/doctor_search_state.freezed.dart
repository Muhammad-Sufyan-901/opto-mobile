// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doctor_search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DoctorSearchState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorSearchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoctorSearchState()';
}


}

/// @nodoc
class $DoctorSearchStateCopyWith<$Res>  {
$DoctorSearchStateCopyWith(DoctorSearchState _, $Res Function(DoctorSearchState) __);
}


/// Adds pattern-matching-related methods to [DoctorSearchState].
extension DoctorSearchStatePatterns on DoctorSearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DoctorSearchInitial value)?  initial,TResult Function( DoctorSearchLoading value)?  loading,TResult Function( DoctorSearchLoaded value)?  loaded,TResult Function( DoctorSearchError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DoctorSearchInitial() when initial != null:
return initial(_that);case DoctorSearchLoading() when loading != null:
return loading(_that);case DoctorSearchLoaded() when loaded != null:
return loaded(_that);case DoctorSearchError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DoctorSearchInitial value)  initial,required TResult Function( DoctorSearchLoading value)  loading,required TResult Function( DoctorSearchLoaded value)  loaded,required TResult Function( DoctorSearchError value)  error,}){
final _that = this;
switch (_that) {
case DoctorSearchInitial():
return initial(_that);case DoctorSearchLoading():
return loading(_that);case DoctorSearchLoaded():
return loaded(_that);case DoctorSearchError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DoctorSearchInitial value)?  initial,TResult? Function( DoctorSearchLoading value)?  loading,TResult? Function( DoctorSearchLoaded value)?  loaded,TResult? Function( DoctorSearchError value)?  error,}){
final _that = this;
switch (_that) {
case DoctorSearchInitial() when initial != null:
return initial(_that);case DoctorSearchLoading() when loading != null:
return loading(_that);case DoctorSearchLoaded() when loaded != null:
return loaded(_that);case DoctorSearchError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<DoctorEntity> doctors,  bool hasMore,  List<DoctorAvailabilityEntity> availability,  String? activeQuery,  String? activeSpecialty)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DoctorSearchInitial() when initial != null:
return initial();case DoctorSearchLoading() when loading != null:
return loading();case DoctorSearchLoaded() when loaded != null:
return loaded(_that.doctors,_that.hasMore,_that.availability,_that.activeQuery,_that.activeSpecialty);case DoctorSearchError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<DoctorEntity> doctors,  bool hasMore,  List<DoctorAvailabilityEntity> availability,  String? activeQuery,  String? activeSpecialty)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case DoctorSearchInitial():
return initial();case DoctorSearchLoading():
return loading();case DoctorSearchLoaded():
return loaded(_that.doctors,_that.hasMore,_that.availability,_that.activeQuery,_that.activeSpecialty);case DoctorSearchError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<DoctorEntity> doctors,  bool hasMore,  List<DoctorAvailabilityEntity> availability,  String? activeQuery,  String? activeSpecialty)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case DoctorSearchInitial() when initial != null:
return initial();case DoctorSearchLoading() when loading != null:
return loading();case DoctorSearchLoaded() when loaded != null:
return loaded(_that.doctors,_that.hasMore,_that.availability,_that.activeQuery,_that.activeSpecialty);case DoctorSearchError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class DoctorSearchInitial implements DoctorSearchState {
  const DoctorSearchInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorSearchInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoctorSearchState.initial()';
}


}




/// @nodoc


class DoctorSearchLoading implements DoctorSearchState {
  const DoctorSearchLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorSearchLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoctorSearchState.loading()';
}


}




/// @nodoc


class DoctorSearchLoaded implements DoctorSearchState {
  const DoctorSearchLoaded({required final  List<DoctorEntity> doctors, required this.hasMore, final  List<DoctorAvailabilityEntity> availability = const [], this.activeQuery, this.activeSpecialty}): _doctors = doctors,_availability = availability;
  

 final  List<DoctorEntity> _doctors;
 List<DoctorEntity> get doctors {
  if (_doctors is EqualUnmodifiableListView) return _doctors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_doctors);
}

/// Whether more pages are available for pagination.
 final  bool hasMore;
/// Availability slots for the most-recently requested doctor.
 final  List<DoctorAvailabilityEntity> _availability;
/// Availability slots for the most-recently requested doctor.
@JsonKey() List<DoctorAvailabilityEntity> get availability {
  if (_availability is EqualUnmodifiableListView) return _availability;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availability);
}

/// Active free-text search query; null when no query is applied.
 final  String? activeQuery;
/// Active specialty filter; null when no filter is applied.
 final  String? activeSpecialty;

/// Create a copy of DoctorSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoctorSearchLoadedCopyWith<DoctorSearchLoaded> get copyWith => _$DoctorSearchLoadedCopyWithImpl<DoctorSearchLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorSearchLoaded&&const DeepCollectionEquality().equals(other._doctors, _doctors)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&const DeepCollectionEquality().equals(other._availability, _availability)&&(identical(other.activeQuery, activeQuery) || other.activeQuery == activeQuery)&&(identical(other.activeSpecialty, activeSpecialty) || other.activeSpecialty == activeSpecialty));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_doctors),hasMore,const DeepCollectionEquality().hash(_availability),activeQuery,activeSpecialty);

@override
String toString() {
  return 'DoctorSearchState.loaded(doctors: $doctors, hasMore: $hasMore, availability: $availability, activeQuery: $activeQuery, activeSpecialty: $activeSpecialty)';
}


}

/// @nodoc
abstract mixin class $DoctorSearchLoadedCopyWith<$Res> implements $DoctorSearchStateCopyWith<$Res> {
  factory $DoctorSearchLoadedCopyWith(DoctorSearchLoaded value, $Res Function(DoctorSearchLoaded) _then) = _$DoctorSearchLoadedCopyWithImpl;
@useResult
$Res call({
 List<DoctorEntity> doctors, bool hasMore, List<DoctorAvailabilityEntity> availability, String? activeQuery, String? activeSpecialty
});




}
/// @nodoc
class _$DoctorSearchLoadedCopyWithImpl<$Res>
    implements $DoctorSearchLoadedCopyWith<$Res> {
  _$DoctorSearchLoadedCopyWithImpl(this._self, this._then);

  final DoctorSearchLoaded _self;
  final $Res Function(DoctorSearchLoaded) _then;

/// Create a copy of DoctorSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? doctors = null,Object? hasMore = null,Object? availability = null,Object? activeQuery = freezed,Object? activeSpecialty = freezed,}) {
  return _then(DoctorSearchLoaded(
doctors: null == doctors ? _self._doctors : doctors // ignore: cast_nullable_to_non_nullable
as List<DoctorEntity>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,availability: null == availability ? _self._availability : availability // ignore: cast_nullable_to_non_nullable
as List<DoctorAvailabilityEntity>,activeQuery: freezed == activeQuery ? _self.activeQuery : activeQuery // ignore: cast_nullable_to_non_nullable
as String?,activeSpecialty: freezed == activeSpecialty ? _self.activeSpecialty : activeSpecialty // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class DoctorSearchError implements DoctorSearchState {
  const DoctorSearchError(this.message);
  

 final  String message;

/// Create a copy of DoctorSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoctorSearchErrorCopyWith<DoctorSearchError> get copyWith => _$DoctorSearchErrorCopyWithImpl<DoctorSearchError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorSearchError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DoctorSearchState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $DoctorSearchErrorCopyWith<$Res> implements $DoctorSearchStateCopyWith<$Res> {
  factory $DoctorSearchErrorCopyWith(DoctorSearchError value, $Res Function(DoctorSearchError) _then) = _$DoctorSearchErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$DoctorSearchErrorCopyWithImpl<$Res>
    implements $DoctorSearchErrorCopyWith<$Res> {
  _$DoctorSearchErrorCopyWithImpl(this._self, this._then);

  final DoctorSearchError _self;
  final $Res Function(DoctorSearchError) _then;

/// Create a copy of DoctorSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(DoctorSearchError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
