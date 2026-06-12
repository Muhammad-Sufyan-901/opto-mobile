// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContentReportModel {

/// Primary key (UUID).
 String get id;/// FK → `profiles.id` — the user who filed the report.
@JsonKey(name: 'reporter_id') String get reporterId;/// FK → `posts.id` — the reported post.
@JsonKey(name: 'post_id') String get postId;/// The reason the reporter chose when submitting.
@_ReportReasonConverter() ReportReason get reason;/// Current moderation lifecycle status (default: pending).
@_ReportStatusConverter() ReportStatus get status;
/// Create a copy of ContentReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentReportModelCopyWith<ContentReportModel> get copyWith => _$ContentReportModelCopyWithImpl<ContentReportModel>(this as ContentReportModel, _$identity);

  /// Serializes this ContentReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentReportModel&&(identical(other.id, id) || other.id == id)&&(identical(other.reporterId, reporterId) || other.reporterId == reporterId)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reporterId,postId,reason,status);

@override
String toString() {
  return 'ContentReportModel(id: $id, reporterId: $reporterId, postId: $postId, reason: $reason, status: $status)';
}


}

/// @nodoc
abstract mixin class $ContentReportModelCopyWith<$Res>  {
  factory $ContentReportModelCopyWith(ContentReportModel value, $Res Function(ContentReportModel) _then) = _$ContentReportModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'reporter_id') String reporterId,@JsonKey(name: 'post_id') String postId,@_ReportReasonConverter() ReportReason reason,@_ReportStatusConverter() ReportStatus status
});




}
/// @nodoc
class _$ContentReportModelCopyWithImpl<$Res>
    implements $ContentReportModelCopyWith<$Res> {
  _$ContentReportModelCopyWithImpl(this._self, this._then);

  final ContentReportModel _self;
  final $Res Function(ContentReportModel) _then;

/// Create a copy of ContentReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? reporterId = null,Object? postId = null,Object? reason = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reporterId: null == reporterId ? _self.reporterId : reporterId // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ReportReason,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReportStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ContentReportModel].
extension ContentReportModelPatterns on ContentReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContentReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContentReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContentReportModel value)  $default,){
final _that = this;
switch (_that) {
case _ContentReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContentReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _ContentReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'reporter_id')  String reporterId, @JsonKey(name: 'post_id')  String postId, @_ReportReasonConverter()  ReportReason reason, @_ReportStatusConverter()  ReportStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContentReportModel() when $default != null:
return $default(_that.id,_that.reporterId,_that.postId,_that.reason,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'reporter_id')  String reporterId, @JsonKey(name: 'post_id')  String postId, @_ReportReasonConverter()  ReportReason reason, @_ReportStatusConverter()  ReportStatus status)  $default,) {final _that = this;
switch (_that) {
case _ContentReportModel():
return $default(_that.id,_that.reporterId,_that.postId,_that.reason,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'reporter_id')  String reporterId, @JsonKey(name: 'post_id')  String postId, @_ReportReasonConverter()  ReportReason reason, @_ReportStatusConverter()  ReportStatus status)?  $default,) {final _that = this;
switch (_that) {
case _ContentReportModel() when $default != null:
return $default(_that.id,_that.reporterId,_that.postId,_that.reason,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContentReportModel implements ContentReportModel {
  const _ContentReportModel({required this.id, @JsonKey(name: 'reporter_id') required this.reporterId, @JsonKey(name: 'post_id') required this.postId, @_ReportReasonConverter() required this.reason, @_ReportStatusConverter() required this.status});
  factory _ContentReportModel.fromJson(Map<String, dynamic> json) => _$ContentReportModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// FK → `profiles.id` — the user who filed the report.
@override@JsonKey(name: 'reporter_id') final  String reporterId;
/// FK → `posts.id` — the reported post.
@override@JsonKey(name: 'post_id') final  String postId;
/// The reason the reporter chose when submitting.
@override@_ReportReasonConverter() final  ReportReason reason;
/// Current moderation lifecycle status (default: pending).
@override@_ReportStatusConverter() final  ReportStatus status;

/// Create a copy of ContentReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentReportModelCopyWith<_ContentReportModel> get copyWith => __$ContentReportModelCopyWithImpl<_ContentReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContentReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentReportModel&&(identical(other.id, id) || other.id == id)&&(identical(other.reporterId, reporterId) || other.reporterId == reporterId)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reporterId,postId,reason,status);

@override
String toString() {
  return 'ContentReportModel(id: $id, reporterId: $reporterId, postId: $postId, reason: $reason, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ContentReportModelCopyWith<$Res> implements $ContentReportModelCopyWith<$Res> {
  factory _$ContentReportModelCopyWith(_ContentReportModel value, $Res Function(_ContentReportModel) _then) = __$ContentReportModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'reporter_id') String reporterId,@JsonKey(name: 'post_id') String postId,@_ReportReasonConverter() ReportReason reason,@_ReportStatusConverter() ReportStatus status
});




}
/// @nodoc
class __$ContentReportModelCopyWithImpl<$Res>
    implements _$ContentReportModelCopyWith<$Res> {
  __$ContentReportModelCopyWithImpl(this._self, this._then);

  final _ContentReportModel _self;
  final $Res Function(_ContentReportModel) _then;

/// Create a copy of ContentReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? reporterId = null,Object? postId = null,Object? reason = null,Object? status = null,}) {
  return _then(_ContentReportModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reporterId: null == reporterId ? _self.reporterId : reporterId // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ReportReason,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReportStatus,
  ));
}


}

// dart format on
