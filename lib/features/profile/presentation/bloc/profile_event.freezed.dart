// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileEvent()';
}


}

/// @nodoc
class $ProfileEventCopyWith<$Res>  {
$ProfileEventCopyWith(ProfileEvent _, $Res Function(ProfileEvent) __);
}


/// Adds pattern-matching-related methods to [ProfileEvent].
extension ProfileEventPatterns on ProfileEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadProfile value)?  loadProfile,TResult Function( UpdateProfile value)?  updateProfile,TResult Function( ChangeAvatar value)?  changeAvatar,TResult Function( UpdateVisionProfile value)?  updateVisionProfile,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadProfile() when loadProfile != null:
return loadProfile(_that);case UpdateProfile() when updateProfile != null:
return updateProfile(_that);case ChangeAvatar() when changeAvatar != null:
return changeAvatar(_that);case UpdateVisionProfile() when updateVisionProfile != null:
return updateVisionProfile(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadProfile value)  loadProfile,required TResult Function( UpdateProfile value)  updateProfile,required TResult Function( ChangeAvatar value)  changeAvatar,required TResult Function( UpdateVisionProfile value)  updateVisionProfile,}){
final _that = this;
switch (_that) {
case LoadProfile():
return loadProfile(_that);case UpdateProfile():
return updateProfile(_that);case ChangeAvatar():
return changeAvatar(_that);case UpdateVisionProfile():
return updateVisionProfile(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadProfile value)?  loadProfile,TResult? Function( UpdateProfile value)?  updateProfile,TResult? Function( ChangeAvatar value)?  changeAvatar,TResult? Function( UpdateVisionProfile value)?  updateVisionProfile,}){
final _that = this;
switch (_that) {
case LoadProfile() when loadProfile != null:
return loadProfile(_that);case UpdateProfile() when updateProfile != null:
return updateProfile(_that);case ChangeAvatar() when changeAvatar != null:
return changeAvatar(_that);case UpdateVisionProfile() when updateVisionProfile != null:
return updateVisionProfile(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String userId)?  loadProfile,TResult Function( String userId,  String? fullName,  String? phone,  VisionProfile? visionProfile,  String? avatarUrl,  String? username,  String? pronouns,  String? bio,  String? location)?  updateProfile,TResult Function( String userId,  String localPath)?  changeAvatar,TResult Function( VisionProfile profile)?  updateVisionProfile,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadProfile() when loadProfile != null:
return loadProfile(_that.userId);case UpdateProfile() when updateProfile != null:
return updateProfile(_that.userId,_that.fullName,_that.phone,_that.visionProfile,_that.avatarUrl,_that.username,_that.pronouns,_that.bio,_that.location);case ChangeAvatar() when changeAvatar != null:
return changeAvatar(_that.userId,_that.localPath);case UpdateVisionProfile() when updateVisionProfile != null:
return updateVisionProfile(_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String userId)  loadProfile,required TResult Function( String userId,  String? fullName,  String? phone,  VisionProfile? visionProfile,  String? avatarUrl,  String? username,  String? pronouns,  String? bio,  String? location)  updateProfile,required TResult Function( String userId,  String localPath)  changeAvatar,required TResult Function( VisionProfile profile)  updateVisionProfile,}) {final _that = this;
switch (_that) {
case LoadProfile():
return loadProfile(_that.userId);case UpdateProfile():
return updateProfile(_that.userId,_that.fullName,_that.phone,_that.visionProfile,_that.avatarUrl,_that.username,_that.pronouns,_that.bio,_that.location);case ChangeAvatar():
return changeAvatar(_that.userId,_that.localPath);case UpdateVisionProfile():
return updateVisionProfile(_that.profile);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String userId)?  loadProfile,TResult? Function( String userId,  String? fullName,  String? phone,  VisionProfile? visionProfile,  String? avatarUrl,  String? username,  String? pronouns,  String? bio,  String? location)?  updateProfile,TResult? Function( String userId,  String localPath)?  changeAvatar,TResult? Function( VisionProfile profile)?  updateVisionProfile,}) {final _that = this;
switch (_that) {
case LoadProfile() when loadProfile != null:
return loadProfile(_that.userId);case UpdateProfile() when updateProfile != null:
return updateProfile(_that.userId,_that.fullName,_that.phone,_that.visionProfile,_that.avatarUrl,_that.username,_that.pronouns,_that.bio,_that.location);case ChangeAvatar() when changeAvatar != null:
return changeAvatar(_that.userId,_that.localPath);case UpdateVisionProfile() when updateVisionProfile != null:
return updateVisionProfile(_that.profile);case _:
  return null;

}
}

}

/// @nodoc


class LoadProfile implements ProfileEvent {
  const LoadProfile({required this.userId});
  

 final  String userId;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadProfileCopyWith<LoadProfile> get copyWith => _$LoadProfileCopyWithImpl<LoadProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadProfile&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'ProfileEvent.loadProfile(userId: $userId)';
}


}

/// @nodoc
abstract mixin class $LoadProfileCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory $LoadProfileCopyWith(LoadProfile value, $Res Function(LoadProfile) _then) = _$LoadProfileCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class _$LoadProfileCopyWithImpl<$Res>
    implements $LoadProfileCopyWith<$Res> {
  _$LoadProfileCopyWithImpl(this._self, this._then);

  final LoadProfile _self;
  final $Res Function(LoadProfile) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(LoadProfile(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UpdateProfile implements ProfileEvent {
  const UpdateProfile({required this.userId, this.fullName, this.phone, this.visionProfile, this.avatarUrl, this.username, this.pronouns, this.bio, this.location});
  

 final  String userId;
 final  String? fullName;
 final  String? phone;
 final  VisionProfile? visionProfile;
 final  String? avatarUrl;
 final  String? username;
 final  String? pronouns;
 final  String? bio;
 final  String? location;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProfileCopyWith<UpdateProfile> get copyWith => _$UpdateProfileCopyWithImpl<UpdateProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProfile&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.visionProfile, visionProfile) || other.visionProfile == visionProfile)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.username, username) || other.username == username)&&(identical(other.pronouns, pronouns) || other.pronouns == pronouns)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.location, location) || other.location == location));
}


@override
int get hashCode => Object.hash(runtimeType,userId,fullName,phone,visionProfile,avatarUrl,username,pronouns,bio,location);

@override
String toString() {
  return 'ProfileEvent.updateProfile(userId: $userId, fullName: $fullName, phone: $phone, visionProfile: $visionProfile, avatarUrl: $avatarUrl, username: $username, pronouns: $pronouns, bio: $bio, location: $location)';
}


}

/// @nodoc
abstract mixin class $UpdateProfileCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory $UpdateProfileCopyWith(UpdateProfile value, $Res Function(UpdateProfile) _then) = _$UpdateProfileCopyWithImpl;
@useResult
$Res call({
 String userId, String? fullName, String? phone, VisionProfile? visionProfile, String? avatarUrl, String? username, String? pronouns, String? bio, String? location
});




}
/// @nodoc
class _$UpdateProfileCopyWithImpl<$Res>
    implements $UpdateProfileCopyWith<$Res> {
  _$UpdateProfileCopyWithImpl(this._self, this._then);

  final UpdateProfile _self;
  final $Res Function(UpdateProfile) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? fullName = freezed,Object? phone = freezed,Object? visionProfile = freezed,Object? avatarUrl = freezed,Object? username = freezed,Object? pronouns = freezed,Object? bio = freezed,Object? location = freezed,}) {
  return _then(UpdateProfile(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,visionProfile: freezed == visionProfile ? _self.visionProfile : visionProfile // ignore: cast_nullable_to_non_nullable
as VisionProfile?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,pronouns: freezed == pronouns ? _self.pronouns : pronouns // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ChangeAvatar implements ProfileEvent {
  const ChangeAvatar({required this.userId, required this.localPath});
  

 final  String userId;
 final  String localPath;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeAvatarCopyWith<ChangeAvatar> get copyWith => _$ChangeAvatarCopyWithImpl<ChangeAvatar>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeAvatar&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.localPath, localPath) || other.localPath == localPath));
}


@override
int get hashCode => Object.hash(runtimeType,userId,localPath);

@override
String toString() {
  return 'ProfileEvent.changeAvatar(userId: $userId, localPath: $localPath)';
}


}

/// @nodoc
abstract mixin class $ChangeAvatarCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory $ChangeAvatarCopyWith(ChangeAvatar value, $Res Function(ChangeAvatar) _then) = _$ChangeAvatarCopyWithImpl;
@useResult
$Res call({
 String userId, String localPath
});




}
/// @nodoc
class _$ChangeAvatarCopyWithImpl<$Res>
    implements $ChangeAvatarCopyWith<$Res> {
  _$ChangeAvatarCopyWithImpl(this._self, this._then);

  final ChangeAvatar _self;
  final $Res Function(ChangeAvatar) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? localPath = null,}) {
  return _then(ChangeAvatar(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,localPath: null == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UpdateVisionProfile implements ProfileEvent {
  const UpdateVisionProfile({required this.profile});
  

 final  VisionProfile profile;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateVisionProfileCopyWith<UpdateVisionProfile> get copyWith => _$UpdateVisionProfileCopyWithImpl<UpdateVisionProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateVisionProfile&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode => Object.hash(runtimeType,profile);

@override
String toString() {
  return 'ProfileEvent.updateVisionProfile(profile: $profile)';
}


}

/// @nodoc
abstract mixin class $UpdateVisionProfileCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory $UpdateVisionProfileCopyWith(UpdateVisionProfile value, $Res Function(UpdateVisionProfile) _then) = _$UpdateVisionProfileCopyWithImpl;
@useResult
$Res call({
 VisionProfile profile
});




}
/// @nodoc
class _$UpdateVisionProfileCopyWithImpl<$Res>
    implements $UpdateVisionProfileCopyWith<$Res> {
  _$UpdateVisionProfileCopyWithImpl(this._self, this._then);

  final UpdateVisionProfile _self;
  final $Res Function(UpdateVisionProfile) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? profile = null,}) {
  return _then(UpdateVisionProfile(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as VisionProfile,
  ));
}


}

// dart format on
