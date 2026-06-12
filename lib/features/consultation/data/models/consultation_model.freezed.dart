// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consultation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConsultationModel {

/// Primary key (UUID).
 String get id;/// FK → `consultation_bookings.id` — the parent booking.
@JsonKey(name: 'booking_id') String get bookingId;/// Doctor's clinical summary / notes; null if not yet written.
 String? get summary;/// Prescription text issued during the consultation; null if none issued.
 String? get prescription;/// Private Storage path to the session recording.
/// Non-null only when the patient opted in to recording.
@JsonKey(name: 'recording_path') String? get recordingPath;/// Row creation timestamp — set by Postgres default.
@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of ConsultationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsultationModelCopyWith<ConsultationModel> get copyWith => _$ConsultationModelCopyWithImpl<ConsultationModel>(this as ConsultationModel, _$identity);

  /// Serializes this ConsultationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsultationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.prescription, prescription) || other.prescription == prescription)&&(identical(other.recordingPath, recordingPath) || other.recordingPath == recordingPath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingId,summary,prescription,recordingPath,createdAt);

@override
String toString() {
  return 'ConsultationModel(id: $id, bookingId: $bookingId, summary: $summary, prescription: $prescription, recordingPath: $recordingPath, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ConsultationModelCopyWith<$Res>  {
  factory $ConsultationModelCopyWith(ConsultationModel value, $Res Function(ConsultationModel) _then) = _$ConsultationModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'booking_id') String bookingId, String? summary, String? prescription,@JsonKey(name: 'recording_path') String? recordingPath,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$ConsultationModelCopyWithImpl<$Res>
    implements $ConsultationModelCopyWith<$Res> {
  _$ConsultationModelCopyWithImpl(this._self, this._then);

  final ConsultationModel _self;
  final $Res Function(ConsultationModel) _then;

/// Create a copy of ConsultationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookingId = null,Object? summary = freezed,Object? prescription = freezed,Object? recordingPath = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,prescription: freezed == prescription ? _self.prescription : prescription // ignore: cast_nullable_to_non_nullable
as String?,recordingPath: freezed == recordingPath ? _self.recordingPath : recordingPath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsultationModel].
extension ConsultationModelPatterns on ConsultationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsultationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsultationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsultationModel value)  $default,){
final _that = this;
switch (_that) {
case _ConsultationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsultationModel value)?  $default,){
final _that = this;
switch (_that) {
case _ConsultationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'booking_id')  String bookingId,  String? summary,  String? prescription, @JsonKey(name: 'recording_path')  String? recordingPath, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsultationModel() when $default != null:
return $default(_that.id,_that.bookingId,_that.summary,_that.prescription,_that.recordingPath,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'booking_id')  String bookingId,  String? summary,  String? prescription, @JsonKey(name: 'recording_path')  String? recordingPath, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ConsultationModel():
return $default(_that.id,_that.bookingId,_that.summary,_that.prescription,_that.recordingPath,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'booking_id')  String bookingId,  String? summary,  String? prescription, @JsonKey(name: 'recording_path')  String? recordingPath, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ConsultationModel() when $default != null:
return $default(_that.id,_that.bookingId,_that.summary,_that.prescription,_that.recordingPath,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsultationModel implements ConsultationModel {
  const _ConsultationModel({required this.id, @JsonKey(name: 'booking_id') required this.bookingId, this.summary, this.prescription, @JsonKey(name: 'recording_path') this.recordingPath, @JsonKey(name: 'created_at') required this.createdAt});
  factory _ConsultationModel.fromJson(Map<String, dynamic> json) => _$ConsultationModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// FK → `consultation_bookings.id` — the parent booking.
@override@JsonKey(name: 'booking_id') final  String bookingId;
/// Doctor's clinical summary / notes; null if not yet written.
@override final  String? summary;
/// Prescription text issued during the consultation; null if none issued.
@override final  String? prescription;
/// Private Storage path to the session recording.
/// Non-null only when the patient opted in to recording.
@override@JsonKey(name: 'recording_path') final  String? recordingPath;
/// Row creation timestamp — set by Postgres default.
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of ConsultationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsultationModelCopyWith<_ConsultationModel> get copyWith => __$ConsultationModelCopyWithImpl<_ConsultationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsultationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsultationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.prescription, prescription) || other.prescription == prescription)&&(identical(other.recordingPath, recordingPath) || other.recordingPath == recordingPath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingId,summary,prescription,recordingPath,createdAt);

@override
String toString() {
  return 'ConsultationModel(id: $id, bookingId: $bookingId, summary: $summary, prescription: $prescription, recordingPath: $recordingPath, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ConsultationModelCopyWith<$Res> implements $ConsultationModelCopyWith<$Res> {
  factory _$ConsultationModelCopyWith(_ConsultationModel value, $Res Function(_ConsultationModel) _then) = __$ConsultationModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'booking_id') String bookingId, String? summary, String? prescription,@JsonKey(name: 'recording_path') String? recordingPath,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$ConsultationModelCopyWithImpl<$Res>
    implements _$ConsultationModelCopyWith<$Res> {
  __$ConsultationModelCopyWithImpl(this._self, this._then);

  final _ConsultationModel _self;
  final $Res Function(_ConsultationModel) _then;

/// Create a copy of ConsultationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookingId = null,Object? summary = freezed,Object? prescription = freezed,Object? recordingPath = freezed,Object? createdAt = null,}) {
  return _then(_ConsultationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,prescription: freezed == prescription ? _self.prescription : prescription // ignore: cast_nullable_to_non_nullable
as String?,recordingPath: freezed == recordingPath ? _self.recordingPath : recordingPath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
