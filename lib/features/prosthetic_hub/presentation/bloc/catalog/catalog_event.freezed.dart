// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatalogEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CatalogEvent()';
}


}

/// @nodoc
class $CatalogEventCopyWith<$Res>  {
$CatalogEventCopyWith(CatalogEvent _, $Res Function(CatalogEvent) __);
}


/// Adds pattern-matching-related methods to [CatalogEvent].
extension CatalogEventPatterns on CatalogEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadCatalog value)?  loadCatalog,TResult Function( LoadProduct value)?  loadProduct,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadCatalog() when loadCatalog != null:
return loadCatalog(_that);case LoadProduct() when loadProduct != null:
return loadProduct(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadCatalog value)  loadCatalog,required TResult Function( LoadProduct value)  loadProduct,}){
final _that = this;
switch (_that) {
case LoadCatalog():
return loadCatalog(_that);case LoadProduct():
return loadProduct(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadCatalog value)?  loadCatalog,TResult? Function( LoadProduct value)?  loadProduct,}){
final _that = this;
switch (_that) {
case LoadCatalog() when loadCatalog != null:
return loadCatalog(_that);case LoadProduct() when loadProduct != null:
return loadProduct(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ProductType? typeFilter,  String? irisColorFilter,  String? sizeFilter)?  loadCatalog,TResult Function( String productId)?  loadProduct,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadCatalog() when loadCatalog != null:
return loadCatalog(_that.typeFilter,_that.irisColorFilter,_that.sizeFilter);case LoadProduct() when loadProduct != null:
return loadProduct(_that.productId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ProductType? typeFilter,  String? irisColorFilter,  String? sizeFilter)  loadCatalog,required TResult Function( String productId)  loadProduct,}) {final _that = this;
switch (_that) {
case LoadCatalog():
return loadCatalog(_that.typeFilter,_that.irisColorFilter,_that.sizeFilter);case LoadProduct():
return loadProduct(_that.productId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ProductType? typeFilter,  String? irisColorFilter,  String? sizeFilter)?  loadCatalog,TResult? Function( String productId)?  loadProduct,}) {final _that = this;
switch (_that) {
case LoadCatalog() when loadCatalog != null:
return loadCatalog(_that.typeFilter,_that.irisColorFilter,_that.sizeFilter);case LoadProduct() when loadProduct != null:
return loadProduct(_that.productId);case _:
  return null;

}
}

}

/// @nodoc


class LoadCatalog implements CatalogEvent {
  const LoadCatalog({this.typeFilter, this.irisColorFilter, this.sizeFilter});
  

 final  ProductType? typeFilter;
 final  String? irisColorFilter;
 final  String? sizeFilter;

/// Create a copy of CatalogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadCatalogCopyWith<LoadCatalog> get copyWith => _$LoadCatalogCopyWithImpl<LoadCatalog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadCatalog&&(identical(other.typeFilter, typeFilter) || other.typeFilter == typeFilter)&&(identical(other.irisColorFilter, irisColorFilter) || other.irisColorFilter == irisColorFilter)&&(identical(other.sizeFilter, sizeFilter) || other.sizeFilter == sizeFilter));
}


@override
int get hashCode => Object.hash(runtimeType,typeFilter,irisColorFilter,sizeFilter);

@override
String toString() {
  return 'CatalogEvent.loadCatalog(typeFilter: $typeFilter, irisColorFilter: $irisColorFilter, sizeFilter: $sizeFilter)';
}


}

/// @nodoc
abstract mixin class $LoadCatalogCopyWith<$Res> implements $CatalogEventCopyWith<$Res> {
  factory $LoadCatalogCopyWith(LoadCatalog value, $Res Function(LoadCatalog) _then) = _$LoadCatalogCopyWithImpl;
@useResult
$Res call({
 ProductType? typeFilter, String? irisColorFilter, String? sizeFilter
});




}
/// @nodoc
class _$LoadCatalogCopyWithImpl<$Res>
    implements $LoadCatalogCopyWith<$Res> {
  _$LoadCatalogCopyWithImpl(this._self, this._then);

  final LoadCatalog _self;
  final $Res Function(LoadCatalog) _then;

/// Create a copy of CatalogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? typeFilter = freezed,Object? irisColorFilter = freezed,Object? sizeFilter = freezed,}) {
  return _then(LoadCatalog(
typeFilter: freezed == typeFilter ? _self.typeFilter : typeFilter // ignore: cast_nullable_to_non_nullable
as ProductType?,irisColorFilter: freezed == irisColorFilter ? _self.irisColorFilter : irisColorFilter // ignore: cast_nullable_to_non_nullable
as String?,sizeFilter: freezed == sizeFilter ? _self.sizeFilter : sizeFilter // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class LoadProduct implements CatalogEvent {
  const LoadProduct(this.productId);
  

 final  String productId;

/// Create a copy of CatalogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadProductCopyWith<LoadProduct> get copyWith => _$LoadProductCopyWithImpl<LoadProduct>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadProduct&&(identical(other.productId, productId) || other.productId == productId));
}


@override
int get hashCode => Object.hash(runtimeType,productId);

@override
String toString() {
  return 'CatalogEvent.loadProduct(productId: $productId)';
}


}

/// @nodoc
abstract mixin class $LoadProductCopyWith<$Res> implements $CatalogEventCopyWith<$Res> {
  factory $LoadProductCopyWith(LoadProduct value, $Res Function(LoadProduct) _then) = _$LoadProductCopyWithImpl;
@useResult
$Res call({
 String productId
});




}
/// @nodoc
class _$LoadProductCopyWithImpl<$Res>
    implements $LoadProductCopyWith<$Res> {
  _$LoadProductCopyWithImpl(this._self, this._then);

  final LoadProduct _self;
  final $Res Function(LoadProduct) _then;

/// Create a copy of CatalogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,}) {
  return _then(LoadProduct(
null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
