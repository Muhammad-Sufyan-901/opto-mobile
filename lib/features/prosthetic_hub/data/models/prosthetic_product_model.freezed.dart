// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prosthetic_product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProstheticProductModel {

/// Primary key (UUID).
 String get id;/// Product category — mirrors the `product_type` Postgres enum.
@JsonKey(name: 'type', fromJson: _productTypeFromJson, toJson: _productTypeToJson) ProductType get type;/// Human-readable product name.
 String get name;/// Audio description announced to screen reader users on focus.
@JsonKey(name: 'audio_description') String get audioDescription;/// Material description (e.g. 'PMMA', 'silicone').
 String? get material;/// Iris colour name (applies to prosthesis type only).
@JsonKey(name: 'iris_color') String? get irisColor;/// Size code / label.
 String? get size;/// Whether this is a custom/bespoke order.
@JsonKey(name: 'is_custom') bool get isCustom;/// Price in Indonesian Rupiah (IDR).
@JsonKey(name: 'price_idr') int get priceIdr;/// FK to the `vendors` table (nullable).
@JsonKey(name: 'vendor_id') String? get vendorId;/// Whether this product is actively listed in the catalog.
@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of ProstheticProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProstheticProductModelCopyWith<ProstheticProductModel> get copyWith => _$ProstheticProductModelCopyWithImpl<ProstheticProductModel>(this as ProstheticProductModel, _$identity);

  /// Serializes this ProstheticProductModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProstheticProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.audioDescription, audioDescription) || other.audioDescription == audioDescription)&&(identical(other.material, material) || other.material == material)&&(identical(other.irisColor, irisColor) || other.irisColor == irisColor)&&(identical(other.size, size) || other.size == size)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom)&&(identical(other.priceIdr, priceIdr) || other.priceIdr == priceIdr)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,audioDescription,material,irisColor,size,isCustom,priceIdr,vendorId,isActive);

@override
String toString() {
  return 'ProstheticProductModel(id: $id, type: $type, name: $name, audioDescription: $audioDescription, material: $material, irisColor: $irisColor, size: $size, isCustom: $isCustom, priceIdr: $priceIdr, vendorId: $vendorId, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ProstheticProductModelCopyWith<$Res>  {
  factory $ProstheticProductModelCopyWith(ProstheticProductModel value, $Res Function(ProstheticProductModel) _then) = _$ProstheticProductModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'type', fromJson: _productTypeFromJson, toJson: _productTypeToJson) ProductType type, String name,@JsonKey(name: 'audio_description') String audioDescription, String? material,@JsonKey(name: 'iris_color') String? irisColor, String? size,@JsonKey(name: 'is_custom') bool isCustom,@JsonKey(name: 'price_idr') int priceIdr,@JsonKey(name: 'vendor_id') String? vendorId,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$ProstheticProductModelCopyWithImpl<$Res>
    implements $ProstheticProductModelCopyWith<$Res> {
  _$ProstheticProductModelCopyWithImpl(this._self, this._then);

  final ProstheticProductModel _self;
  final $Res Function(ProstheticProductModel) _then;

/// Create a copy of ProstheticProductModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? name = null,Object? audioDescription = null,Object? material = freezed,Object? irisColor = freezed,Object? size = freezed,Object? isCustom = null,Object? priceIdr = null,Object? vendorId = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProductType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,audioDescription: null == audioDescription ? _self.audioDescription : audioDescription // ignore: cast_nullable_to_non_nullable
as String,material: freezed == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as String?,irisColor: freezed == irisColor ? _self.irisColor : irisColor // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String?,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,priceIdr: null == priceIdr ? _self.priceIdr : priceIdr // ignore: cast_nullable_to_non_nullable
as int,vendorId: freezed == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProstheticProductModel].
extension ProstheticProductModelPatterns on ProstheticProductModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProstheticProductModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProstheticProductModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProstheticProductModel value)  $default,){
final _that = this;
switch (_that) {
case _ProstheticProductModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProstheticProductModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProstheticProductModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'type', fromJson: _productTypeFromJson, toJson: _productTypeToJson)  ProductType type,  String name, @JsonKey(name: 'audio_description')  String audioDescription,  String? material, @JsonKey(name: 'iris_color')  String? irisColor,  String? size, @JsonKey(name: 'is_custom')  bool isCustom, @JsonKey(name: 'price_idr')  int priceIdr, @JsonKey(name: 'vendor_id')  String? vendorId, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProstheticProductModel() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.audioDescription,_that.material,_that.irisColor,_that.size,_that.isCustom,_that.priceIdr,_that.vendorId,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'type', fromJson: _productTypeFromJson, toJson: _productTypeToJson)  ProductType type,  String name, @JsonKey(name: 'audio_description')  String audioDescription,  String? material, @JsonKey(name: 'iris_color')  String? irisColor,  String? size, @JsonKey(name: 'is_custom')  bool isCustom, @JsonKey(name: 'price_idr')  int priceIdr, @JsonKey(name: 'vendor_id')  String? vendorId, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _ProstheticProductModel():
return $default(_that.id,_that.type,_that.name,_that.audioDescription,_that.material,_that.irisColor,_that.size,_that.isCustom,_that.priceIdr,_that.vendorId,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'type', fromJson: _productTypeFromJson, toJson: _productTypeToJson)  ProductType type,  String name, @JsonKey(name: 'audio_description')  String audioDescription,  String? material, @JsonKey(name: 'iris_color')  String? irisColor,  String? size, @JsonKey(name: 'is_custom')  bool isCustom, @JsonKey(name: 'price_idr')  int priceIdr, @JsonKey(name: 'vendor_id')  String? vendorId, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _ProstheticProductModel() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.audioDescription,_that.material,_that.irisColor,_that.size,_that.isCustom,_that.priceIdr,_that.vendorId,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProstheticProductModel implements ProstheticProductModel {
  const _ProstheticProductModel({required this.id, @JsonKey(name: 'type', fromJson: _productTypeFromJson, toJson: _productTypeToJson) required this.type, required this.name, @JsonKey(name: 'audio_description') required this.audioDescription, this.material, @JsonKey(name: 'iris_color') this.irisColor, this.size, @JsonKey(name: 'is_custom') required this.isCustom, @JsonKey(name: 'price_idr') required this.priceIdr, @JsonKey(name: 'vendor_id') this.vendorId, @JsonKey(name: 'is_active') required this.isActive});
  factory _ProstheticProductModel.fromJson(Map<String, dynamic> json) => _$ProstheticProductModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// Product category — mirrors the `product_type` Postgres enum.
@override@JsonKey(name: 'type', fromJson: _productTypeFromJson, toJson: _productTypeToJson) final  ProductType type;
/// Human-readable product name.
@override final  String name;
/// Audio description announced to screen reader users on focus.
@override@JsonKey(name: 'audio_description') final  String audioDescription;
/// Material description (e.g. 'PMMA', 'silicone').
@override final  String? material;
/// Iris colour name (applies to prosthesis type only).
@override@JsonKey(name: 'iris_color') final  String? irisColor;
/// Size code / label.
@override final  String? size;
/// Whether this is a custom/bespoke order.
@override@JsonKey(name: 'is_custom') final  bool isCustom;
/// Price in Indonesian Rupiah (IDR).
@override@JsonKey(name: 'price_idr') final  int priceIdr;
/// FK to the `vendors` table (nullable).
@override@JsonKey(name: 'vendor_id') final  String? vendorId;
/// Whether this product is actively listed in the catalog.
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of ProstheticProductModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProstheticProductModelCopyWith<_ProstheticProductModel> get copyWith => __$ProstheticProductModelCopyWithImpl<_ProstheticProductModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProstheticProductModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProstheticProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.audioDescription, audioDescription) || other.audioDescription == audioDescription)&&(identical(other.material, material) || other.material == material)&&(identical(other.irisColor, irisColor) || other.irisColor == irisColor)&&(identical(other.size, size) || other.size == size)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom)&&(identical(other.priceIdr, priceIdr) || other.priceIdr == priceIdr)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,audioDescription,material,irisColor,size,isCustom,priceIdr,vendorId,isActive);

@override
String toString() {
  return 'ProstheticProductModel(id: $id, type: $type, name: $name, audioDescription: $audioDescription, material: $material, irisColor: $irisColor, size: $size, isCustom: $isCustom, priceIdr: $priceIdr, vendorId: $vendorId, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ProstheticProductModelCopyWith<$Res> implements $ProstheticProductModelCopyWith<$Res> {
  factory _$ProstheticProductModelCopyWith(_ProstheticProductModel value, $Res Function(_ProstheticProductModel) _then) = __$ProstheticProductModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'type', fromJson: _productTypeFromJson, toJson: _productTypeToJson) ProductType type, String name,@JsonKey(name: 'audio_description') String audioDescription, String? material,@JsonKey(name: 'iris_color') String? irisColor, String? size,@JsonKey(name: 'is_custom') bool isCustom,@JsonKey(name: 'price_idr') int priceIdr,@JsonKey(name: 'vendor_id') String? vendorId,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$ProstheticProductModelCopyWithImpl<$Res>
    implements _$ProstheticProductModelCopyWith<$Res> {
  __$ProstheticProductModelCopyWithImpl(this._self, this._then);

  final _ProstheticProductModel _self;
  final $Res Function(_ProstheticProductModel) _then;

/// Create a copy of ProstheticProductModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? name = null,Object? audioDescription = null,Object? material = freezed,Object? irisColor = freezed,Object? size = freezed,Object? isCustom = null,Object? priceIdr = null,Object? vendorId = freezed,Object? isActive = null,}) {
  return _then(_ProstheticProductModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProductType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,audioDescription: null == audioDescription ? _self.audioDescription : audioDescription // ignore: cast_nullable_to_non_nullable
as String,material: freezed == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as String?,irisColor: freezed == irisColor ? _self.irisColor : irisColor // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String?,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,priceIdr: null == priceIdr ? _self.priceIdr : priceIdr // ignore: cast_nullable_to_non_nullable
as int,vendorId: freezed == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
