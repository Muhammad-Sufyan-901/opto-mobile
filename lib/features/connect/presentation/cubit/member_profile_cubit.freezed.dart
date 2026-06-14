// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_profile_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MemberProfileState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberProfileState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MemberProfileState()';
}


}

/// @nodoc
class $MemberProfileStateCopyWith<$Res>  {
$MemberProfileStateCopyWith(MemberProfileState _, $Res Function(MemberProfileState) __);
}


/// Adds pattern-matching-related methods to [MemberProfileState].
extension MemberProfileStatePatterns on MemberProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MemberProfileInitial value)?  initial,TResult Function( MemberProfileLoading value)?  loading,TResult Function( MemberProfileLoaded value)?  loaded,TResult Function( MemberProfileError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MemberProfileInitial() when initial != null:
return initial(_that);case MemberProfileLoading() when loading != null:
return loading(_that);case MemberProfileLoaded() when loaded != null:
return loaded(_that);case MemberProfileError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MemberProfileInitial value)  initial,required TResult Function( MemberProfileLoading value)  loading,required TResult Function( MemberProfileLoaded value)  loaded,required TResult Function( MemberProfileError value)  error,}){
final _that = this;
switch (_that) {
case MemberProfileInitial():
return initial(_that);case MemberProfileLoading():
return loading(_that);case MemberProfileLoaded():
return loaded(_that);case MemberProfileError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MemberProfileInitial value)?  initial,TResult? Function( MemberProfileLoading value)?  loading,TResult? Function( MemberProfileLoaded value)?  loaded,TResult? Function( MemberProfileError value)?  error,}){
final _that = this;
switch (_that) {
case MemberProfileInitial() when initial != null:
return initial(_that);case MemberProfileLoading() when loading != null:
return loading(_that);case MemberProfileLoaded() when loaded != null:
return loaded(_that);case MemberProfileError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( MemberProfileEntity profile,  List<PostEntity> contributions)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MemberProfileInitial() when initial != null:
return initial();case MemberProfileLoading() when loading != null:
return loading();case MemberProfileLoaded() when loaded != null:
return loaded(_that.profile,_that.contributions);case MemberProfileError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( MemberProfileEntity profile,  List<PostEntity> contributions)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case MemberProfileInitial():
return initial();case MemberProfileLoading():
return loading();case MemberProfileLoaded():
return loaded(_that.profile,_that.contributions);case MemberProfileError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( MemberProfileEntity profile,  List<PostEntity> contributions)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case MemberProfileInitial() when initial != null:
return initial();case MemberProfileLoading() when loading != null:
return loading();case MemberProfileLoaded() when loaded != null:
return loaded(_that.profile,_that.contributions);case MemberProfileError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class MemberProfileInitial implements MemberProfileState {
  const MemberProfileInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberProfileInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MemberProfileState.initial()';
}


}




/// @nodoc


class MemberProfileLoading implements MemberProfileState {
  const MemberProfileLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberProfileLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MemberProfileState.loading()';
}


}




/// @nodoc


class MemberProfileLoaded implements MemberProfileState {
  const MemberProfileLoaded({required this.profile, required final  List<PostEntity> contributions}): _contributions = contributions;
  

 final  MemberProfileEntity profile;
 final  List<PostEntity> _contributions;
 List<PostEntity> get contributions {
  if (_contributions is EqualUnmodifiableListView) return _contributions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contributions);
}


/// Create a copy of MemberProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberProfileLoadedCopyWith<MemberProfileLoaded> get copyWith => _$MemberProfileLoadedCopyWithImpl<MemberProfileLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberProfileLoaded&&(identical(other.profile, profile) || other.profile == profile)&&const DeepCollectionEquality().equals(other._contributions, _contributions));
}


@override
int get hashCode => Object.hash(runtimeType,profile,const DeepCollectionEquality().hash(_contributions));

@override
String toString() {
  return 'MemberProfileState.loaded(profile: $profile, contributions: $contributions)';
}


}

/// @nodoc
abstract mixin class $MemberProfileLoadedCopyWith<$Res> implements $MemberProfileStateCopyWith<$Res> {
  factory $MemberProfileLoadedCopyWith(MemberProfileLoaded value, $Res Function(MemberProfileLoaded) _then) = _$MemberProfileLoadedCopyWithImpl;
@useResult
$Res call({
 MemberProfileEntity profile, List<PostEntity> contributions
});




}
/// @nodoc
class _$MemberProfileLoadedCopyWithImpl<$Res>
    implements $MemberProfileLoadedCopyWith<$Res> {
  _$MemberProfileLoadedCopyWithImpl(this._self, this._then);

  final MemberProfileLoaded _self;
  final $Res Function(MemberProfileLoaded) _then;

/// Create a copy of MemberProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? profile = null,Object? contributions = null,}) {
  return _then(MemberProfileLoaded(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as MemberProfileEntity,contributions: null == contributions ? _self._contributions : contributions // ignore: cast_nullable_to_non_nullable
as List<PostEntity>,
  ));
}


}

/// @nodoc


class MemberProfileError implements MemberProfileState {
  const MemberProfileError({required this.message});
  

 final  String message;

/// Create a copy of MemberProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberProfileErrorCopyWith<MemberProfileError> get copyWith => _$MemberProfileErrorCopyWithImpl<MemberProfileError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberProfileError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'MemberProfileState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $MemberProfileErrorCopyWith<$Res> implements $MemberProfileStateCopyWith<$Res> {
  factory $MemberProfileErrorCopyWith(MemberProfileError value, $Res Function(MemberProfileError) _then) = _$MemberProfileErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$MemberProfileErrorCopyWithImpl<$Res>
    implements $MemberProfileErrorCopyWith<$Res> {
  _$MemberProfileErrorCopyWithImpl(this._self, this._then);

  final MemberProfileError _self;
  final $Res Function(MemberProfileError) _then;

/// Create a copy of MemberProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(MemberProfileError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
