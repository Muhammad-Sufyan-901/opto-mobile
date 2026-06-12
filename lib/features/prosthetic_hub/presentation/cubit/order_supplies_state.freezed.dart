// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_supplies_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderSuppliesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderSuppliesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderSuppliesState()';
}


}

/// @nodoc
class $OrderSuppliesStateCopyWith<$Res>  {
$OrderSuppliesStateCopyWith(OrderSuppliesState _, $Res Function(OrderSuppliesState) __);
}


/// Adds pattern-matching-related methods to [OrderSuppliesState].
extension OrderSuppliesStatePatterns on OrderSuppliesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OrderSuppliesInitial value)?  initial,TResult Function( OrderSuppliesLoading value)?  loading,TResult Function( OrderSuppliesCatalog value)?  catalog,TResult Function( OrderSuppliesSubmitting value)?  submitting,TResult Function( OrderSuppliesConfirmed value)?  confirmed,TResult Function( OrderSuppliesError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OrderSuppliesInitial() when initial != null:
return initial(_that);case OrderSuppliesLoading() when loading != null:
return loading(_that);case OrderSuppliesCatalog() when catalog != null:
return catalog(_that);case OrderSuppliesSubmitting() when submitting != null:
return submitting(_that);case OrderSuppliesConfirmed() when confirmed != null:
return confirmed(_that);case OrderSuppliesError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OrderSuppliesInitial value)  initial,required TResult Function( OrderSuppliesLoading value)  loading,required TResult Function( OrderSuppliesCatalog value)  catalog,required TResult Function( OrderSuppliesSubmitting value)  submitting,required TResult Function( OrderSuppliesConfirmed value)  confirmed,required TResult Function( OrderSuppliesError value)  error,}){
final _that = this;
switch (_that) {
case OrderSuppliesInitial():
return initial(_that);case OrderSuppliesLoading():
return loading(_that);case OrderSuppliesCatalog():
return catalog(_that);case OrderSuppliesSubmitting():
return submitting(_that);case OrderSuppliesConfirmed():
return confirmed(_that);case OrderSuppliesError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OrderSuppliesInitial value)?  initial,TResult? Function( OrderSuppliesLoading value)?  loading,TResult? Function( OrderSuppliesCatalog value)?  catalog,TResult? Function( OrderSuppliesSubmitting value)?  submitting,TResult? Function( OrderSuppliesConfirmed value)?  confirmed,TResult? Function( OrderSuppliesError value)?  error,}){
final _that = this;
switch (_that) {
case OrderSuppliesInitial() when initial != null:
return initial(_that);case OrderSuppliesLoading() when loading != null:
return loading(_that);case OrderSuppliesCatalog() when catalog != null:
return catalog(_that);case OrderSuppliesSubmitting() when submitting != null:
return submitting(_that);case OrderSuppliesConfirmed() when confirmed != null:
return confirmed(_that);case OrderSuppliesError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<SupplyProduct> products,  Map<String, int> cart)?  catalog,TResult Function( List<SupplyProduct> products,  Map<String, int> cart)?  submitting,TResult Function()?  confirmed,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OrderSuppliesInitial() when initial != null:
return initial();case OrderSuppliesLoading() when loading != null:
return loading();case OrderSuppliesCatalog() when catalog != null:
return catalog(_that.products,_that.cart);case OrderSuppliesSubmitting() when submitting != null:
return submitting(_that.products,_that.cart);case OrderSuppliesConfirmed() when confirmed != null:
return confirmed();case OrderSuppliesError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<SupplyProduct> products,  Map<String, int> cart)  catalog,required TResult Function( List<SupplyProduct> products,  Map<String, int> cart)  submitting,required TResult Function()  confirmed,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case OrderSuppliesInitial():
return initial();case OrderSuppliesLoading():
return loading();case OrderSuppliesCatalog():
return catalog(_that.products,_that.cart);case OrderSuppliesSubmitting():
return submitting(_that.products,_that.cart);case OrderSuppliesConfirmed():
return confirmed();case OrderSuppliesError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<SupplyProduct> products,  Map<String, int> cart)?  catalog,TResult? Function( List<SupplyProduct> products,  Map<String, int> cart)?  submitting,TResult? Function()?  confirmed,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case OrderSuppliesInitial() when initial != null:
return initial();case OrderSuppliesLoading() when loading != null:
return loading();case OrderSuppliesCatalog() when catalog != null:
return catalog(_that.products,_that.cart);case OrderSuppliesSubmitting() when submitting != null:
return submitting(_that.products,_that.cart);case OrderSuppliesConfirmed() when confirmed != null:
return confirmed();case OrderSuppliesError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class OrderSuppliesInitial implements OrderSuppliesState {
  const OrderSuppliesInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderSuppliesInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderSuppliesState.initial()';
}


}




/// @nodoc


class OrderSuppliesLoading implements OrderSuppliesState {
  const OrderSuppliesLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderSuppliesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderSuppliesState.loading()';
}


}




/// @nodoc


class OrderSuppliesCatalog implements OrderSuppliesState {
  const OrderSuppliesCatalog({required final  List<SupplyProduct> products, required final  Map<String, int> cart}): _products = products,_cart = cart;
  

 final  List<SupplyProduct> _products;
 List<SupplyProduct> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  Map<String, int> _cart;
 Map<String, int> get cart {
  if (_cart is EqualUnmodifiableMapView) return _cart;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_cart);
}


/// Create a copy of OrderSuppliesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderSuppliesCatalogCopyWith<OrderSuppliesCatalog> get copyWith => _$OrderSuppliesCatalogCopyWithImpl<OrderSuppliesCatalog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderSuppliesCatalog&&const DeepCollectionEquality().equals(other._products, _products)&&const DeepCollectionEquality().equals(other._cart, _cart));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_cart));

@override
String toString() {
  return 'OrderSuppliesState.catalog(products: $products, cart: $cart)';
}


}

/// @nodoc
abstract mixin class $OrderSuppliesCatalogCopyWith<$Res> implements $OrderSuppliesStateCopyWith<$Res> {
  factory $OrderSuppliesCatalogCopyWith(OrderSuppliesCatalog value, $Res Function(OrderSuppliesCatalog) _then) = _$OrderSuppliesCatalogCopyWithImpl;
@useResult
$Res call({
 List<SupplyProduct> products, Map<String, int> cart
});




}
/// @nodoc
class _$OrderSuppliesCatalogCopyWithImpl<$Res>
    implements $OrderSuppliesCatalogCopyWith<$Res> {
  _$OrderSuppliesCatalogCopyWithImpl(this._self, this._then);

  final OrderSuppliesCatalog _self;
  final $Res Function(OrderSuppliesCatalog) _then;

/// Create a copy of OrderSuppliesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? products = null,Object? cart = null,}) {
  return _then(OrderSuppliesCatalog(
products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<SupplyProduct>,cart: null == cart ? _self._cart : cart // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

/// @nodoc


class OrderSuppliesSubmitting implements OrderSuppliesState {
  const OrderSuppliesSubmitting({required final  List<SupplyProduct> products, required final  Map<String, int> cart}): _products = products,_cart = cart;
  

 final  List<SupplyProduct> _products;
 List<SupplyProduct> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  Map<String, int> _cart;
 Map<String, int> get cart {
  if (_cart is EqualUnmodifiableMapView) return _cart;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_cart);
}


/// Create a copy of OrderSuppliesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderSuppliesSubmittingCopyWith<OrderSuppliesSubmitting> get copyWith => _$OrderSuppliesSubmittingCopyWithImpl<OrderSuppliesSubmitting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderSuppliesSubmitting&&const DeepCollectionEquality().equals(other._products, _products)&&const DeepCollectionEquality().equals(other._cart, _cart));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_cart));

@override
String toString() {
  return 'OrderSuppliesState.submitting(products: $products, cart: $cart)';
}


}

/// @nodoc
abstract mixin class $OrderSuppliesSubmittingCopyWith<$Res> implements $OrderSuppliesStateCopyWith<$Res> {
  factory $OrderSuppliesSubmittingCopyWith(OrderSuppliesSubmitting value, $Res Function(OrderSuppliesSubmitting) _then) = _$OrderSuppliesSubmittingCopyWithImpl;
@useResult
$Res call({
 List<SupplyProduct> products, Map<String, int> cart
});




}
/// @nodoc
class _$OrderSuppliesSubmittingCopyWithImpl<$Res>
    implements $OrderSuppliesSubmittingCopyWith<$Res> {
  _$OrderSuppliesSubmittingCopyWithImpl(this._self, this._then);

  final OrderSuppliesSubmitting _self;
  final $Res Function(OrderSuppliesSubmitting) _then;

/// Create a copy of OrderSuppliesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? products = null,Object? cart = null,}) {
  return _then(OrderSuppliesSubmitting(
products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<SupplyProduct>,cart: null == cart ? _self._cart : cart // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

/// @nodoc


class OrderSuppliesConfirmed implements OrderSuppliesState {
  const OrderSuppliesConfirmed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderSuppliesConfirmed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderSuppliesState.confirmed()';
}


}




/// @nodoc


class OrderSuppliesError implements OrderSuppliesState {
  const OrderSuppliesError(this.message);
  

 final  String message;

/// Create a copy of OrderSuppliesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderSuppliesErrorCopyWith<OrderSuppliesError> get copyWith => _$OrderSuppliesErrorCopyWithImpl<OrderSuppliesError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderSuppliesError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'OrderSuppliesState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $OrderSuppliesErrorCopyWith<$Res> implements $OrderSuppliesStateCopyWith<$Res> {
  factory $OrderSuppliesErrorCopyWith(OrderSuppliesError value, $Res Function(OrderSuppliesError) _then) = _$OrderSuppliesErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$OrderSuppliesErrorCopyWithImpl<$Res>
    implements $OrderSuppliesErrorCopyWith<$Res> {
  _$OrderSuppliesErrorCopyWithImpl(this._self, this._then);

  final OrderSuppliesError _self;
  final $Res Function(OrderSuppliesError) _then;

/// Create a copy of OrderSuppliesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(OrderSuppliesError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
