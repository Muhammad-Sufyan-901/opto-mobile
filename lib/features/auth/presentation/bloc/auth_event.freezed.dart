// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SignInWithEmailPassword value)?  signInWithEmailPassword,TResult Function( SignUp value)?  signUp,TResult Function( RequestOtp value)?  requestOtp,TResult Function( VerifyOtp value)?  verifyOtp,TResult Function( SignOut value)?  signOut,TResult Function( AuthStateChanged value)?  authStateChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SignInWithEmailPassword() when signInWithEmailPassword != null:
return signInWithEmailPassword(_that);case SignUp() when signUp != null:
return signUp(_that);case RequestOtp() when requestOtp != null:
return requestOtp(_that);case VerifyOtp() when verifyOtp != null:
return verifyOtp(_that);case SignOut() when signOut != null:
return signOut(_that);case AuthStateChanged() when authStateChanged != null:
return authStateChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SignInWithEmailPassword value)  signInWithEmailPassword,required TResult Function( SignUp value)  signUp,required TResult Function( RequestOtp value)  requestOtp,required TResult Function( VerifyOtp value)  verifyOtp,required TResult Function( SignOut value)  signOut,required TResult Function( AuthStateChanged value)  authStateChanged,}){
final _that = this;
switch (_that) {
case SignInWithEmailPassword():
return signInWithEmailPassword(_that);case SignUp():
return signUp(_that);case RequestOtp():
return requestOtp(_that);case VerifyOtp():
return verifyOtp(_that);case SignOut():
return signOut(_that);case AuthStateChanged():
return authStateChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SignInWithEmailPassword value)?  signInWithEmailPassword,TResult? Function( SignUp value)?  signUp,TResult? Function( RequestOtp value)?  requestOtp,TResult? Function( VerifyOtp value)?  verifyOtp,TResult? Function( SignOut value)?  signOut,TResult? Function( AuthStateChanged value)?  authStateChanged,}){
final _that = this;
switch (_that) {
case SignInWithEmailPassword() when signInWithEmailPassword != null:
return signInWithEmailPassword(_that);case SignUp() when signUp != null:
return signUp(_that);case RequestOtp() when requestOtp != null:
return requestOtp(_that);case VerifyOtp() when verifyOtp != null:
return verifyOtp(_that);case SignOut() when signOut != null:
return signOut(_that);case AuthStateChanged() when authStateChanged != null:
return authStateChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String email,  String password)?  signInWithEmailPassword,TResult Function( String email,  String password,  String? fullName)?  signUp,TResult Function( String phone)?  requestOtp,TResult Function( String phone,  String otp)?  verifyOtp,TResult Function()?  signOut,TResult Function( bool isAuthenticated)?  authStateChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SignInWithEmailPassword() when signInWithEmailPassword != null:
return signInWithEmailPassword(_that.email,_that.password);case SignUp() when signUp != null:
return signUp(_that.email,_that.password,_that.fullName);case RequestOtp() when requestOtp != null:
return requestOtp(_that.phone);case VerifyOtp() when verifyOtp != null:
return verifyOtp(_that.phone,_that.otp);case SignOut() when signOut != null:
return signOut();case AuthStateChanged() when authStateChanged != null:
return authStateChanged(_that.isAuthenticated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String email,  String password)  signInWithEmailPassword,required TResult Function( String email,  String password,  String? fullName)  signUp,required TResult Function( String phone)  requestOtp,required TResult Function( String phone,  String otp)  verifyOtp,required TResult Function()  signOut,required TResult Function( bool isAuthenticated)  authStateChanged,}) {final _that = this;
switch (_that) {
case SignInWithEmailPassword():
return signInWithEmailPassword(_that.email,_that.password);case SignUp():
return signUp(_that.email,_that.password,_that.fullName);case RequestOtp():
return requestOtp(_that.phone);case VerifyOtp():
return verifyOtp(_that.phone,_that.otp);case SignOut():
return signOut();case AuthStateChanged():
return authStateChanged(_that.isAuthenticated);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String email,  String password)?  signInWithEmailPassword,TResult? Function( String email,  String password,  String? fullName)?  signUp,TResult? Function( String phone)?  requestOtp,TResult? Function( String phone,  String otp)?  verifyOtp,TResult? Function()?  signOut,TResult? Function( bool isAuthenticated)?  authStateChanged,}) {final _that = this;
switch (_that) {
case SignInWithEmailPassword() when signInWithEmailPassword != null:
return signInWithEmailPassword(_that.email,_that.password);case SignUp() when signUp != null:
return signUp(_that.email,_that.password,_that.fullName);case RequestOtp() when requestOtp != null:
return requestOtp(_that.phone);case VerifyOtp() when verifyOtp != null:
return verifyOtp(_that.phone,_that.otp);case SignOut() when signOut != null:
return signOut();case AuthStateChanged() when authStateChanged != null:
return authStateChanged(_that.isAuthenticated);case _:
  return null;

}
}

}

/// @nodoc


class SignInWithEmailPassword implements AuthEvent {
  const SignInWithEmailPassword({required this.email, required this.password});
  

 final  String email;
 final  String password;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignInWithEmailPasswordCopyWith<SignInWithEmailPassword> get copyWith => _$SignInWithEmailPasswordCopyWithImpl<SignInWithEmailPassword>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignInWithEmailPassword&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'AuthEvent.signInWithEmailPassword(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $SignInWithEmailPasswordCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $SignInWithEmailPasswordCopyWith(SignInWithEmailPassword value, $Res Function(SignInWithEmailPassword) _then) = _$SignInWithEmailPasswordCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$SignInWithEmailPasswordCopyWithImpl<$Res>
    implements $SignInWithEmailPasswordCopyWith<$Res> {
  _$SignInWithEmailPasswordCopyWithImpl(this._self, this._then);

  final SignInWithEmailPassword _self;
  final $Res Function(SignInWithEmailPassword) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(SignInWithEmailPassword(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SignUp implements AuthEvent {
  const SignUp({required this.email, required this.password, this.fullName});
  

 final  String email;
 final  String password;
 final  String? fullName;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignUpCopyWith<SignUp> get copyWith => _$SignUpCopyWithImpl<SignUp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUp&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.fullName, fullName) || other.fullName == fullName));
}


@override
int get hashCode => Object.hash(runtimeType,email,password,fullName);

@override
String toString() {
  return 'AuthEvent.signUp(email: $email, password: $password, fullName: $fullName)';
}


}

/// @nodoc
abstract mixin class $SignUpCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $SignUpCopyWith(SignUp value, $Res Function(SignUp) _then) = _$SignUpCopyWithImpl;
@useResult
$Res call({
 String email, String password, String? fullName
});




}
/// @nodoc
class _$SignUpCopyWithImpl<$Res>
    implements $SignUpCopyWith<$Res> {
  _$SignUpCopyWithImpl(this._self, this._then);

  final SignUp _self;
  final $Res Function(SignUp) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,Object? fullName = freezed,}) {
  return _then(SignUp(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class RequestOtp implements AuthEvent {
  const RequestOtp({required this.phone});
  

 final  String phone;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestOtpCopyWith<RequestOtp> get copyWith => _$RequestOtpCopyWithImpl<RequestOtp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestOtp&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode => Object.hash(runtimeType,phone);

@override
String toString() {
  return 'AuthEvent.requestOtp(phone: $phone)';
}


}

/// @nodoc
abstract mixin class $RequestOtpCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $RequestOtpCopyWith(RequestOtp value, $Res Function(RequestOtp) _then) = _$RequestOtpCopyWithImpl;
@useResult
$Res call({
 String phone
});




}
/// @nodoc
class _$RequestOtpCopyWithImpl<$Res>
    implements $RequestOtpCopyWith<$Res> {
  _$RequestOtpCopyWithImpl(this._self, this._then);

  final RequestOtp _self;
  final $Res Function(RequestOtp) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phone = null,}) {
  return _then(RequestOtp(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class VerifyOtp implements AuthEvent {
  const VerifyOtp({required this.phone, required this.otp});
  

 final  String phone;
 final  String otp;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyOtpCopyWith<VerifyOtp> get copyWith => _$VerifyOtpCopyWithImpl<VerifyOtp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyOtp&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.otp, otp) || other.otp == otp));
}


@override
int get hashCode => Object.hash(runtimeType,phone,otp);

@override
String toString() {
  return 'AuthEvent.verifyOtp(phone: $phone, otp: $otp)';
}


}

/// @nodoc
abstract mixin class $VerifyOtpCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $VerifyOtpCopyWith(VerifyOtp value, $Res Function(VerifyOtp) _then) = _$VerifyOtpCopyWithImpl;
@useResult
$Res call({
 String phone, String otp
});




}
/// @nodoc
class _$VerifyOtpCopyWithImpl<$Res>
    implements $VerifyOtpCopyWith<$Res> {
  _$VerifyOtpCopyWithImpl(this._self, this._then);

  final VerifyOtp _self;
  final $Res Function(VerifyOtp) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phone = null,Object? otp = null,}) {
  return _then(VerifyOtp(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,otp: null == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SignOut implements AuthEvent {
  const SignOut();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignOut);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.signOut()';
}


}




/// @nodoc


class AuthStateChanged implements AuthEvent {
  const AuthStateChanged({required this.isAuthenticated});
  

 final  bool isAuthenticated;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateChangedCopyWith<AuthStateChanged> get copyWith => _$AuthStateChangedCopyWithImpl<AuthStateChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStateChanged&&(identical(other.isAuthenticated, isAuthenticated) || other.isAuthenticated == isAuthenticated));
}


@override
int get hashCode => Object.hash(runtimeType,isAuthenticated);

@override
String toString() {
  return 'AuthEvent.authStateChanged(isAuthenticated: $isAuthenticated)';
}


}

/// @nodoc
abstract mixin class $AuthStateChangedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthStateChangedCopyWith(AuthStateChanged value, $Res Function(AuthStateChanged) _then) = _$AuthStateChangedCopyWithImpl;
@useResult
$Res call({
 bool isAuthenticated
});




}
/// @nodoc
class _$AuthStateChangedCopyWithImpl<$Res>
    implements $AuthStateChangedCopyWith<$Res> {
  _$AuthStateChangedCopyWithImpl(this._self, this._then);

  final AuthStateChanged _self;
  final $Res Function(AuthStateChanged) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isAuthenticated = null,}) {
  return _then(AuthStateChanged(
isAuthenticated: null == isAuthenticated ? _self.isAuthenticated : isAuthenticated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
