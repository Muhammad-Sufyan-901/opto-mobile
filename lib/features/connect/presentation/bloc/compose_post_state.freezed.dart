// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compose_post_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ComposePostState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposePostState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ComposePostState()';
}


}

/// @nodoc
class $ComposePostStateCopyWith<$Res>  {
$ComposePostStateCopyWith(ComposePostState _, $Res Function(ComposePostState) __);
}


/// Adds pattern-matching-related methods to [ComposePostState].
extension ComposePostStatePatterns on ComposePostState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ComposeIdle value)?  idle,TResult Function( ComposeSubmitting value)?  submitting,TResult Function( ComposeSuccess value)?  success,TResult Function( ComposeError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ComposeIdle() when idle != null:
return idle(_that);case ComposeSubmitting() when submitting != null:
return submitting(_that);case ComposeSuccess() when success != null:
return success(_that);case ComposeError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ComposeIdle value)  idle,required TResult Function( ComposeSubmitting value)  submitting,required TResult Function( ComposeSuccess value)  success,required TResult Function( ComposeError value)  error,}){
final _that = this;
switch (_that) {
case ComposeIdle():
return idle(_that);case ComposeSubmitting():
return submitting(_that);case ComposeSuccess():
return success(_that);case ComposeError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ComposeIdle value)?  idle,TResult? Function( ComposeSubmitting value)?  submitting,TResult? Function( ComposeSuccess value)?  success,TResult? Function( ComposeError value)?  error,}){
final _that = this;
switch (_that) {
case ComposeIdle() when idle != null:
return idle(_that);case ComposeSubmitting() when submitting != null:
return submitting(_that);case ComposeSuccess() when success != null:
return success(_that);case ComposeError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String body,  String? mediaPath,  String altText)?  idle,TResult Function()?  submitting,TResult Function( PostEntity post)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ComposeIdle() when idle != null:
return idle(_that.body,_that.mediaPath,_that.altText);case ComposeSubmitting() when submitting != null:
return submitting();case ComposeSuccess() when success != null:
return success(_that.post);case ComposeError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String body,  String? mediaPath,  String altText)  idle,required TResult Function()  submitting,required TResult Function( PostEntity post)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ComposeIdle():
return idle(_that.body,_that.mediaPath,_that.altText);case ComposeSubmitting():
return submitting();case ComposeSuccess():
return success(_that.post);case ComposeError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String body,  String? mediaPath,  String altText)?  idle,TResult? Function()?  submitting,TResult? Function( PostEntity post)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ComposeIdle() when idle != null:
return idle(_that.body,_that.mediaPath,_that.altText);case ComposeSubmitting() when submitting != null:
return submitting();case ComposeSuccess() when success != null:
return success(_that.post);case ComposeError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ComposeIdle implements ComposePostState {
  const ComposeIdle({this.body = '', this.mediaPath, this.altText = ''});
  

@JsonKey() final  String body;
 final  String? mediaPath;
@JsonKey() final  String altText;

/// Create a copy of ComposePostState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComposeIdleCopyWith<ComposeIdle> get copyWith => _$ComposeIdleCopyWithImpl<ComposeIdle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposeIdle&&(identical(other.body, body) || other.body == body)&&(identical(other.mediaPath, mediaPath) || other.mediaPath == mediaPath)&&(identical(other.altText, altText) || other.altText == altText));
}


@override
int get hashCode => Object.hash(runtimeType,body,mediaPath,altText);

@override
String toString() {
  return 'ComposePostState.idle(body: $body, mediaPath: $mediaPath, altText: $altText)';
}


}

/// @nodoc
abstract mixin class $ComposeIdleCopyWith<$Res> implements $ComposePostStateCopyWith<$Res> {
  factory $ComposeIdleCopyWith(ComposeIdle value, $Res Function(ComposeIdle) _then) = _$ComposeIdleCopyWithImpl;
@useResult
$Res call({
 String body, String? mediaPath, String altText
});




}
/// @nodoc
class _$ComposeIdleCopyWithImpl<$Res>
    implements $ComposeIdleCopyWith<$Res> {
  _$ComposeIdleCopyWithImpl(this._self, this._then);

  final ComposeIdle _self;
  final $Res Function(ComposeIdle) _then;

/// Create a copy of ComposePostState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? body = null,Object? mediaPath = freezed,Object? altText = null,}) {
  return _then(ComposeIdle(
body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,mediaPath: freezed == mediaPath ? _self.mediaPath : mediaPath // ignore: cast_nullable_to_non_nullable
as String?,altText: null == altText ? _self.altText : altText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ComposeSubmitting implements ComposePostState {
  const ComposeSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposeSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ComposePostState.submitting()';
}


}




/// @nodoc


class ComposeSuccess implements ComposePostState {
  const ComposeSuccess(this.post);
  

 final  PostEntity post;

/// Create a copy of ComposePostState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComposeSuccessCopyWith<ComposeSuccess> get copyWith => _$ComposeSuccessCopyWithImpl<ComposeSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposeSuccess&&(identical(other.post, post) || other.post == post));
}


@override
int get hashCode => Object.hash(runtimeType,post);

@override
String toString() {
  return 'ComposePostState.success(post: $post)';
}


}

/// @nodoc
abstract mixin class $ComposeSuccessCopyWith<$Res> implements $ComposePostStateCopyWith<$Res> {
  factory $ComposeSuccessCopyWith(ComposeSuccess value, $Res Function(ComposeSuccess) _then) = _$ComposeSuccessCopyWithImpl;
@useResult
$Res call({
 PostEntity post
});




}
/// @nodoc
class _$ComposeSuccessCopyWithImpl<$Res>
    implements $ComposeSuccessCopyWith<$Res> {
  _$ComposeSuccessCopyWithImpl(this._self, this._then);

  final ComposeSuccess _self;
  final $Res Function(ComposeSuccess) _then;

/// Create a copy of ComposePostState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? post = null,}) {
  return _then(ComposeSuccess(
null == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as PostEntity,
  ));
}


}

/// @nodoc


class ComposeError implements ComposePostState {
  const ComposeError({required this.message});
  

 final  String message;

/// Create a copy of ComposePostState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComposeErrorCopyWith<ComposeError> get copyWith => _$ComposeErrorCopyWithImpl<ComposeError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposeError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ComposePostState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ComposeErrorCopyWith<$Res> implements $ComposePostStateCopyWith<$Res> {
  factory $ComposeErrorCopyWith(ComposeError value, $Res Function(ComposeError) _then) = _$ComposeErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ComposeErrorCopyWithImpl<$Res>
    implements $ComposeErrorCopyWith<$Res> {
  _$ComposeErrorCopyWithImpl(this._self, this._then);

  final ComposeError _self;
  final $Res Function(ComposeError) _then;

/// Create a copy of ComposePostState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ComposeError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
