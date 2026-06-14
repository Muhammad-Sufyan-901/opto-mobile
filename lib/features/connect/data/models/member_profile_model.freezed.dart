// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemberProfileModel {

/// Primary key (UUID).
 String get id;/// Display name of the member.
@JsonKey(name: 'full_name') String get fullName;/// Optional public avatar storage URL.
@JsonKey(name: 'avatar_url') String? get avatarUrl;/// Whether this profile has been verified by moderators.
@JsonKey(name: 'is_verified') bool get isVerified;/// Whether this member is a community mentor.
@JsonKey(name: 'is_mentor') bool get isMentor;/// Optional member bio/tagline.
 String? get bio;/// Optional @handle displayed on the profile.
 String? get handle;/// Row creation timestamp — used to derive the joinedYear.
@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of MemberProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberProfileModelCopyWith<MemberProfileModel> get copyWith => _$MemberProfileModelCopyWithImpl<MemberProfileModel>(this as MemberProfileModel, _$identity);

  /// Serializes this MemberProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isMentor, isMentor) || other.isMentor == isMentor)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,isVerified,isMentor,bio,handle,createdAt);

@override
String toString() {
  return 'MemberProfileModel(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, isVerified: $isVerified, isMentor: $isMentor, bio: $bio, handle: $handle, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MemberProfileModelCopyWith<$Res>  {
  factory $MemberProfileModelCopyWith(MemberProfileModel value, $Res Function(MemberProfileModel) _then) = _$MemberProfileModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'is_verified') bool isVerified,@JsonKey(name: 'is_mentor') bool isMentor, String? bio, String? handle,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$MemberProfileModelCopyWithImpl<$Res>
    implements $MemberProfileModelCopyWith<$Res> {
  _$MemberProfileModelCopyWithImpl(this._self, this._then);

  final MemberProfileModel _self;
  final $Res Function(MemberProfileModel) _then;

/// Create a copy of MemberProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? avatarUrl = freezed,Object? isVerified = null,Object? isMentor = null,Object? bio = freezed,Object? handle = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,isMentor: null == isMentor ? _self.isMentor : isMentor // ignore: cast_nullable_to_non_nullable
as bool,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberProfileModel].
extension MemberProfileModelPatterns on MemberProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _MemberProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _MemberProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_verified')  bool isVerified, @JsonKey(name: 'is_mentor')  bool isMentor,  String? bio,  String? handle, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberProfileModel() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.isVerified,_that.isMentor,_that.bio,_that.handle,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_verified')  bool isVerified, @JsonKey(name: 'is_mentor')  bool isMentor,  String? bio,  String? handle, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _MemberProfileModel():
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.isVerified,_that.isMentor,_that.bio,_that.handle,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_verified')  bool isVerified, @JsonKey(name: 'is_mentor')  bool isMentor,  String? bio,  String? handle, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MemberProfileModel() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.isVerified,_that.isMentor,_that.bio,_that.handle,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemberProfileModel implements MemberProfileModel {
  const _MemberProfileModel({required this.id, @JsonKey(name: 'full_name') required this.fullName, @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'is_verified') this.isVerified = false, @JsonKey(name: 'is_mentor') this.isMentor = false, this.bio, this.handle, @JsonKey(name: 'created_at') required this.createdAt});
  factory _MemberProfileModel.fromJson(Map<String, dynamic> json) => _$MemberProfileModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// Display name of the member.
@override@JsonKey(name: 'full_name') final  String fullName;
/// Optional public avatar storage URL.
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
/// Whether this profile has been verified by moderators.
@override@JsonKey(name: 'is_verified') final  bool isVerified;
/// Whether this member is a community mentor.
@override@JsonKey(name: 'is_mentor') final  bool isMentor;
/// Optional member bio/tagline.
@override final  String? bio;
/// Optional @handle displayed on the profile.
@override final  String? handle;
/// Row creation timestamp — used to derive the joinedYear.
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of MemberProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberProfileModelCopyWith<_MemberProfileModel> get copyWith => __$MemberProfileModelCopyWithImpl<_MemberProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isMentor, isMentor) || other.isMentor == isMentor)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,isVerified,isMentor,bio,handle,createdAt);

@override
String toString() {
  return 'MemberProfileModel(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, isVerified: $isVerified, isMentor: $isMentor, bio: $bio, handle: $handle, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MemberProfileModelCopyWith<$Res> implements $MemberProfileModelCopyWith<$Res> {
  factory _$MemberProfileModelCopyWith(_MemberProfileModel value, $Res Function(_MemberProfileModel) _then) = __$MemberProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'is_verified') bool isVerified,@JsonKey(name: 'is_mentor') bool isMentor, String? bio, String? handle,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$MemberProfileModelCopyWithImpl<$Res>
    implements _$MemberProfileModelCopyWith<$Res> {
  __$MemberProfileModelCopyWithImpl(this._self, this._then);

  final _MemberProfileModel _self;
  final $Res Function(_MemberProfileModel) _then;

/// Create a copy of MemberProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? avatarUrl = freezed,Object? isVerified = null,Object? isMentor = null,Object? bio = freezed,Object? handle = freezed,Object? createdAt = null,}) {
  return _then(_MemberProfileModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,isMentor: null == isMentor ? _self.isMentor : isMentor // ignore: cast_nullable_to_non_nullable
as bool,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
