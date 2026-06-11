// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compose_post_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ComposePostEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposePostEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ComposePostEvent()';
}


}

/// @nodoc
class $ComposePostEventCopyWith<$Res>  {
$ComposePostEventCopyWith(ComposePostEvent _, $Res Function(ComposePostEvent) __);
}


/// Adds pattern-matching-related methods to [ComposePostEvent].
extension ComposePostEventPatterns on ComposePostEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BodyChanged value)?  bodyChanged,TResult Function( MediaSelected value)?  mediaSelected,TResult Function( MediaRemoved value)?  mediaRemoved,TResult Function( Submit value)?  submit,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BodyChanged() when bodyChanged != null:
return bodyChanged(_that);case MediaSelected() when mediaSelected != null:
return mediaSelected(_that);case MediaRemoved() when mediaRemoved != null:
return mediaRemoved(_that);case Submit() when submit != null:
return submit(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BodyChanged value)  bodyChanged,required TResult Function( MediaSelected value)  mediaSelected,required TResult Function( MediaRemoved value)  mediaRemoved,required TResult Function( Submit value)  submit,}){
final _that = this;
switch (_that) {
case BodyChanged():
return bodyChanged(_that);case MediaSelected():
return mediaSelected(_that);case MediaRemoved():
return mediaRemoved(_that);case Submit():
return submit(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BodyChanged value)?  bodyChanged,TResult? Function( MediaSelected value)?  mediaSelected,TResult? Function( MediaRemoved value)?  mediaRemoved,TResult? Function( Submit value)?  submit,}){
final _that = this;
switch (_that) {
case BodyChanged() when bodyChanged != null:
return bodyChanged(_that);case MediaSelected() when mediaSelected != null:
return mediaSelected(_that);case MediaRemoved() when mediaRemoved != null:
return mediaRemoved(_that);case Submit() when submit != null:
return submit(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String body)?  bodyChanged,TResult Function( String localPath,  String altText)?  mediaSelected,TResult Function()?  mediaRemoved,TResult Function()?  submit,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BodyChanged() when bodyChanged != null:
return bodyChanged(_that.body);case MediaSelected() when mediaSelected != null:
return mediaSelected(_that.localPath,_that.altText);case MediaRemoved() when mediaRemoved != null:
return mediaRemoved();case Submit() when submit != null:
return submit();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String body)  bodyChanged,required TResult Function( String localPath,  String altText)  mediaSelected,required TResult Function()  mediaRemoved,required TResult Function()  submit,}) {final _that = this;
switch (_that) {
case BodyChanged():
return bodyChanged(_that.body);case MediaSelected():
return mediaSelected(_that.localPath,_that.altText);case MediaRemoved():
return mediaRemoved();case Submit():
return submit();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String body)?  bodyChanged,TResult? Function( String localPath,  String altText)?  mediaSelected,TResult? Function()?  mediaRemoved,TResult? Function()?  submit,}) {final _that = this;
switch (_that) {
case BodyChanged() when bodyChanged != null:
return bodyChanged(_that.body);case MediaSelected() when mediaSelected != null:
return mediaSelected(_that.localPath,_that.altText);case MediaRemoved() when mediaRemoved != null:
return mediaRemoved();case Submit() when submit != null:
return submit();case _:
  return null;

}
}

}

/// @nodoc


class BodyChanged implements ComposePostEvent {
  const BodyChanged(this.body);
  

 final  String body;

/// Create a copy of ComposePostEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BodyChangedCopyWith<BodyChanged> get copyWith => _$BodyChangedCopyWithImpl<BodyChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BodyChanged&&(identical(other.body, body) || other.body == body));
}


@override
int get hashCode => Object.hash(runtimeType,body);

@override
String toString() {
  return 'ComposePostEvent.bodyChanged(body: $body)';
}


}

/// @nodoc
abstract mixin class $BodyChangedCopyWith<$Res> implements $ComposePostEventCopyWith<$Res> {
  factory $BodyChangedCopyWith(BodyChanged value, $Res Function(BodyChanged) _then) = _$BodyChangedCopyWithImpl;
@useResult
$Res call({
 String body
});




}
/// @nodoc
class _$BodyChangedCopyWithImpl<$Res>
    implements $BodyChangedCopyWith<$Res> {
  _$BodyChangedCopyWithImpl(this._self, this._then);

  final BodyChanged _self;
  final $Res Function(BodyChanged) _then;

/// Create a copy of ComposePostEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? body = null,}) {
  return _then(BodyChanged(
null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MediaSelected implements ComposePostEvent {
  const MediaSelected({required this.localPath, required this.altText});
  

 final  String localPath;
 final  String altText;

/// Create a copy of ComposePostEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaSelectedCopyWith<MediaSelected> get copyWith => _$MediaSelectedCopyWithImpl<MediaSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaSelected&&(identical(other.localPath, localPath) || other.localPath == localPath)&&(identical(other.altText, altText) || other.altText == altText));
}


@override
int get hashCode => Object.hash(runtimeType,localPath,altText);

@override
String toString() {
  return 'ComposePostEvent.mediaSelected(localPath: $localPath, altText: $altText)';
}


}

/// @nodoc
abstract mixin class $MediaSelectedCopyWith<$Res> implements $ComposePostEventCopyWith<$Res> {
  factory $MediaSelectedCopyWith(MediaSelected value, $Res Function(MediaSelected) _then) = _$MediaSelectedCopyWithImpl;
@useResult
$Res call({
 String localPath, String altText
});




}
/// @nodoc
class _$MediaSelectedCopyWithImpl<$Res>
    implements $MediaSelectedCopyWith<$Res> {
  _$MediaSelectedCopyWithImpl(this._self, this._then);

  final MediaSelected _self;
  final $Res Function(MediaSelected) _then;

/// Create a copy of ComposePostEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? localPath = null,Object? altText = null,}) {
  return _then(MediaSelected(
localPath: null == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String,altText: null == altText ? _self.altText : altText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MediaRemoved implements ComposePostEvent {
  const MediaRemoved();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaRemoved);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ComposePostEvent.mediaRemoved()';
}


}




/// @nodoc


class Submit implements ComposePostEvent {
  const Submit();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Submit);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ComposePostEvent.submit()';
}


}




// dart format on
