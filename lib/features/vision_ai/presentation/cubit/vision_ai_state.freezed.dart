// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vision_ai_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VisionAiState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisionAiState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VisionAiState()';
}


}

/// @nodoc
class $VisionAiStateCopyWith<$Res>  {
$VisionAiStateCopyWith(VisionAiState _, $Res Function(VisionAiState) __);
}


/// Adds pattern-matching-related methods to [VisionAiState].
extension VisionAiStatePatterns on VisionAiState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( VisionAiInitializing value)?  initializing,TResult Function( VisionAiPermissionDenied value)?  permissionDenied,TResult Function( VisionAiReady value)?  ready,TResult Function( VisionAiCapturing value)?  capturing,TResult Function( VisionAiAnalyzing value)?  analyzing,TResult Function( VisionAiResult value)?  result,TResult Function( VisionAiOfflineFallback value)?  offlineFallback,TResult Function( VisionAiConsentRequired value)?  consentRequired,TResult Function( VisionAiError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case VisionAiInitializing() when initializing != null:
return initializing(_that);case VisionAiPermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case VisionAiReady() when ready != null:
return ready(_that);case VisionAiCapturing() when capturing != null:
return capturing(_that);case VisionAiAnalyzing() when analyzing != null:
return analyzing(_that);case VisionAiResult() when result != null:
return result(_that);case VisionAiOfflineFallback() when offlineFallback != null:
return offlineFallback(_that);case VisionAiConsentRequired() when consentRequired != null:
return consentRequired(_that);case VisionAiError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( VisionAiInitializing value)  initializing,required TResult Function( VisionAiPermissionDenied value)  permissionDenied,required TResult Function( VisionAiReady value)  ready,required TResult Function( VisionAiCapturing value)  capturing,required TResult Function( VisionAiAnalyzing value)  analyzing,required TResult Function( VisionAiResult value)  result,required TResult Function( VisionAiOfflineFallback value)  offlineFallback,required TResult Function( VisionAiConsentRequired value)  consentRequired,required TResult Function( VisionAiError value)  error,}){
final _that = this;
switch (_that) {
case VisionAiInitializing():
return initializing(_that);case VisionAiPermissionDenied():
return permissionDenied(_that);case VisionAiReady():
return ready(_that);case VisionAiCapturing():
return capturing(_that);case VisionAiAnalyzing():
return analyzing(_that);case VisionAiResult():
return result(_that);case VisionAiOfflineFallback():
return offlineFallback(_that);case VisionAiConsentRequired():
return consentRequired(_that);case VisionAiError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( VisionAiInitializing value)?  initializing,TResult? Function( VisionAiPermissionDenied value)?  permissionDenied,TResult? Function( VisionAiReady value)?  ready,TResult? Function( VisionAiCapturing value)?  capturing,TResult? Function( VisionAiAnalyzing value)?  analyzing,TResult? Function( VisionAiResult value)?  result,TResult? Function( VisionAiOfflineFallback value)?  offlineFallback,TResult? Function( VisionAiConsentRequired value)?  consentRequired,TResult? Function( VisionAiError value)?  error,}){
final _that = this;
switch (_that) {
case VisionAiInitializing() when initializing != null:
return initializing(_that);case VisionAiPermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case VisionAiReady() when ready != null:
return ready(_that);case VisionAiCapturing() when capturing != null:
return capturing(_that);case VisionAiAnalyzing() when analyzing != null:
return analyzing(_that);case VisionAiResult() when result != null:
return result(_that);case VisionAiOfflineFallback() when offlineFallback != null:
return offlineFallback(_that);case VisionAiConsentRequired() when consentRequired != null:
return consentRequired(_that);case VisionAiError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initializing,TResult Function()?  permissionDenied,TResult Function( VisionMode mode)?  ready,TResult Function( VisionMode mode)?  capturing,TResult Function( VisionMode mode)?  analyzing,TResult Function( VisionResult result,  VisionMode mode)?  result,TResult Function( VisionResult result,  VisionMode mode)?  offlineFallback,TResult Function( VisionMode mode)?  consentRequired,TResult Function( String message,  VisionMode mode)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case VisionAiInitializing() when initializing != null:
return initializing();case VisionAiPermissionDenied() when permissionDenied != null:
return permissionDenied();case VisionAiReady() when ready != null:
return ready(_that.mode);case VisionAiCapturing() when capturing != null:
return capturing(_that.mode);case VisionAiAnalyzing() when analyzing != null:
return analyzing(_that.mode);case VisionAiResult() when result != null:
return result(_that.result,_that.mode);case VisionAiOfflineFallback() when offlineFallback != null:
return offlineFallback(_that.result,_that.mode);case VisionAiConsentRequired() when consentRequired != null:
return consentRequired(_that.mode);case VisionAiError() when error != null:
return error(_that.message,_that.mode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initializing,required TResult Function()  permissionDenied,required TResult Function( VisionMode mode)  ready,required TResult Function( VisionMode mode)  capturing,required TResult Function( VisionMode mode)  analyzing,required TResult Function( VisionResult result,  VisionMode mode)  result,required TResult Function( VisionResult result,  VisionMode mode)  offlineFallback,required TResult Function( VisionMode mode)  consentRequired,required TResult Function( String message,  VisionMode mode)  error,}) {final _that = this;
switch (_that) {
case VisionAiInitializing():
return initializing();case VisionAiPermissionDenied():
return permissionDenied();case VisionAiReady():
return ready(_that.mode);case VisionAiCapturing():
return capturing(_that.mode);case VisionAiAnalyzing():
return analyzing(_that.mode);case VisionAiResult():
return result(_that.result,_that.mode);case VisionAiOfflineFallback():
return offlineFallback(_that.result,_that.mode);case VisionAiConsentRequired():
return consentRequired(_that.mode);case VisionAiError():
return error(_that.message,_that.mode);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initializing,TResult? Function()?  permissionDenied,TResult? Function( VisionMode mode)?  ready,TResult? Function( VisionMode mode)?  capturing,TResult? Function( VisionMode mode)?  analyzing,TResult? Function( VisionResult result,  VisionMode mode)?  result,TResult? Function( VisionResult result,  VisionMode mode)?  offlineFallback,TResult? Function( VisionMode mode)?  consentRequired,TResult? Function( String message,  VisionMode mode)?  error,}) {final _that = this;
switch (_that) {
case VisionAiInitializing() when initializing != null:
return initializing();case VisionAiPermissionDenied() when permissionDenied != null:
return permissionDenied();case VisionAiReady() when ready != null:
return ready(_that.mode);case VisionAiCapturing() when capturing != null:
return capturing(_that.mode);case VisionAiAnalyzing() when analyzing != null:
return analyzing(_that.mode);case VisionAiResult() when result != null:
return result(_that.result,_that.mode);case VisionAiOfflineFallback() when offlineFallback != null:
return offlineFallback(_that.result,_that.mode);case VisionAiConsentRequired() when consentRequired != null:
return consentRequired(_that.mode);case VisionAiError() when error != null:
return error(_that.message,_that.mode);case _:
  return null;

}
}

}

/// @nodoc


class VisionAiInitializing implements VisionAiState {
  const VisionAiInitializing();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisionAiInitializing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VisionAiState.initializing()';
}


}




/// @nodoc


class VisionAiPermissionDenied implements VisionAiState {
  const VisionAiPermissionDenied();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisionAiPermissionDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VisionAiState.permissionDenied()';
}


}




/// @nodoc


class VisionAiReady implements VisionAiState {
  const VisionAiReady({this.mode = VisionMode.readText});
  

@JsonKey() final  VisionMode mode;

/// Create a copy of VisionAiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisionAiReadyCopyWith<VisionAiReady> get copyWith => _$VisionAiReadyCopyWithImpl<VisionAiReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisionAiReady&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'VisionAiState.ready(mode: $mode)';
}


}

/// @nodoc
abstract mixin class $VisionAiReadyCopyWith<$Res> implements $VisionAiStateCopyWith<$Res> {
  factory $VisionAiReadyCopyWith(VisionAiReady value, $Res Function(VisionAiReady) _then) = _$VisionAiReadyCopyWithImpl;
@useResult
$Res call({
 VisionMode mode
});




}
/// @nodoc
class _$VisionAiReadyCopyWithImpl<$Res>
    implements $VisionAiReadyCopyWith<$Res> {
  _$VisionAiReadyCopyWithImpl(this._self, this._then);

  final VisionAiReady _self;
  final $Res Function(VisionAiReady) _then;

/// Create a copy of VisionAiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mode = null,}) {
  return _then(VisionAiReady(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as VisionMode,
  ));
}


}

/// @nodoc


class VisionAiCapturing implements VisionAiState {
  const VisionAiCapturing({required this.mode});
  

 final  VisionMode mode;

/// Create a copy of VisionAiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisionAiCapturingCopyWith<VisionAiCapturing> get copyWith => _$VisionAiCapturingCopyWithImpl<VisionAiCapturing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisionAiCapturing&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'VisionAiState.capturing(mode: $mode)';
}


}

/// @nodoc
abstract mixin class $VisionAiCapturingCopyWith<$Res> implements $VisionAiStateCopyWith<$Res> {
  factory $VisionAiCapturingCopyWith(VisionAiCapturing value, $Res Function(VisionAiCapturing) _then) = _$VisionAiCapturingCopyWithImpl;
@useResult
$Res call({
 VisionMode mode
});




}
/// @nodoc
class _$VisionAiCapturingCopyWithImpl<$Res>
    implements $VisionAiCapturingCopyWith<$Res> {
  _$VisionAiCapturingCopyWithImpl(this._self, this._then);

  final VisionAiCapturing _self;
  final $Res Function(VisionAiCapturing) _then;

/// Create a copy of VisionAiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mode = null,}) {
  return _then(VisionAiCapturing(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as VisionMode,
  ));
}


}

/// @nodoc


class VisionAiAnalyzing implements VisionAiState {
  const VisionAiAnalyzing({required this.mode});
  

 final  VisionMode mode;

/// Create a copy of VisionAiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisionAiAnalyzingCopyWith<VisionAiAnalyzing> get copyWith => _$VisionAiAnalyzingCopyWithImpl<VisionAiAnalyzing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisionAiAnalyzing&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'VisionAiState.analyzing(mode: $mode)';
}


}

/// @nodoc
abstract mixin class $VisionAiAnalyzingCopyWith<$Res> implements $VisionAiStateCopyWith<$Res> {
  factory $VisionAiAnalyzingCopyWith(VisionAiAnalyzing value, $Res Function(VisionAiAnalyzing) _then) = _$VisionAiAnalyzingCopyWithImpl;
@useResult
$Res call({
 VisionMode mode
});




}
/// @nodoc
class _$VisionAiAnalyzingCopyWithImpl<$Res>
    implements $VisionAiAnalyzingCopyWith<$Res> {
  _$VisionAiAnalyzingCopyWithImpl(this._self, this._then);

  final VisionAiAnalyzing _self;
  final $Res Function(VisionAiAnalyzing) _then;

/// Create a copy of VisionAiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mode = null,}) {
  return _then(VisionAiAnalyzing(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as VisionMode,
  ));
}


}

/// @nodoc


class VisionAiResult implements VisionAiState {
  const VisionAiResult({required this.result, required this.mode});
  

 final  VisionResult result;
 final  VisionMode mode;

/// Create a copy of VisionAiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisionAiResultCopyWith<VisionAiResult> get copyWith => _$VisionAiResultCopyWithImpl<VisionAiResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisionAiResult&&(identical(other.result, result) || other.result == result)&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,result,mode);

@override
String toString() {
  return 'VisionAiState.result(result: $result, mode: $mode)';
}


}

/// @nodoc
abstract mixin class $VisionAiResultCopyWith<$Res> implements $VisionAiStateCopyWith<$Res> {
  factory $VisionAiResultCopyWith(VisionAiResult value, $Res Function(VisionAiResult) _then) = _$VisionAiResultCopyWithImpl;
@useResult
$Res call({
 VisionResult result, VisionMode mode
});




}
/// @nodoc
class _$VisionAiResultCopyWithImpl<$Res>
    implements $VisionAiResultCopyWith<$Res> {
  _$VisionAiResultCopyWithImpl(this._self, this._then);

  final VisionAiResult _self;
  final $Res Function(VisionAiResult) _then;

/// Create a copy of VisionAiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? result = null,Object? mode = null,}) {
  return _then(VisionAiResult(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as VisionResult,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as VisionMode,
  ));
}


}

/// @nodoc


class VisionAiOfflineFallback implements VisionAiState {
  const VisionAiOfflineFallback({required this.result, required this.mode});
  

 final  VisionResult result;
 final  VisionMode mode;

/// Create a copy of VisionAiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisionAiOfflineFallbackCopyWith<VisionAiOfflineFallback> get copyWith => _$VisionAiOfflineFallbackCopyWithImpl<VisionAiOfflineFallback>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisionAiOfflineFallback&&(identical(other.result, result) || other.result == result)&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,result,mode);

@override
String toString() {
  return 'VisionAiState.offlineFallback(result: $result, mode: $mode)';
}


}

/// @nodoc
abstract mixin class $VisionAiOfflineFallbackCopyWith<$Res> implements $VisionAiStateCopyWith<$Res> {
  factory $VisionAiOfflineFallbackCopyWith(VisionAiOfflineFallback value, $Res Function(VisionAiOfflineFallback) _then) = _$VisionAiOfflineFallbackCopyWithImpl;
@useResult
$Res call({
 VisionResult result, VisionMode mode
});




}
/// @nodoc
class _$VisionAiOfflineFallbackCopyWithImpl<$Res>
    implements $VisionAiOfflineFallbackCopyWith<$Res> {
  _$VisionAiOfflineFallbackCopyWithImpl(this._self, this._then);

  final VisionAiOfflineFallback _self;
  final $Res Function(VisionAiOfflineFallback) _then;

/// Create a copy of VisionAiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? result = null,Object? mode = null,}) {
  return _then(VisionAiOfflineFallback(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as VisionResult,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as VisionMode,
  ));
}


}

/// @nodoc


class VisionAiConsentRequired implements VisionAiState {
  const VisionAiConsentRequired({required this.mode});
  

 final  VisionMode mode;

/// Create a copy of VisionAiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisionAiConsentRequiredCopyWith<VisionAiConsentRequired> get copyWith => _$VisionAiConsentRequiredCopyWithImpl<VisionAiConsentRequired>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisionAiConsentRequired&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'VisionAiState.consentRequired(mode: $mode)';
}


}

/// @nodoc
abstract mixin class $VisionAiConsentRequiredCopyWith<$Res> implements $VisionAiStateCopyWith<$Res> {
  factory $VisionAiConsentRequiredCopyWith(VisionAiConsentRequired value, $Res Function(VisionAiConsentRequired) _then) = _$VisionAiConsentRequiredCopyWithImpl;
@useResult
$Res call({
 VisionMode mode
});




}
/// @nodoc
class _$VisionAiConsentRequiredCopyWithImpl<$Res>
    implements $VisionAiConsentRequiredCopyWith<$Res> {
  _$VisionAiConsentRequiredCopyWithImpl(this._self, this._then);

  final VisionAiConsentRequired _self;
  final $Res Function(VisionAiConsentRequired) _then;

/// Create a copy of VisionAiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mode = null,}) {
  return _then(VisionAiConsentRequired(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as VisionMode,
  ));
}


}

/// @nodoc


class VisionAiError implements VisionAiState {
  const VisionAiError({required this.message, this.mode = VisionMode.readText});
  

 final  String message;
@JsonKey() final  VisionMode mode;

/// Create a copy of VisionAiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisionAiErrorCopyWith<VisionAiError> get copyWith => _$VisionAiErrorCopyWithImpl<VisionAiError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisionAiError&&(identical(other.message, message) || other.message == message)&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,message,mode);

@override
String toString() {
  return 'VisionAiState.error(message: $message, mode: $mode)';
}


}

/// @nodoc
abstract mixin class $VisionAiErrorCopyWith<$Res> implements $VisionAiStateCopyWith<$Res> {
  factory $VisionAiErrorCopyWith(VisionAiError value, $Res Function(VisionAiError) _then) = _$VisionAiErrorCopyWithImpl;
@useResult
$Res call({
 String message, VisionMode mode
});




}
/// @nodoc
class _$VisionAiErrorCopyWithImpl<$Res>
    implements $VisionAiErrorCopyWith<$Res> {
  _$VisionAiErrorCopyWithImpl(this._self, this._then);

  final VisionAiError _self;
  final $Res Function(VisionAiError) _then;

/// Create a copy of VisionAiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? mode = null,}) {
  return _then(VisionAiError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as VisionMode,
  ));
}


}

// dart format on
