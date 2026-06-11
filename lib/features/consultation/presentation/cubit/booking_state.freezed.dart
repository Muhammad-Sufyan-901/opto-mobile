// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BookingState()';
}


}

/// @nodoc
class $BookingStateCopyWith<$Res>  {
$BookingStateCopyWith(BookingState _, $Res Function(BookingState) __);
}


/// Adds pattern-matching-related methods to [BookingState].
extension BookingStatePatterns on BookingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BookingInitial value)?  initial,TResult Function( BookingSlotSelected value)?  slotSelected,TResult Function( BookingSubmitting value)?  submitting,TResult Function( BookingConfirmed value)?  confirmed,TResult Function( BookingBookingsLoaded value)?  bookingsLoaded,TResult Function( BookingError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BookingInitial() when initial != null:
return initial(_that);case BookingSlotSelected() when slotSelected != null:
return slotSelected(_that);case BookingSubmitting() when submitting != null:
return submitting(_that);case BookingConfirmed() when confirmed != null:
return confirmed(_that);case BookingBookingsLoaded() when bookingsLoaded != null:
return bookingsLoaded(_that);case BookingError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BookingInitial value)  initial,required TResult Function( BookingSlotSelected value)  slotSelected,required TResult Function( BookingSubmitting value)  submitting,required TResult Function( BookingConfirmed value)  confirmed,required TResult Function( BookingBookingsLoaded value)  bookingsLoaded,required TResult Function( BookingError value)  error,}){
final _that = this;
switch (_that) {
case BookingInitial():
return initial(_that);case BookingSlotSelected():
return slotSelected(_that);case BookingSubmitting():
return submitting(_that);case BookingConfirmed():
return confirmed(_that);case BookingBookingsLoaded():
return bookingsLoaded(_that);case BookingError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BookingInitial value)?  initial,TResult? Function( BookingSlotSelected value)?  slotSelected,TResult? Function( BookingSubmitting value)?  submitting,TResult? Function( BookingConfirmed value)?  confirmed,TResult? Function( BookingBookingsLoaded value)?  bookingsLoaded,TResult? Function( BookingError value)?  error,}){
final _that = this;
switch (_that) {
case BookingInitial() when initial != null:
return initial(_that);case BookingSlotSelected() when slotSelected != null:
return slotSelected(_that);case BookingSubmitting() when submitting != null:
return submitting(_that);case BookingConfirmed() when confirmed != null:
return confirmed(_that);case BookingBookingsLoaded() when bookingsLoaded != null:
return bookingsLoaded(_that);case BookingError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( DoctorAvailabilityEntity slot,  ConsultMode mode)?  slotSelected,TResult Function()?  submitting,TResult Function( ConsultationBookingEntity booking)?  confirmed,TResult Function( List<ConsultationBookingEntity> bookings)?  bookingsLoaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BookingInitial() when initial != null:
return initial();case BookingSlotSelected() when slotSelected != null:
return slotSelected(_that.slot,_that.mode);case BookingSubmitting() when submitting != null:
return submitting();case BookingConfirmed() when confirmed != null:
return confirmed(_that.booking);case BookingBookingsLoaded() when bookingsLoaded != null:
return bookingsLoaded(_that.bookings);case BookingError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( DoctorAvailabilityEntity slot,  ConsultMode mode)  slotSelected,required TResult Function()  submitting,required TResult Function( ConsultationBookingEntity booking)  confirmed,required TResult Function( List<ConsultationBookingEntity> bookings)  bookingsLoaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case BookingInitial():
return initial();case BookingSlotSelected():
return slotSelected(_that.slot,_that.mode);case BookingSubmitting():
return submitting();case BookingConfirmed():
return confirmed(_that.booking);case BookingBookingsLoaded():
return bookingsLoaded(_that.bookings);case BookingError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( DoctorAvailabilityEntity slot,  ConsultMode mode)?  slotSelected,TResult? Function()?  submitting,TResult? Function( ConsultationBookingEntity booking)?  confirmed,TResult? Function( List<ConsultationBookingEntity> bookings)?  bookingsLoaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case BookingInitial() when initial != null:
return initial();case BookingSlotSelected() when slotSelected != null:
return slotSelected(_that.slot,_that.mode);case BookingSubmitting() when submitting != null:
return submitting();case BookingConfirmed() when confirmed != null:
return confirmed(_that.booking);case BookingBookingsLoaded() when bookingsLoaded != null:
return bookingsLoaded(_that.bookings);case BookingError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class BookingInitial implements BookingState {
  const BookingInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BookingState.initial()';
}


}




/// @nodoc


class BookingSlotSelected implements BookingState {
  const BookingSlotSelected({required this.slot, required this.mode});
  

 final  DoctorAvailabilityEntity slot;
 final  ConsultMode mode;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingSlotSelectedCopyWith<BookingSlotSelected> get copyWith => _$BookingSlotSelectedCopyWithImpl<BookingSlotSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingSlotSelected&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,slot,mode);

@override
String toString() {
  return 'BookingState.slotSelected(slot: $slot, mode: $mode)';
}


}

/// @nodoc
abstract mixin class $BookingSlotSelectedCopyWith<$Res> implements $BookingStateCopyWith<$Res> {
  factory $BookingSlotSelectedCopyWith(BookingSlotSelected value, $Res Function(BookingSlotSelected) _then) = _$BookingSlotSelectedCopyWithImpl;
@useResult
$Res call({
 DoctorAvailabilityEntity slot, ConsultMode mode
});




}
/// @nodoc
class _$BookingSlotSelectedCopyWithImpl<$Res>
    implements $BookingSlotSelectedCopyWith<$Res> {
  _$BookingSlotSelectedCopyWithImpl(this._self, this._then);

  final BookingSlotSelected _self;
  final $Res Function(BookingSlotSelected) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? slot = null,Object? mode = null,}) {
  return _then(BookingSlotSelected(
slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as DoctorAvailabilityEntity,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ConsultMode,
  ));
}


}

/// @nodoc


class BookingSubmitting implements BookingState {
  const BookingSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BookingState.submitting()';
}


}




/// @nodoc


class BookingConfirmed implements BookingState {
  const BookingConfirmed({required this.booking});
  

 final  ConsultationBookingEntity booking;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingConfirmedCopyWith<BookingConfirmed> get copyWith => _$BookingConfirmedCopyWithImpl<BookingConfirmed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingConfirmed&&(identical(other.booking, booking) || other.booking == booking));
}


@override
int get hashCode => Object.hash(runtimeType,booking);

@override
String toString() {
  return 'BookingState.confirmed(booking: $booking)';
}


}

/// @nodoc
abstract mixin class $BookingConfirmedCopyWith<$Res> implements $BookingStateCopyWith<$Res> {
  factory $BookingConfirmedCopyWith(BookingConfirmed value, $Res Function(BookingConfirmed) _then) = _$BookingConfirmedCopyWithImpl;
@useResult
$Res call({
 ConsultationBookingEntity booking
});




}
/// @nodoc
class _$BookingConfirmedCopyWithImpl<$Res>
    implements $BookingConfirmedCopyWith<$Res> {
  _$BookingConfirmedCopyWithImpl(this._self, this._then);

  final BookingConfirmed _self;
  final $Res Function(BookingConfirmed) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? booking = null,}) {
  return _then(BookingConfirmed(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as ConsultationBookingEntity,
  ));
}


}

/// @nodoc


class BookingBookingsLoaded implements BookingState {
  const BookingBookingsLoaded({required final  List<ConsultationBookingEntity> bookings}): _bookings = bookings;
  

 final  List<ConsultationBookingEntity> _bookings;
 List<ConsultationBookingEntity> get bookings {
  if (_bookings is EqualUnmodifiableListView) return _bookings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookings);
}


/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingBookingsLoadedCopyWith<BookingBookingsLoaded> get copyWith => _$BookingBookingsLoadedCopyWithImpl<BookingBookingsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingBookingsLoaded&&const DeepCollectionEquality().equals(other._bookings, _bookings));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_bookings));

@override
String toString() {
  return 'BookingState.bookingsLoaded(bookings: $bookings)';
}


}

/// @nodoc
abstract mixin class $BookingBookingsLoadedCopyWith<$Res> implements $BookingStateCopyWith<$Res> {
  factory $BookingBookingsLoadedCopyWith(BookingBookingsLoaded value, $Res Function(BookingBookingsLoaded) _then) = _$BookingBookingsLoadedCopyWithImpl;
@useResult
$Res call({
 List<ConsultationBookingEntity> bookings
});




}
/// @nodoc
class _$BookingBookingsLoadedCopyWithImpl<$Res>
    implements $BookingBookingsLoadedCopyWith<$Res> {
  _$BookingBookingsLoadedCopyWithImpl(this._self, this._then);

  final BookingBookingsLoaded _self;
  final $Res Function(BookingBookingsLoaded) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? bookings = null,}) {
  return _then(BookingBookingsLoaded(
bookings: null == bookings ? _self._bookings : bookings // ignore: cast_nullable_to_non_nullable
as List<ConsultationBookingEntity>,
  ));
}


}

/// @nodoc


class BookingError implements BookingState {
  const BookingError(this.message);
  

 final  String message;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingErrorCopyWith<BookingError> get copyWith => _$BookingErrorCopyWithImpl<BookingError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'BookingState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $BookingErrorCopyWith<$Res> implements $BookingStateCopyWith<$Res> {
  factory $BookingErrorCopyWith(BookingError value, $Res Function(BookingError) _then) = _$BookingErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$BookingErrorCopyWithImpl<$Res>
    implements $BookingErrorCopyWith<$Res> {
  _$BookingErrorCopyWithImpl(this._self, this._then);

  final BookingError _self;
  final $Res Function(BookingError) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(BookingError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
