// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doctor_search_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DoctorSearchEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorSearchEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoctorSearchEvent()';
}


}

/// @nodoc
class $DoctorSearchEventCopyWith<$Res>  {
$DoctorSearchEventCopyWith(DoctorSearchEvent _, $Res Function(DoctorSearchEvent) __);
}


/// Adds pattern-matching-related methods to [DoctorSearchEvent].
extension DoctorSearchEventPatterns on DoctorSearchEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadDoctors value)?  loadDoctors,TResult Function( SearchDoctors value)?  searchDoctors,TResult Function( FilterBySpecialty value)?  filterBySpecialty,TResult Function( LoadAvailability value)?  loadAvailability,TResult Function( LoadNextPage value)?  loadNextPage,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadDoctors() when loadDoctors != null:
return loadDoctors(_that);case SearchDoctors() when searchDoctors != null:
return searchDoctors(_that);case FilterBySpecialty() when filterBySpecialty != null:
return filterBySpecialty(_that);case LoadAvailability() when loadAvailability != null:
return loadAvailability(_that);case LoadNextPage() when loadNextPage != null:
return loadNextPage(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadDoctors value)  loadDoctors,required TResult Function( SearchDoctors value)  searchDoctors,required TResult Function( FilterBySpecialty value)  filterBySpecialty,required TResult Function( LoadAvailability value)  loadAvailability,required TResult Function( LoadNextPage value)  loadNextPage,}){
final _that = this;
switch (_that) {
case LoadDoctors():
return loadDoctors(_that);case SearchDoctors():
return searchDoctors(_that);case FilterBySpecialty():
return filterBySpecialty(_that);case LoadAvailability():
return loadAvailability(_that);case LoadNextPage():
return loadNextPage(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadDoctors value)?  loadDoctors,TResult? Function( SearchDoctors value)?  searchDoctors,TResult? Function( FilterBySpecialty value)?  filterBySpecialty,TResult? Function( LoadAvailability value)?  loadAvailability,TResult? Function( LoadNextPage value)?  loadNextPage,}){
final _that = this;
switch (_that) {
case LoadDoctors() when loadDoctors != null:
return loadDoctors(_that);case SearchDoctors() when searchDoctors != null:
return searchDoctors(_that);case FilterBySpecialty() when filterBySpecialty != null:
return filterBySpecialty(_that);case LoadAvailability() when loadAvailability != null:
return loadAvailability(_that);case LoadNextPage() when loadNextPage != null:
return loadNextPage(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadDoctors,TResult Function( String query)?  searchDoctors,TResult Function( String specialty)?  filterBySpecialty,TResult Function( String doctorId)?  loadAvailability,TResult Function()?  loadNextPage,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadDoctors() when loadDoctors != null:
return loadDoctors();case SearchDoctors() when searchDoctors != null:
return searchDoctors(_that.query);case FilterBySpecialty() when filterBySpecialty != null:
return filterBySpecialty(_that.specialty);case LoadAvailability() when loadAvailability != null:
return loadAvailability(_that.doctorId);case LoadNextPage() when loadNextPage != null:
return loadNextPage();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadDoctors,required TResult Function( String query)  searchDoctors,required TResult Function( String specialty)  filterBySpecialty,required TResult Function( String doctorId)  loadAvailability,required TResult Function()  loadNextPage,}) {final _that = this;
switch (_that) {
case LoadDoctors():
return loadDoctors();case SearchDoctors():
return searchDoctors(_that.query);case FilterBySpecialty():
return filterBySpecialty(_that.specialty);case LoadAvailability():
return loadAvailability(_that.doctorId);case LoadNextPage():
return loadNextPage();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadDoctors,TResult? Function( String query)?  searchDoctors,TResult? Function( String specialty)?  filterBySpecialty,TResult? Function( String doctorId)?  loadAvailability,TResult? Function()?  loadNextPage,}) {final _that = this;
switch (_that) {
case LoadDoctors() when loadDoctors != null:
return loadDoctors();case SearchDoctors() when searchDoctors != null:
return searchDoctors(_that.query);case FilterBySpecialty() when filterBySpecialty != null:
return filterBySpecialty(_that.specialty);case LoadAvailability() when loadAvailability != null:
return loadAvailability(_that.doctorId);case LoadNextPage() when loadNextPage != null:
return loadNextPage();case _:
  return null;

}
}

}

/// @nodoc


class LoadDoctors implements DoctorSearchEvent {
  const LoadDoctors();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadDoctors);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoctorSearchEvent.loadDoctors()';
}


}




/// @nodoc


class SearchDoctors implements DoctorSearchEvent {
  const SearchDoctors(this.query);
  

 final  String query;

/// Create a copy of DoctorSearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchDoctorsCopyWith<SearchDoctors> get copyWith => _$SearchDoctorsCopyWithImpl<SearchDoctors>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchDoctors&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'DoctorSearchEvent.searchDoctors(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchDoctorsCopyWith<$Res> implements $DoctorSearchEventCopyWith<$Res> {
  factory $SearchDoctorsCopyWith(SearchDoctors value, $Res Function(SearchDoctors) _then) = _$SearchDoctorsCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchDoctorsCopyWithImpl<$Res>
    implements $SearchDoctorsCopyWith<$Res> {
  _$SearchDoctorsCopyWithImpl(this._self, this._then);

  final SearchDoctors _self;
  final $Res Function(SearchDoctors) _then;

/// Create a copy of DoctorSearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchDoctors(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FilterBySpecialty implements DoctorSearchEvent {
  const FilterBySpecialty(this.specialty);
  

 final  String specialty;

/// Create a copy of DoctorSearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilterBySpecialtyCopyWith<FilterBySpecialty> get copyWith => _$FilterBySpecialtyCopyWithImpl<FilterBySpecialty>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterBySpecialty&&(identical(other.specialty, specialty) || other.specialty == specialty));
}


@override
int get hashCode => Object.hash(runtimeType,specialty);

@override
String toString() {
  return 'DoctorSearchEvent.filterBySpecialty(specialty: $specialty)';
}


}

/// @nodoc
abstract mixin class $FilterBySpecialtyCopyWith<$Res> implements $DoctorSearchEventCopyWith<$Res> {
  factory $FilterBySpecialtyCopyWith(FilterBySpecialty value, $Res Function(FilterBySpecialty) _then) = _$FilterBySpecialtyCopyWithImpl;
@useResult
$Res call({
 String specialty
});




}
/// @nodoc
class _$FilterBySpecialtyCopyWithImpl<$Res>
    implements $FilterBySpecialtyCopyWith<$Res> {
  _$FilterBySpecialtyCopyWithImpl(this._self, this._then);

  final FilterBySpecialty _self;
  final $Res Function(FilterBySpecialty) _then;

/// Create a copy of DoctorSearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? specialty = null,}) {
  return _then(FilterBySpecialty(
null == specialty ? _self.specialty : specialty // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LoadAvailability implements DoctorSearchEvent {
  const LoadAvailability(this.doctorId);
  

 final  String doctorId;

/// Create a copy of DoctorSearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadAvailabilityCopyWith<LoadAvailability> get copyWith => _$LoadAvailabilityCopyWithImpl<LoadAvailability>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadAvailability&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId));
}


@override
int get hashCode => Object.hash(runtimeType,doctorId);

@override
String toString() {
  return 'DoctorSearchEvent.loadAvailability(doctorId: $doctorId)';
}


}

/// @nodoc
abstract mixin class $LoadAvailabilityCopyWith<$Res> implements $DoctorSearchEventCopyWith<$Res> {
  factory $LoadAvailabilityCopyWith(LoadAvailability value, $Res Function(LoadAvailability) _then) = _$LoadAvailabilityCopyWithImpl;
@useResult
$Res call({
 String doctorId
});




}
/// @nodoc
class _$LoadAvailabilityCopyWithImpl<$Res>
    implements $LoadAvailabilityCopyWith<$Res> {
  _$LoadAvailabilityCopyWithImpl(this._self, this._then);

  final LoadAvailability _self;
  final $Res Function(LoadAvailability) _then;

/// Create a copy of DoctorSearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? doctorId = null,}) {
  return _then(LoadAvailability(
null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LoadNextPage implements DoctorSearchEvent {
  const LoadNextPage();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadNextPage);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoctorSearchEvent.loadNextPage()';
}


}




// dart format on
