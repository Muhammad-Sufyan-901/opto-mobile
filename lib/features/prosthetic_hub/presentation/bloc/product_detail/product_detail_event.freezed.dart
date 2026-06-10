// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_detail_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductDetailEvent {

 String get productId;
/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailEventCopyWith<ProductDetailEvent> get copyWith => _$ProductDetailEventCopyWithImpl<ProductDetailEvent>(this as ProductDetailEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailEvent&&(identical(other.productId, productId) || other.productId == productId));
}


@override
int get hashCode => Object.hash(runtimeType,productId);

@override
String toString() {
  return 'ProductDetailEvent(productId: $productId)';
}


}

/// @nodoc
abstract mixin class $ProductDetailEventCopyWith<$Res>  {
  factory $ProductDetailEventCopyWith(ProductDetailEvent value, $Res Function(ProductDetailEvent) _then) = _$ProductDetailEventCopyWithImpl;
@useResult
$Res call({
 String productId
});




}
/// @nodoc
class _$ProductDetailEventCopyWithImpl<$Res>
    implements $ProductDetailEventCopyWith<$Res> {
  _$ProductDetailEventCopyWithImpl(this._self, this._then);

  final ProductDetailEvent _self;
  final $Res Function(ProductDetailEvent) _then;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductDetailEvent].
extension ProductDetailEventPatterns on ProductDetailEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProductDetailLoad value)?  load,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProductDetailLoad() when load != null:
return load(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProductDetailLoad value)  load,}){
final _that = this;
switch (_that) {
case ProductDetailLoad():
return load(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProductDetailLoad value)?  load,}){
final _that = this;
switch (_that) {
case ProductDetailLoad() when load != null:
return load(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String productId)?  load,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProductDetailLoad() when load != null:
return load(_that.productId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String productId)  load,}) {final _that = this;
switch (_that) {
case ProductDetailLoad():
return load(_that.productId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String productId)?  load,}) {final _that = this;
switch (_that) {
case ProductDetailLoad() when load != null:
return load(_that.productId);case _:
  return null;

}
}

}

/// @nodoc


class ProductDetailLoad implements ProductDetailEvent {
  const ProductDetailLoad(this.productId);
  

@override final  String productId;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailLoadCopyWith<ProductDetailLoad> get copyWith => _$ProductDetailLoadCopyWithImpl<ProductDetailLoad>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailLoad&&(identical(other.productId, productId) || other.productId == productId));
}


@override
int get hashCode => Object.hash(runtimeType,productId);

@override
String toString() {
  return 'ProductDetailEvent.load(productId: $productId)';
}


}

/// @nodoc
abstract mixin class $ProductDetailLoadCopyWith<$Res> implements $ProductDetailEventCopyWith<$Res> {
  factory $ProductDetailLoadCopyWith(ProductDetailLoad value, $Res Function(ProductDetailLoad) _then) = _$ProductDetailLoadCopyWithImpl;
@override @useResult
$Res call({
 String productId
});




}
/// @nodoc
class _$ProductDetailLoadCopyWithImpl<$Res>
    implements $ProductDetailLoadCopyWith<$Res> {
  _$ProductDetailLoadCopyWithImpl(this._self, this._then);

  final ProductDetailLoad _self;
  final $Res Function(ProductDetailLoad) _then;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,}) {
  return _then(ProductDetailLoad(
null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
