// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connect_feed_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConnectFeedEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectFeedEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectFeedEvent()';
}


}

/// @nodoc
class $ConnectFeedEventCopyWith<$Res>  {
$ConnectFeedEventCopyWith(ConnectFeedEvent _, $Res Function(ConnectFeedEvent) __);
}


/// Adds pattern-matching-related methods to [ConnectFeedEvent].
extension ConnectFeedEventPatterns on ConnectFeedEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadFeed value)?  loadFeed,TResult Function( SubscribeFeed value)?  subscribeFeed,TResult Function( NewPostReceived value)?  newPostReceived,TResult Function( ToggleLike value)?  toggleLike,TResult Function( ChangeTopicFilter value)?  changeTopicFilter,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadFeed() when loadFeed != null:
return loadFeed(_that);case SubscribeFeed() when subscribeFeed != null:
return subscribeFeed(_that);case NewPostReceived() when newPostReceived != null:
return newPostReceived(_that);case ToggleLike() when toggleLike != null:
return toggleLike(_that);case ChangeTopicFilter() when changeTopicFilter != null:
return changeTopicFilter(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadFeed value)  loadFeed,required TResult Function( SubscribeFeed value)  subscribeFeed,required TResult Function( NewPostReceived value)  newPostReceived,required TResult Function( ToggleLike value)  toggleLike,required TResult Function( ChangeTopicFilter value)  changeTopicFilter,}){
final _that = this;
switch (_that) {
case LoadFeed():
return loadFeed(_that);case SubscribeFeed():
return subscribeFeed(_that);case NewPostReceived():
return newPostReceived(_that);case ToggleLike():
return toggleLike(_that);case ChangeTopicFilter():
return changeTopicFilter(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadFeed value)?  loadFeed,TResult? Function( SubscribeFeed value)?  subscribeFeed,TResult? Function( NewPostReceived value)?  newPostReceived,TResult? Function( ToggleLike value)?  toggleLike,TResult? Function( ChangeTopicFilter value)?  changeTopicFilter,}){
final _that = this;
switch (_that) {
case LoadFeed() when loadFeed != null:
return loadFeed(_that);case SubscribeFeed() when subscribeFeed != null:
return subscribeFeed(_that);case NewPostReceived() when newPostReceived != null:
return newPostReceived(_that);case ToggleLike() when toggleLike != null:
return toggleLike(_that);case ChangeTopicFilter() when changeTopicFilter != null:
return changeTopicFilter(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool reset)?  loadFeed,TResult Function()?  subscribeFeed,TResult Function( PostEntity post)?  newPostReceived,TResult Function( String postId)?  toggleLike,TResult Function( int index,  String? topic)?  changeTopicFilter,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadFeed() when loadFeed != null:
return loadFeed(_that.reset);case SubscribeFeed() when subscribeFeed != null:
return subscribeFeed();case NewPostReceived() when newPostReceived != null:
return newPostReceived(_that.post);case ToggleLike() when toggleLike != null:
return toggleLike(_that.postId);case ChangeTopicFilter() when changeTopicFilter != null:
return changeTopicFilter(_that.index,_that.topic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool reset)  loadFeed,required TResult Function()  subscribeFeed,required TResult Function( PostEntity post)  newPostReceived,required TResult Function( String postId)  toggleLike,required TResult Function( int index,  String? topic)  changeTopicFilter,}) {final _that = this;
switch (_that) {
case LoadFeed():
return loadFeed(_that.reset);case SubscribeFeed():
return subscribeFeed();case NewPostReceived():
return newPostReceived(_that.post);case ToggleLike():
return toggleLike(_that.postId);case ChangeTopicFilter():
return changeTopicFilter(_that.index,_that.topic);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool reset)?  loadFeed,TResult? Function()?  subscribeFeed,TResult? Function( PostEntity post)?  newPostReceived,TResult? Function( String postId)?  toggleLike,TResult? Function( int index,  String? topic)?  changeTopicFilter,}) {final _that = this;
switch (_that) {
case LoadFeed() when loadFeed != null:
return loadFeed(_that.reset);case SubscribeFeed() when subscribeFeed != null:
return subscribeFeed();case NewPostReceived() when newPostReceived != null:
return newPostReceived(_that.post);case ToggleLike() when toggleLike != null:
return toggleLike(_that.postId);case ChangeTopicFilter() when changeTopicFilter != null:
return changeTopicFilter(_that.index,_that.topic);case _:
  return null;

}
}

}

/// @nodoc


class LoadFeed implements ConnectFeedEvent {
  const LoadFeed({this.reset = false});
  

@JsonKey() final  bool reset;

/// Create a copy of ConnectFeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadFeedCopyWith<LoadFeed> get copyWith => _$LoadFeedCopyWithImpl<LoadFeed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadFeed&&(identical(other.reset, reset) || other.reset == reset));
}


@override
int get hashCode => Object.hash(runtimeType,reset);

@override
String toString() {
  return 'ConnectFeedEvent.loadFeed(reset: $reset)';
}


}

/// @nodoc
abstract mixin class $LoadFeedCopyWith<$Res> implements $ConnectFeedEventCopyWith<$Res> {
  factory $LoadFeedCopyWith(LoadFeed value, $Res Function(LoadFeed) _then) = _$LoadFeedCopyWithImpl;
@useResult
$Res call({
 bool reset
});




}
/// @nodoc
class _$LoadFeedCopyWithImpl<$Res>
    implements $LoadFeedCopyWith<$Res> {
  _$LoadFeedCopyWithImpl(this._self, this._then);

  final LoadFeed _self;
  final $Res Function(LoadFeed) _then;

/// Create a copy of ConnectFeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reset = null,}) {
  return _then(LoadFeed(
reset: null == reset ? _self.reset : reset // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SubscribeFeed implements ConnectFeedEvent {
  const SubscribeFeed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscribeFeed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectFeedEvent.subscribeFeed()';
}


}




/// @nodoc


class NewPostReceived implements ConnectFeedEvent {
  const NewPostReceived(this.post);
  

 final  PostEntity post;

/// Create a copy of ConnectFeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewPostReceivedCopyWith<NewPostReceived> get copyWith => _$NewPostReceivedCopyWithImpl<NewPostReceived>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewPostReceived&&(identical(other.post, post) || other.post == post));
}


@override
int get hashCode => Object.hash(runtimeType,post);

@override
String toString() {
  return 'ConnectFeedEvent.newPostReceived(post: $post)';
}


}

/// @nodoc
abstract mixin class $NewPostReceivedCopyWith<$Res> implements $ConnectFeedEventCopyWith<$Res> {
  factory $NewPostReceivedCopyWith(NewPostReceived value, $Res Function(NewPostReceived) _then) = _$NewPostReceivedCopyWithImpl;
@useResult
$Res call({
 PostEntity post
});




}
/// @nodoc
class _$NewPostReceivedCopyWithImpl<$Res>
    implements $NewPostReceivedCopyWith<$Res> {
  _$NewPostReceivedCopyWithImpl(this._self, this._then);

  final NewPostReceived _self;
  final $Res Function(NewPostReceived) _then;

/// Create a copy of ConnectFeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? post = null,}) {
  return _then(NewPostReceived(
null == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as PostEntity,
  ));
}


}

/// @nodoc


class ToggleLike implements ConnectFeedEvent {
  const ToggleLike(this.postId);
  

 final  String postId;

/// Create a copy of ConnectFeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleLikeCopyWith<ToggleLike> get copyWith => _$ToggleLikeCopyWithImpl<ToggleLike>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleLike&&(identical(other.postId, postId) || other.postId == postId));
}


@override
int get hashCode => Object.hash(runtimeType,postId);

@override
String toString() {
  return 'ConnectFeedEvent.toggleLike(postId: $postId)';
}


}

/// @nodoc
abstract mixin class $ToggleLikeCopyWith<$Res> implements $ConnectFeedEventCopyWith<$Res> {
  factory $ToggleLikeCopyWith(ToggleLike value, $Res Function(ToggleLike) _then) = _$ToggleLikeCopyWithImpl;
@useResult
$Res call({
 String postId
});




}
/// @nodoc
class _$ToggleLikeCopyWithImpl<$Res>
    implements $ToggleLikeCopyWith<$Res> {
  _$ToggleLikeCopyWithImpl(this._self, this._then);

  final ToggleLike _self;
  final $Res Function(ToggleLike) _then;

/// Create a copy of ConnectFeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? postId = null,}) {
  return _then(ToggleLike(
null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ChangeTopicFilter implements ConnectFeedEvent {
  const ChangeTopicFilter({required this.index, this.topic});
  

 final  int index;
 final  String? topic;

/// Create a copy of ConnectFeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeTopicFilterCopyWith<ChangeTopicFilter> get copyWith => _$ChangeTopicFilterCopyWithImpl<ChangeTopicFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeTopicFilter&&(identical(other.index, index) || other.index == index)&&(identical(other.topic, topic) || other.topic == topic));
}


@override
int get hashCode => Object.hash(runtimeType,index,topic);

@override
String toString() {
  return 'ConnectFeedEvent.changeTopicFilter(index: $index, topic: $topic)';
}


}

/// @nodoc
abstract mixin class $ChangeTopicFilterCopyWith<$Res> implements $ConnectFeedEventCopyWith<$Res> {
  factory $ChangeTopicFilterCopyWith(ChangeTopicFilter value, $Res Function(ChangeTopicFilter) _then) = _$ChangeTopicFilterCopyWithImpl;
@useResult
$Res call({
 int index, String? topic
});




}
/// @nodoc
class _$ChangeTopicFilterCopyWithImpl<$Res>
    implements $ChangeTopicFilterCopyWith<$Res> {
  _$ChangeTopicFilterCopyWithImpl(this._self, this._then);

  final ChangeTopicFilter _self;
  final $Res Function(ChangeTopicFilter) _then;

/// Create a copy of ConnectFeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,Object? topic = freezed,}) {
  return _then(ChangeTopicFilter(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
