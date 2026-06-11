// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FollowModel {

/// FK → `profiles.id` — the user who is following.
@JsonKey(name: 'follower_id') String get followerId;/// FK → `profiles.id` — the user or topic being followed.
@JsonKey(name: 'target_id') String get targetId;/// Whether this is a topic-tag follow or a people follow.
@_FollowTypeConverter() FollowType get type;
/// Create a copy of FollowModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowModelCopyWith<FollowModel> get copyWith => _$FollowModelCopyWithImpl<FollowModel>(this as FollowModel, _$identity);

  /// Serializes this FollowModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowModel&&(identical(other.followerId, followerId) || other.followerId == followerId)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,followerId,targetId,type);

@override
String toString() {
  return 'FollowModel(followerId: $followerId, targetId: $targetId, type: $type)';
}


}

/// @nodoc
abstract mixin class $FollowModelCopyWith<$Res>  {
  factory $FollowModelCopyWith(FollowModel value, $Res Function(FollowModel) _then) = _$FollowModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'follower_id') String followerId,@JsonKey(name: 'target_id') String targetId,@_FollowTypeConverter() FollowType type
});




}
/// @nodoc
class _$FollowModelCopyWithImpl<$Res>
    implements $FollowModelCopyWith<$Res> {
  _$FollowModelCopyWithImpl(this._self, this._then);

  final FollowModel _self;
  final $Res Function(FollowModel) _then;

/// Create a copy of FollowModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? followerId = null,Object? targetId = null,Object? type = null,}) {
  return _then(_self.copyWith(
followerId: null == followerId ? _self.followerId : followerId // ignore: cast_nullable_to_non_nullable
as String,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FollowType,
  ));
}

}


/// Adds pattern-matching-related methods to [FollowModel].
extension FollowModelPatterns on FollowModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FollowModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FollowModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FollowModel value)  $default,){
final _that = this;
switch (_that) {
case _FollowModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FollowModel value)?  $default,){
final _that = this;
switch (_that) {
case _FollowModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'follower_id')  String followerId, @JsonKey(name: 'target_id')  String targetId, @_FollowTypeConverter()  FollowType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FollowModel() when $default != null:
return $default(_that.followerId,_that.targetId,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'follower_id')  String followerId, @JsonKey(name: 'target_id')  String targetId, @_FollowTypeConverter()  FollowType type)  $default,) {final _that = this;
switch (_that) {
case _FollowModel():
return $default(_that.followerId,_that.targetId,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'follower_id')  String followerId, @JsonKey(name: 'target_id')  String targetId, @_FollowTypeConverter()  FollowType type)?  $default,) {final _that = this;
switch (_that) {
case _FollowModel() when $default != null:
return $default(_that.followerId,_that.targetId,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FollowModel implements FollowModel {
  const _FollowModel({@JsonKey(name: 'follower_id') required this.followerId, @JsonKey(name: 'target_id') required this.targetId, @_FollowTypeConverter() required this.type});
  factory _FollowModel.fromJson(Map<String, dynamic> json) => _$FollowModelFromJson(json);

/// FK → `profiles.id` — the user who is following.
@override@JsonKey(name: 'follower_id') final  String followerId;
/// FK → `profiles.id` — the user or topic being followed.
@override@JsonKey(name: 'target_id') final  String targetId;
/// Whether this is a topic-tag follow or a people follow.
@override@_FollowTypeConverter() final  FollowType type;

/// Create a copy of FollowModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowModelCopyWith<_FollowModel> get copyWith => __$FollowModelCopyWithImpl<_FollowModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FollowModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowModel&&(identical(other.followerId, followerId) || other.followerId == followerId)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,followerId,targetId,type);

@override
String toString() {
  return 'FollowModel(followerId: $followerId, targetId: $targetId, type: $type)';
}


}

/// @nodoc
abstract mixin class _$FollowModelCopyWith<$Res> implements $FollowModelCopyWith<$Res> {
  factory _$FollowModelCopyWith(_FollowModel value, $Res Function(_FollowModel) _then) = __$FollowModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'follower_id') String followerId,@JsonKey(name: 'target_id') String targetId,@_FollowTypeConverter() FollowType type
});




}
/// @nodoc
class __$FollowModelCopyWithImpl<$Res>
    implements _$FollowModelCopyWith<$Res> {
  __$FollowModelCopyWithImpl(this._self, this._then);

  final _FollowModel _self;
  final $Res Function(_FollowModel) _then;

/// Create a copy of FollowModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? followerId = null,Object? targetId = null,Object? type = null,}) {
  return _then(_FollowModel(
followerId: null == followerId ? _self.followerId : followerId // ignore: cast_nullable_to_non_nullable
as String,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FollowType,
  ));
}


}

// dart format on
