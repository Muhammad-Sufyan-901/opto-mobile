// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clinic_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClinicModel {

/// Primary key (UUID).
 String get id;/// Display name of the clinic or prosthetic manufacturer.
 String get name;/// Whether this entry is a prosthetic manufacturer rather than a clinic.
@JsonKey(name: 'is_manufacturer') bool get isManufacturer;/// Latitude coordinate for map display.
 double get lat;/// Longitude coordinate for map display.
 double get lng;/// Street / postal address.
 String get address;
/// Create a copy of ClinicModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClinicModelCopyWith<ClinicModel> get copyWith => _$ClinicModelCopyWithImpl<ClinicModel>(this as ClinicModel, _$identity);

  /// Serializes this ClinicModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClinicModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isManufacturer, isManufacturer) || other.isManufacturer == isManufacturer)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isManufacturer,lat,lng,address);

@override
String toString() {
  return 'ClinicModel(id: $id, name: $name, isManufacturer: $isManufacturer, lat: $lat, lng: $lng, address: $address)';
}


}

/// @nodoc
abstract mixin class $ClinicModelCopyWith<$Res>  {
  factory $ClinicModelCopyWith(ClinicModel value, $Res Function(ClinicModel) _then) = _$ClinicModelCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'is_manufacturer') bool isManufacturer, double lat, double lng, String address
});




}
/// @nodoc
class _$ClinicModelCopyWithImpl<$Res>
    implements $ClinicModelCopyWith<$Res> {
  _$ClinicModelCopyWithImpl(this._self, this._then);

  final ClinicModel _self;
  final $Res Function(ClinicModel) _then;

/// Create a copy of ClinicModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isManufacturer = null,Object? lat = null,Object? lng = null,Object? address = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isManufacturer: null == isManufacturer ? _self.isManufacturer : isManufacturer // ignore: cast_nullable_to_non_nullable
as bool,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ClinicModel].
extension ClinicModelPatterns on ClinicModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClinicModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClinicModel() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClinicModel value)  $default,){
final _that = this;
switch (_that) {
case _ClinicModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClinicModel value)?  $default,){
final _that = this;
switch (_that) {
case _ClinicModel() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'is_manufacturer')  bool isManufacturer,  double lat,  double lng,  String address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClinicModel() when $default != null:
return $default(_that.id,_that.name,_that.isManufacturer,_that.lat,_that.lng,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'is_manufacturer')  bool isManufacturer,  double lat,  double lng,  String address)  $default,) {final _that = this;
switch (_that) {
case _ClinicModel():
return $default(_that.id,_that.name,_that.isManufacturer,_that.lat,_that.lng,_that.address);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'is_manufacturer')  bool isManufacturer,  double lat,  double lng,  String address)?  $default,) {final _that = this;
switch (_that) {
case _ClinicModel() when $default != null:
return $default(_that.id,_that.name,_that.isManufacturer,_that.lat,_that.lng,_that.address);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClinicModel implements ClinicModel {
  const _ClinicModel({required this.id, required this.name, @JsonKey(name: 'is_manufacturer') required this.isManufacturer, required this.lat, required this.lng, required this.address});
  factory _ClinicModel.fromJson(Map<String, dynamic> json) => _$ClinicModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// Display name of the clinic or prosthetic manufacturer.
@override final  String name;
/// Whether this entry is a prosthetic manufacturer rather than a clinic.
@override@JsonKey(name: 'is_manufacturer') final  bool isManufacturer;
/// Latitude coordinate for map display.
@override final  double lat;
/// Longitude coordinate for map display.
@override final  double lng;
/// Street / postal address.
@override final  String address;

/// Create a copy of ClinicModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClinicModelCopyWith<_ClinicModel> get copyWith => __$ClinicModelCopyWithImpl<_ClinicModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClinicModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClinicModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isManufacturer, isManufacturer) || other.isManufacturer == isManufacturer)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isManufacturer,lat,lng,address);

@override
String toString() {
  return 'ClinicModel(id: $id, name: $name, isManufacturer: $isManufacturer, lat: $lat, lng: $lng, address: $address)';
}


}

/// @nodoc
abstract mixin class _$ClinicModelCopyWith<$Res> implements $ClinicModelCopyWith<$Res> {
  factory _$ClinicModelCopyWith(_ClinicModel value, $Res Function(_ClinicModel) _then) = __$ClinicModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'is_manufacturer') bool isManufacturer, double lat, double lng, String address
});




}
/// @nodoc
class __$ClinicModelCopyWithImpl<$Res>
    implements _$ClinicModelCopyWith<$Res> {
  __$ClinicModelCopyWithImpl(this._self, this._then);

  final _ClinicModel _self;
  final $Res Function(_ClinicModel) _then;

/// Create a copy of ClinicModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isManufacturer = null,Object? lat = null,Object? lng = null,Object? address = null,}) {
  return _then(_ClinicModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isManufacturer: null == isManufacturer ? _self.isManufacturer : isManufacturer // ignore: cast_nullable_to_non_nullable
as bool,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
