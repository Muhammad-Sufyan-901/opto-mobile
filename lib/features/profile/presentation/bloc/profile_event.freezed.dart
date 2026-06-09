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

 String get userId;
/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileEventCopyWith<ProfileEvent> get copyWith => _$ProfileEventCopyWithImpl<ProfileEvent>(this as ProfileEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileEvent&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'ProfileEvent(userId: $userId)';
}


}

/// @nodoc
abstract mixin class $ProfileEventCopyWith<$Res>  {
  factory $ProfileEventCopyWith(ProfileEvent value, $Res Function(ProfileEvent) _then) = _$ProfileEventCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class _$ProfileEventCopyWithImpl<$Res>
    implements $ProfileEventCopyWith<$Res> {
  _$ProfileEventCopyWithImpl(this._self, this._then);

  final ProfileEvent _self;
  final $Res Function(ProfileEvent) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadProfile value)?  loadProfile,TResult Function( UpdateProfile value)?  updateProfile,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadProfile() when loadProfile != null:
return loadProfile(_that);case UpdateProfile() when updateProfile != null:
return updateProfile(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadProfile value)  loadProfile,required TResult Function( UpdateProfile value)  updateProfile,}){
final _that = this;
switch (_that) {
case LoadProfile():
return loadProfile(_that);case UpdateProfile():
return updateProfile(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadProfile value)?  loadProfile,TResult? Function( UpdateProfile value)?  updateProfile,}){
final _that = this;
switch (_that) {
case LoadProfile() when loadProfile != null:
return loadProfile(_that);case UpdateProfile() when updateProfile != null:
return updateProfile(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String userId)?  loadProfile,TResult Function( String userId,  String? fullName,  String? phone,  VisionProfile? visionProfile,  String? avatarUrl)?  updateProfile,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadProfile() when loadProfile != null:
return loadProfile(_that.userId);case UpdateProfile() when updateProfile != null:
return updateProfile(_that.userId,_that.fullName,_that.phone,_that.visionProfile,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String userId)  loadProfile,required TResult Function( String userId,  String? fullName,  String? phone,  VisionProfile? visionProfile,  String? avatarUrl)  updateProfile,}) {final _that = this;
switch (_that) {
case LoadProfile():
return loadProfile(_that.userId);case UpdateProfile():
return updateProfile(_that.userId,_that.fullName,_that.phone,_that.visionProfile,_that.avatarUrl);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String userId)?  loadProfile,TResult? Function( String userId,  String? fullName,  String? phone,  VisionProfile? visionProfile,  String? avatarUrl)?  updateProfile,}) {final _that = this;
switch (_that) {
case LoadProfile() when loadProfile != null:
return loadProfile(_that.userId);case UpdateProfile() when updateProfile != null:
return updateProfile(_that.userId,_that.fullName,_that.phone,_that.visionProfile,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc


class LoadProfile implements ProfileEvent {
  const LoadProfile({required this.userId});
  

@override final  String userId;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
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
@override @useResult
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
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(LoadProfile(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UpdateProfile implements ProfileEvent {
  const UpdateProfile({required this.userId, this.fullName, this.phone, this.visionProfile, this.avatarUrl});
  

@override final  String userId;
 final  String? fullName;
 final  String? phone;
 final  VisionProfile? visionProfile;
 final  String? avatarUrl;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProfileCopyWith<UpdateProfile> get copyWith => _$UpdateProfileCopyWithImpl<UpdateProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProfile&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.visionProfile, visionProfile) || other.visionProfile == visionProfile)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}


@override
int get hashCode => Object.hash(runtimeType,userId,fullName,phone,visionProfile,avatarUrl);

@override
String toString() {
  return 'ProfileEvent.updateProfile(userId: $userId, fullName: $fullName, phone: $phone, visionProfile: $visionProfile, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $UpdateProfileCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory $UpdateProfileCopyWith(UpdateProfile value, $Res Function(UpdateProfile) _then) = _$UpdateProfileCopyWithImpl;
@override @useResult
$Res call({
 String userId, String? fullName, String? phone, VisionProfile? visionProfile, String? avatarUrl
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
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? fullName = freezed,Object? phone = freezed,Object? visionProfile = freezed,Object? avatarUrl = freezed,}) {
  return _then(UpdateProfile(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,visionProfile: freezed == visionProfile ? _self.visionProfile : visionProfile // ignore: cast_nullable_to_non_nullable
as VisionProfile?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
