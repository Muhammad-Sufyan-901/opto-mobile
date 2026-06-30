// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consultation_message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConsultationMessageModel {

/// Primary key (UUID).
 String get id;/// FK → `consultation_bookings.id`.
@JsonKey(name: 'booking_id') String get bookingId;/// UUID of the profile who sent this message (patient or doctor).
@JsonKey(name: 'sender_id') String get senderId;/// The message text body.
 String get body;/// Row creation timestamp — set by Postgres default.
@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of ConsultationMessageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsultationMessageModelCopyWith<ConsultationMessageModel> get copyWith => _$ConsultationMessageModelCopyWithImpl<ConsultationMessageModel>(this as ConsultationMessageModel, _$identity);

  /// Serializes this ConsultationMessageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsultationMessageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingId,senderId,body,createdAt);

@override
String toString() {
  return 'ConsultationMessageModel(id: $id, bookingId: $bookingId, senderId: $senderId, body: $body, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ConsultationMessageModelCopyWith<$Res>  {
  factory $ConsultationMessageModelCopyWith(ConsultationMessageModel value, $Res Function(ConsultationMessageModel) _then) = _$ConsultationMessageModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'booking_id') String bookingId,@JsonKey(name: 'sender_id') String senderId, String body,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$ConsultationMessageModelCopyWithImpl<$Res>
    implements $ConsultationMessageModelCopyWith<$Res> {
  _$ConsultationMessageModelCopyWithImpl(this._self, this._then);

  final ConsultationMessageModel _self;
  final $Res Function(ConsultationMessageModel) _then;

/// Create a copy of ConsultationMessageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookingId = null,Object? senderId = null,Object? body = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsultationMessageModel].
extension ConsultationMessageModelPatterns on ConsultationMessageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsultationMessageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsultationMessageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsultationMessageModel value)  $default,){
final _that = this;
switch (_that) {
case _ConsultationMessageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsultationMessageModel value)?  $default,){
final _that = this;
switch (_that) {
case _ConsultationMessageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'booking_id')  String bookingId, @JsonKey(name: 'sender_id')  String senderId,  String body, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsultationMessageModel() when $default != null:
return $default(_that.id,_that.bookingId,_that.senderId,_that.body,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'booking_id')  String bookingId, @JsonKey(name: 'sender_id')  String senderId,  String body, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ConsultationMessageModel():
return $default(_that.id,_that.bookingId,_that.senderId,_that.body,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'booking_id')  String bookingId, @JsonKey(name: 'sender_id')  String senderId,  String body, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ConsultationMessageModel() when $default != null:
return $default(_that.id,_that.bookingId,_that.senderId,_that.body,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsultationMessageModel implements ConsultationMessageModel {
  const _ConsultationMessageModel({required this.id, @JsonKey(name: 'booking_id') required this.bookingId, @JsonKey(name: 'sender_id') required this.senderId, required this.body, @JsonKey(name: 'created_at') required this.createdAt});
  factory _ConsultationMessageModel.fromJson(Map<String, dynamic> json) => _$ConsultationMessageModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// FK → `consultation_bookings.id`.
@override@JsonKey(name: 'booking_id') final  String bookingId;
/// UUID of the profile who sent this message (patient or doctor).
@override@JsonKey(name: 'sender_id') final  String senderId;
/// The message text body.
@override final  String body;
/// Row creation timestamp — set by Postgres default.
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of ConsultationMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsultationMessageModelCopyWith<_ConsultationMessageModel> get copyWith => __$ConsultationMessageModelCopyWithImpl<_ConsultationMessageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsultationMessageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsultationMessageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingId,senderId,body,createdAt);

@override
String toString() {
  return 'ConsultationMessageModel(id: $id, bookingId: $bookingId, senderId: $senderId, body: $body, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ConsultationMessageModelCopyWith<$Res> implements $ConsultationMessageModelCopyWith<$Res> {
  factory _$ConsultationMessageModelCopyWith(_ConsultationMessageModel value, $Res Function(_ConsultationMessageModel) _then) = __$ConsultationMessageModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'booking_id') String bookingId,@JsonKey(name: 'sender_id') String senderId, String body,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$ConsultationMessageModelCopyWithImpl<$Res>
    implements _$ConsultationMessageModelCopyWith<$Res> {
  __$ConsultationMessageModelCopyWithImpl(this._self, this._then);

  final _ConsultationMessageModel _self;
  final $Res Function(_ConsultationMessageModel) _then;

/// Create a copy of ConsultationMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookingId = null,Object? senderId = null,Object? body = null,Object? createdAt = null,}) {
  return _then(_ConsultationMessageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
