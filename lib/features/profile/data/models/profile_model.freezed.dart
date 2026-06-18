// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileModel {

/// Primary key — matches `auth.users.id` (UUID).
 String get id;/// User's role in the Opto ecosystem.
@_UserRoleConverter() UserRole get role;/// User's display name (nullable until set).
@JsonKey(name: 'full_name') String? get fullName;/// Contact phone number (nullable until set).
 String? get phone;/// How the user perceives vision (nullable until set during onboarding).
@JsonKey(name: 'vision_profile')@_VisionProfileConverter() VisionProfile? get visionProfile;/// Supabase Storage public URL for the user's avatar (nullable).
@JsonKey(name: 'avatar_url') String? get avatarUrl;/// The user's @handle (stored in DB as `handle`).
@JsonKey(name: 'handle') String? get username;/// The user's preferred pronouns (e.g. "she/her", "they/them").
 String? get pronouns;/// Short bio shown on the community profile card.
 String? get bio;/// City / region the user is based in.
 String? get location;/// Row creation timestamp — set by Postgres default.
@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileModelCopyWith<ProfileModel> get copyWith => _$ProfileModelCopyWithImpl<ProfileModel>(this as ProfileModel, _$identity);

  /// Serializes this ProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.visionProfile, visionProfile) || other.visionProfile == visionProfile)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.username, username) || other.username == username)&&(identical(other.pronouns, pronouns) || other.pronouns == pronouns)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.location, location) || other.location == location)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,fullName,phone,visionProfile,avatarUrl,username,pronouns,bio,location,createdAt);

@override
String toString() {
  return 'ProfileModel(id: $id, role: $role, fullName: $fullName, phone: $phone, visionProfile: $visionProfile, avatarUrl: $avatarUrl, username: $username, pronouns: $pronouns, bio: $bio, location: $location, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ProfileModelCopyWith<$Res>  {
  factory $ProfileModelCopyWith(ProfileModel value, $Res Function(ProfileModel) _then) = _$ProfileModelCopyWithImpl;
@useResult
$Res call({
 String id,@_UserRoleConverter() UserRole role,@JsonKey(name: 'full_name') String? fullName, String? phone,@JsonKey(name: 'vision_profile')@_VisionProfileConverter() VisionProfile? visionProfile,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'handle') String? username, String? pronouns, String? bio, String? location,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$ProfileModelCopyWithImpl<$Res>
    implements $ProfileModelCopyWith<$Res> {
  _$ProfileModelCopyWithImpl(this._self, this._then);

  final ProfileModel _self;
  final $Res Function(ProfileModel) _then;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? fullName = freezed,Object? phone = freezed,Object? visionProfile = freezed,Object? avatarUrl = freezed,Object? username = freezed,Object? pronouns = freezed,Object? bio = freezed,Object? location = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,visionProfile: freezed == visionProfile ? _self.visionProfile : visionProfile // ignore: cast_nullable_to_non_nullable
as VisionProfile?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,pronouns: freezed == pronouns ? _self.pronouns : pronouns // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileModel].
extension ProfileModelPatterns on ProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _ProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @_UserRoleConverter()  UserRole role, @JsonKey(name: 'full_name')  String? fullName,  String? phone, @JsonKey(name: 'vision_profile')@_VisionProfileConverter()  VisionProfile? visionProfile, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'handle')  String? username,  String? pronouns,  String? bio,  String? location, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
return $default(_that.id,_that.role,_that.fullName,_that.phone,_that.visionProfile,_that.avatarUrl,_that.username,_that.pronouns,_that.bio,_that.location,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @_UserRoleConverter()  UserRole role, @JsonKey(name: 'full_name')  String? fullName,  String? phone, @JsonKey(name: 'vision_profile')@_VisionProfileConverter()  VisionProfile? visionProfile, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'handle')  String? username,  String? pronouns,  String? bio,  String? location, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ProfileModel():
return $default(_that.id,_that.role,_that.fullName,_that.phone,_that.visionProfile,_that.avatarUrl,_that.username,_that.pronouns,_that.bio,_that.location,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @_UserRoleConverter()  UserRole role, @JsonKey(name: 'full_name')  String? fullName,  String? phone, @JsonKey(name: 'vision_profile')@_VisionProfileConverter()  VisionProfile? visionProfile, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'handle')  String? username,  String? pronouns,  String? bio,  String? location, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
return $default(_that.id,_that.role,_that.fullName,_that.phone,_that.visionProfile,_that.avatarUrl,_that.username,_that.pronouns,_that.bio,_that.location,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileModel implements ProfileModel {
  const _ProfileModel({required this.id, @_UserRoleConverter() required this.role, @JsonKey(name: 'full_name') this.fullName, this.phone, @JsonKey(name: 'vision_profile')@_VisionProfileConverter() this.visionProfile, @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'handle') this.username, this.pronouns, this.bio, this.location, @JsonKey(name: 'created_at') required this.createdAt});
  factory _ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);

/// Primary key — matches `auth.users.id` (UUID).
@override final  String id;
/// User's role in the Opto ecosystem.
@override@_UserRoleConverter() final  UserRole role;
/// User's display name (nullable until set).
@override@JsonKey(name: 'full_name') final  String? fullName;
/// Contact phone number (nullable until set).
@override final  String? phone;
/// How the user perceives vision (nullable until set during onboarding).
@override@JsonKey(name: 'vision_profile')@_VisionProfileConverter() final  VisionProfile? visionProfile;
/// Supabase Storage public URL for the user's avatar (nullable).
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
/// The user's @handle (stored in DB as `handle`).
@override@JsonKey(name: 'handle') final  String? username;
/// The user's preferred pronouns (e.g. "she/her", "they/them").
@override final  String? pronouns;
/// Short bio shown on the community profile card.
@override final  String? bio;
/// City / region the user is based in.
@override final  String? location;
/// Row creation timestamp — set by Postgres default.
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileModelCopyWith<_ProfileModel> get copyWith => __$ProfileModelCopyWithImpl<_ProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.visionProfile, visionProfile) || other.visionProfile == visionProfile)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.username, username) || other.username == username)&&(identical(other.pronouns, pronouns) || other.pronouns == pronouns)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.location, location) || other.location == location)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,fullName,phone,visionProfile,avatarUrl,username,pronouns,bio,location,createdAt);

@override
String toString() {
  return 'ProfileModel(id: $id, role: $role, fullName: $fullName, phone: $phone, visionProfile: $visionProfile, avatarUrl: $avatarUrl, username: $username, pronouns: $pronouns, bio: $bio, location: $location, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProfileModelCopyWith<$Res> implements $ProfileModelCopyWith<$Res> {
  factory _$ProfileModelCopyWith(_ProfileModel value, $Res Function(_ProfileModel) _then) = __$ProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@_UserRoleConverter() UserRole role,@JsonKey(name: 'full_name') String? fullName, String? phone,@JsonKey(name: 'vision_profile')@_VisionProfileConverter() VisionProfile? visionProfile,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'handle') String? username, String? pronouns, String? bio, String? location,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$ProfileModelCopyWithImpl<$Res>
    implements _$ProfileModelCopyWith<$Res> {
  __$ProfileModelCopyWithImpl(this._self, this._then);

  final _ProfileModel _self;
  final $Res Function(_ProfileModel) _then;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? fullName = freezed,Object? phone = freezed,Object? visionProfile = freezed,Object? avatarUrl = freezed,Object? username = freezed,Object? pronouns = freezed,Object? bio = freezed,Object? location = freezed,Object? createdAt = null,}) {
  return _then(_ProfileModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,visionProfile: freezed == visionProfile ? _self.visionProfile : visionProfile // ignore: cast_nullable_to_non_nullable
as VisionProfile?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,pronouns: freezed == pronouns ? _self.pronouns : pronouns // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
