// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consultation_chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConsultationChatState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsultationChatState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConsultationChatState()';
}


}

/// @nodoc
class $ConsultationChatStateCopyWith<$Res>  {
$ConsultationChatStateCopyWith(ConsultationChatState _, $Res Function(ConsultationChatState) __);
}


/// Adds pattern-matching-related methods to [ConsultationChatState].
extension ConsultationChatStatePatterns on ConsultationChatState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ConsultationChatInitial value)?  initial,TResult Function( ConsultationChatLoading value)?  loading,TResult Function( ConsultationChatActive value)?  active,TResult Function( ConsultationChatError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ConsultationChatInitial() when initial != null:
return initial(_that);case ConsultationChatLoading() when loading != null:
return loading(_that);case ConsultationChatActive() when active != null:
return active(_that);case ConsultationChatError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ConsultationChatInitial value)  initial,required TResult Function( ConsultationChatLoading value)  loading,required TResult Function( ConsultationChatActive value)  active,required TResult Function( ConsultationChatError value)  error,}){
final _that = this;
switch (_that) {
case ConsultationChatInitial():
return initial(_that);case ConsultationChatLoading():
return loading(_that);case ConsultationChatActive():
return active(_that);case ConsultationChatError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ConsultationChatInitial value)?  initial,TResult? Function( ConsultationChatLoading value)?  loading,TResult? Function( ConsultationChatActive value)?  active,TResult? Function( ConsultationChatError value)?  error,}){
final _that = this;
switch (_that) {
case ConsultationChatInitial() when initial != null:
return initial(_that);case ConsultationChatLoading() when loading != null:
return loading(_that);case ConsultationChatActive() when active != null:
return active(_that);case ConsultationChatError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String bookingId,  String? currentUserId,  List<ConsultationMessageEntity> messages)?  active,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ConsultationChatInitial() when initial != null:
return initial();case ConsultationChatLoading() when loading != null:
return loading();case ConsultationChatActive() when active != null:
return active(_that.bookingId,_that.currentUserId,_that.messages);case ConsultationChatError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String bookingId,  String? currentUserId,  List<ConsultationMessageEntity> messages)  active,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ConsultationChatInitial():
return initial();case ConsultationChatLoading():
return loading();case ConsultationChatActive():
return active(_that.bookingId,_that.currentUserId,_that.messages);case ConsultationChatError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String bookingId,  String? currentUserId,  List<ConsultationMessageEntity> messages)?  active,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ConsultationChatInitial() when initial != null:
return initial();case ConsultationChatLoading() when loading != null:
return loading();case ConsultationChatActive() when active != null:
return active(_that.bookingId,_that.currentUserId,_that.messages);case ConsultationChatError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ConsultationChatInitial implements ConsultationChatState {
  const ConsultationChatInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsultationChatInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConsultationChatState.initial()';
}


}




/// @nodoc


class ConsultationChatLoading implements ConsultationChatState {
  const ConsultationChatLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsultationChatLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConsultationChatState.loading()';
}


}




/// @nodoc


class ConsultationChatActive implements ConsultationChatState {
  const ConsultationChatActive({required this.bookingId, required this.currentUserId, required final  List<ConsultationMessageEntity> messages}): _messages = messages;
  

 final  String bookingId;
 final  String? currentUserId;
 final  List<ConsultationMessageEntity> _messages;
 List<ConsultationMessageEntity> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}


/// Create a copy of ConsultationChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsultationChatActiveCopyWith<ConsultationChatActive> get copyWith => _$ConsultationChatActiveCopyWithImpl<ConsultationChatActive>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsultationChatActive&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.currentUserId, currentUserId) || other.currentUserId == currentUserId)&&const DeepCollectionEquality().equals(other._messages, _messages));
}


@override
int get hashCode => Object.hash(runtimeType,bookingId,currentUserId,const DeepCollectionEquality().hash(_messages));

@override
String toString() {
  return 'ConsultationChatState.active(bookingId: $bookingId, currentUserId: $currentUserId, messages: $messages)';
}


}

/// @nodoc
abstract mixin class $ConsultationChatActiveCopyWith<$Res> implements $ConsultationChatStateCopyWith<$Res> {
  factory $ConsultationChatActiveCopyWith(ConsultationChatActive value, $Res Function(ConsultationChatActive) _then) = _$ConsultationChatActiveCopyWithImpl;
@useResult
$Res call({
 String bookingId, String? currentUserId, List<ConsultationMessageEntity> messages
});




}
/// @nodoc
class _$ConsultationChatActiveCopyWithImpl<$Res>
    implements $ConsultationChatActiveCopyWith<$Res> {
  _$ConsultationChatActiveCopyWithImpl(this._self, this._then);

  final ConsultationChatActive _self;
  final $Res Function(ConsultationChatActive) _then;

/// Create a copy of ConsultationChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? bookingId = null,Object? currentUserId = freezed,Object? messages = null,}) {
  return _then(ConsultationChatActive(
bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,currentUserId: freezed == currentUserId ? _self.currentUserId : currentUserId // ignore: cast_nullable_to_non_nullable
as String?,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ConsultationMessageEntity>,
  ));
}


}

/// @nodoc


class ConsultationChatError implements ConsultationChatState {
  const ConsultationChatError(this.message);
  

 final  String message;

/// Create a copy of ConsultationChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsultationChatErrorCopyWith<ConsultationChatError> get copyWith => _$ConsultationChatErrorCopyWithImpl<ConsultationChatError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsultationChatError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ConsultationChatState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ConsultationChatErrorCopyWith<$Res> implements $ConsultationChatStateCopyWith<$Res> {
  factory $ConsultationChatErrorCopyWith(ConsultationChatError value, $Res Function(ConsultationChatError) _then) = _$ConsultationChatErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ConsultationChatErrorCopyWithImpl<$Res>
    implements $ConsultationChatErrorCopyWith<$Res> {
  _$ConsultationChatErrorCopyWithImpl(this._self, this._then);

  final ConsultationChatError _self;
  final $Res Function(ConsultationChatError) _then;

/// Create a copy of ConsultationChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ConsultationChatError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
