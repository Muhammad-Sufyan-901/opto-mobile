// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReportState()';
}


}

/// @nodoc
class $ReportStateCopyWith<$Res>  {
$ReportStateCopyWith(ReportState _, $Res Function(ReportState) __);
}


/// Adds pattern-matching-related methods to [ReportState].
extension ReportStatePatterns on ReportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ReportIdle value)?  idle,TResult Function( ReportSubmitting value)?  submitting,TResult Function( ReportSuccess value)?  success,TResult Function( ReportError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ReportIdle() when idle != null:
return idle(_that);case ReportSubmitting() when submitting != null:
return submitting(_that);case ReportSuccess() when success != null:
return success(_that);case ReportError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ReportIdle value)  idle,required TResult Function( ReportSubmitting value)  submitting,required TResult Function( ReportSuccess value)  success,required TResult Function( ReportError value)  error,}){
final _that = this;
switch (_that) {
case ReportIdle():
return idle(_that);case ReportSubmitting():
return submitting(_that);case ReportSuccess():
return success(_that);case ReportError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ReportIdle value)?  idle,TResult? Function( ReportSubmitting value)?  submitting,TResult? Function( ReportSuccess value)?  success,TResult? Function( ReportError value)?  error,}){
final _that = this;
switch (_that) {
case ReportIdle() when idle != null:
return idle(_that);case ReportSubmitting() when submitting != null:
return submitting(_that);case ReportSuccess() when success != null:
return success(_that);case ReportError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  submitting,TResult Function()?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ReportIdle() when idle != null:
return idle();case ReportSubmitting() when submitting != null:
return submitting();case ReportSuccess() when success != null:
return success();case ReportError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  submitting,required TResult Function()  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ReportIdle():
return idle();case ReportSubmitting():
return submitting();case ReportSuccess():
return success();case ReportError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  submitting,TResult? Function()?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ReportIdle() when idle != null:
return idle();case ReportSubmitting() when submitting != null:
return submitting();case ReportSuccess() when success != null:
return success();case ReportError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ReportIdle implements ReportState {
  const ReportIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReportState.idle()';
}


}




/// @nodoc


class ReportSubmitting implements ReportState {
  const ReportSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReportState.submitting()';
}


}




/// @nodoc


class ReportSuccess implements ReportState {
  const ReportSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReportState.success()';
}


}




/// @nodoc


class ReportError implements ReportState {
  const ReportError({required this.message});
  

 final  String message;

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportErrorCopyWith<ReportError> get copyWith => _$ReportErrorCopyWithImpl<ReportError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ReportState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ReportErrorCopyWith<$Res> implements $ReportStateCopyWith<$Res> {
  factory $ReportErrorCopyWith(ReportError value, $Res Function(ReportError) _then) = _$ReportErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ReportErrorCopyWithImpl<$Res>
    implements $ReportErrorCopyWith<$Res> {
  _$ReportErrorCopyWithImpl(this._self, this._then);

  final ReportError _self;
  final $Res Function(ReportError) _then;

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ReportError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
