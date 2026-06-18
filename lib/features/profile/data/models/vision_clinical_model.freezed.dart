// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vision_clinical_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VisionClinicalModel {

/// Primary key — matches `profiles.id` / `auth.users.id` (UUID).
@JsonKey(name: 'user_id') String get userId;/// Primary eye diagnosis.
 String? get diagnosis;/// Severity classification.
@JsonKey(name: 'diagnosis_severity') String? get diagnosisSeverity;/// Which eye(s) are affected.
@JsonKey(name: 'affected_eyes') String? get affectedEyes;/// Year of diagnosis confirmation.
@JsonKey(name: 'diagnosed_year') int? get diagnosedYear;/// Light perception capability.
@JsonKey(name: 'light_perception') String? get lightPerception;/// Best corrected visual acuity string.
@JsonKey(name: 'central_acuity') String? get centralAcuity;/// Visual field description or degrees.
@JsonKey(name: 'visual_field') String? get visualField;/// Which eye has the prosthesis.
@JsonKey(name: 'prosthesis_eye') String? get prosthesisEye;/// Type of ocular prosthesis.
@JsonKey(name: 'prosthesis_type') String? get prosthesisType;/// Material of the prosthesis.
@JsonKey(name: 'prosthesis_material') String? get prosthesisMaterial;/// Date the prosthesis was fitted (Supabase `date` column → ISO string).
@JsonKey(name: 'prosthesis_fitted_date', fromJson: _parseDate, toJson: _formatDate) DateTime? get prosthesisFittedDate;/// Name or location of the fitting clinic.
@JsonKey(name: 'prosthesis_fitted_clinic') String? get prosthesisFittedClinic;/// Date of the last prosthesis polish (Supabase `date` column → ISO string).
@JsonKey(name: 'last_polish_date', fromJson: _parseDate, toJson: _formatDate) DateTime? get lastPolishDate;/// Scheduled date for the next prosthesis polish (Supabase `date` column).
@JsonKey(name: 'next_polish_due', fromJson: _parseDate, toJson: _formatDate) DateTime? get nextPolishDue;/// JSONB list of assistive technology devices.
@JsonKey(name: 'assistive_tech')@_AssistiveTechListConverter() List<AssistiveTech> get assistiveTech;/// Row creation timestamp (nullable — set by Postgres default).
@JsonKey(name: 'created_at') DateTime? get createdAt;/// Row last-updated timestamp (nullable — managed by DB trigger).
@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of VisionClinicalModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisionClinicalModelCopyWith<VisionClinicalModel> get copyWith => _$VisionClinicalModelCopyWithImpl<VisionClinicalModel>(this as VisionClinicalModel, _$identity);

  /// Serializes this VisionClinicalModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisionClinicalModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&(identical(other.diagnosisSeverity, diagnosisSeverity) || other.diagnosisSeverity == diagnosisSeverity)&&(identical(other.affectedEyes, affectedEyes) || other.affectedEyes == affectedEyes)&&(identical(other.diagnosedYear, diagnosedYear) || other.diagnosedYear == diagnosedYear)&&(identical(other.lightPerception, lightPerception) || other.lightPerception == lightPerception)&&(identical(other.centralAcuity, centralAcuity) || other.centralAcuity == centralAcuity)&&(identical(other.visualField, visualField) || other.visualField == visualField)&&(identical(other.prosthesisEye, prosthesisEye) || other.prosthesisEye == prosthesisEye)&&(identical(other.prosthesisType, prosthesisType) || other.prosthesisType == prosthesisType)&&(identical(other.prosthesisMaterial, prosthesisMaterial) || other.prosthesisMaterial == prosthesisMaterial)&&(identical(other.prosthesisFittedDate, prosthesisFittedDate) || other.prosthesisFittedDate == prosthesisFittedDate)&&(identical(other.prosthesisFittedClinic, prosthesisFittedClinic) || other.prosthesisFittedClinic == prosthesisFittedClinic)&&(identical(other.lastPolishDate, lastPolishDate) || other.lastPolishDate == lastPolishDate)&&(identical(other.nextPolishDue, nextPolishDue) || other.nextPolishDue == nextPolishDue)&&const DeepCollectionEquality().equals(other.assistiveTech, assistiveTech)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,diagnosis,diagnosisSeverity,affectedEyes,diagnosedYear,lightPerception,centralAcuity,visualField,prosthesisEye,prosthesisType,prosthesisMaterial,prosthesisFittedDate,prosthesisFittedClinic,lastPolishDate,nextPolishDue,const DeepCollectionEquality().hash(assistiveTech),createdAt,updatedAt);

@override
String toString() {
  return 'VisionClinicalModel(userId: $userId, diagnosis: $diagnosis, diagnosisSeverity: $diagnosisSeverity, affectedEyes: $affectedEyes, diagnosedYear: $diagnosedYear, lightPerception: $lightPerception, centralAcuity: $centralAcuity, visualField: $visualField, prosthesisEye: $prosthesisEye, prosthesisType: $prosthesisType, prosthesisMaterial: $prosthesisMaterial, prosthesisFittedDate: $prosthesisFittedDate, prosthesisFittedClinic: $prosthesisFittedClinic, lastPolishDate: $lastPolishDate, nextPolishDue: $nextPolishDue, assistiveTech: $assistiveTech, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $VisionClinicalModelCopyWith<$Res>  {
  factory $VisionClinicalModelCopyWith(VisionClinicalModel value, $Res Function(VisionClinicalModel) _then) = _$VisionClinicalModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId, String? diagnosis,@JsonKey(name: 'diagnosis_severity') String? diagnosisSeverity,@JsonKey(name: 'affected_eyes') String? affectedEyes,@JsonKey(name: 'diagnosed_year') int? diagnosedYear,@JsonKey(name: 'light_perception') String? lightPerception,@JsonKey(name: 'central_acuity') String? centralAcuity,@JsonKey(name: 'visual_field') String? visualField,@JsonKey(name: 'prosthesis_eye') String? prosthesisEye,@JsonKey(name: 'prosthesis_type') String? prosthesisType,@JsonKey(name: 'prosthesis_material') String? prosthesisMaterial,@JsonKey(name: 'prosthesis_fitted_date', fromJson: _parseDate, toJson: _formatDate) DateTime? prosthesisFittedDate,@JsonKey(name: 'prosthesis_fitted_clinic') String? prosthesisFittedClinic,@JsonKey(name: 'last_polish_date', fromJson: _parseDate, toJson: _formatDate) DateTime? lastPolishDate,@JsonKey(name: 'next_polish_due', fromJson: _parseDate, toJson: _formatDate) DateTime? nextPolishDue,@JsonKey(name: 'assistive_tech')@_AssistiveTechListConverter() List<AssistiveTech> assistiveTech,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$VisionClinicalModelCopyWithImpl<$Res>
    implements $VisionClinicalModelCopyWith<$Res> {
  _$VisionClinicalModelCopyWithImpl(this._self, this._then);

  final VisionClinicalModel _self;
  final $Res Function(VisionClinicalModel) _then;

/// Create a copy of VisionClinicalModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? diagnosis = freezed,Object? diagnosisSeverity = freezed,Object? affectedEyes = freezed,Object? diagnosedYear = freezed,Object? lightPerception = freezed,Object? centralAcuity = freezed,Object? visualField = freezed,Object? prosthesisEye = freezed,Object? prosthesisType = freezed,Object? prosthesisMaterial = freezed,Object? prosthesisFittedDate = freezed,Object? prosthesisFittedClinic = freezed,Object? lastPolishDate = freezed,Object? nextPolishDue = freezed,Object? assistiveTech = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,diagnosisSeverity: freezed == diagnosisSeverity ? _self.diagnosisSeverity : diagnosisSeverity // ignore: cast_nullable_to_non_nullable
as String?,affectedEyes: freezed == affectedEyes ? _self.affectedEyes : affectedEyes // ignore: cast_nullable_to_non_nullable
as String?,diagnosedYear: freezed == diagnosedYear ? _self.diagnosedYear : diagnosedYear // ignore: cast_nullable_to_non_nullable
as int?,lightPerception: freezed == lightPerception ? _self.lightPerception : lightPerception // ignore: cast_nullable_to_non_nullable
as String?,centralAcuity: freezed == centralAcuity ? _self.centralAcuity : centralAcuity // ignore: cast_nullable_to_non_nullable
as String?,visualField: freezed == visualField ? _self.visualField : visualField // ignore: cast_nullable_to_non_nullable
as String?,prosthesisEye: freezed == prosthesisEye ? _self.prosthesisEye : prosthesisEye // ignore: cast_nullable_to_non_nullable
as String?,prosthesisType: freezed == prosthesisType ? _self.prosthesisType : prosthesisType // ignore: cast_nullable_to_non_nullable
as String?,prosthesisMaterial: freezed == prosthesisMaterial ? _self.prosthesisMaterial : prosthesisMaterial // ignore: cast_nullable_to_non_nullable
as String?,prosthesisFittedDate: freezed == prosthesisFittedDate ? _self.prosthesisFittedDate : prosthesisFittedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,prosthesisFittedClinic: freezed == prosthesisFittedClinic ? _self.prosthesisFittedClinic : prosthesisFittedClinic // ignore: cast_nullable_to_non_nullable
as String?,lastPolishDate: freezed == lastPolishDate ? _self.lastPolishDate : lastPolishDate // ignore: cast_nullable_to_non_nullable
as DateTime?,nextPolishDue: freezed == nextPolishDue ? _self.nextPolishDue : nextPolishDue // ignore: cast_nullable_to_non_nullable
as DateTime?,assistiveTech: null == assistiveTech ? _self.assistiveTech : assistiveTech // ignore: cast_nullable_to_non_nullable
as List<AssistiveTech>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [VisionClinicalModel].
extension VisionClinicalModelPatterns on VisionClinicalModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisionClinicalModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisionClinicalModel() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisionClinicalModel value)  $default,){
final _that = this;
switch (_that) {
case _VisionClinicalModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisionClinicalModel value)?  $default,){
final _that = this;
switch (_that) {
case _VisionClinicalModel() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId,  String? diagnosis, @JsonKey(name: 'diagnosis_severity')  String? diagnosisSeverity, @JsonKey(name: 'affected_eyes')  String? affectedEyes, @JsonKey(name: 'diagnosed_year')  int? diagnosedYear, @JsonKey(name: 'light_perception')  String? lightPerception, @JsonKey(name: 'central_acuity')  String? centralAcuity, @JsonKey(name: 'visual_field')  String? visualField, @JsonKey(name: 'prosthesis_eye')  String? prosthesisEye, @JsonKey(name: 'prosthesis_type')  String? prosthesisType, @JsonKey(name: 'prosthesis_material')  String? prosthesisMaterial, @JsonKey(name: 'prosthesis_fitted_date', fromJson: _parseDate, toJson: _formatDate)  DateTime? prosthesisFittedDate, @JsonKey(name: 'prosthesis_fitted_clinic')  String? prosthesisFittedClinic, @JsonKey(name: 'last_polish_date', fromJson: _parseDate, toJson: _formatDate)  DateTime? lastPolishDate, @JsonKey(name: 'next_polish_due', fromJson: _parseDate, toJson: _formatDate)  DateTime? nextPolishDue, @JsonKey(name: 'assistive_tech')@_AssistiveTechListConverter()  List<AssistiveTech> assistiveTech, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisionClinicalModel() when $default != null:
return $default(_that.userId,_that.diagnosis,_that.diagnosisSeverity,_that.affectedEyes,_that.diagnosedYear,_that.lightPerception,_that.centralAcuity,_that.visualField,_that.prosthesisEye,_that.prosthesisType,_that.prosthesisMaterial,_that.prosthesisFittedDate,_that.prosthesisFittedClinic,_that.lastPolishDate,_that.nextPolishDue,_that.assistiveTech,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId,  String? diagnosis, @JsonKey(name: 'diagnosis_severity')  String? diagnosisSeverity, @JsonKey(name: 'affected_eyes')  String? affectedEyes, @JsonKey(name: 'diagnosed_year')  int? diagnosedYear, @JsonKey(name: 'light_perception')  String? lightPerception, @JsonKey(name: 'central_acuity')  String? centralAcuity, @JsonKey(name: 'visual_field')  String? visualField, @JsonKey(name: 'prosthesis_eye')  String? prosthesisEye, @JsonKey(name: 'prosthesis_type')  String? prosthesisType, @JsonKey(name: 'prosthesis_material')  String? prosthesisMaterial, @JsonKey(name: 'prosthesis_fitted_date', fromJson: _parseDate, toJson: _formatDate)  DateTime? prosthesisFittedDate, @JsonKey(name: 'prosthesis_fitted_clinic')  String? prosthesisFittedClinic, @JsonKey(name: 'last_polish_date', fromJson: _parseDate, toJson: _formatDate)  DateTime? lastPolishDate, @JsonKey(name: 'next_polish_due', fromJson: _parseDate, toJson: _formatDate)  DateTime? nextPolishDue, @JsonKey(name: 'assistive_tech')@_AssistiveTechListConverter()  List<AssistiveTech> assistiveTech, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _VisionClinicalModel():
return $default(_that.userId,_that.diagnosis,_that.diagnosisSeverity,_that.affectedEyes,_that.diagnosedYear,_that.lightPerception,_that.centralAcuity,_that.visualField,_that.prosthesisEye,_that.prosthesisType,_that.prosthesisMaterial,_that.prosthesisFittedDate,_that.prosthesisFittedClinic,_that.lastPolishDate,_that.nextPolishDue,_that.assistiveTech,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId,  String? diagnosis, @JsonKey(name: 'diagnosis_severity')  String? diagnosisSeverity, @JsonKey(name: 'affected_eyes')  String? affectedEyes, @JsonKey(name: 'diagnosed_year')  int? diagnosedYear, @JsonKey(name: 'light_perception')  String? lightPerception, @JsonKey(name: 'central_acuity')  String? centralAcuity, @JsonKey(name: 'visual_field')  String? visualField, @JsonKey(name: 'prosthesis_eye')  String? prosthesisEye, @JsonKey(name: 'prosthesis_type')  String? prosthesisType, @JsonKey(name: 'prosthesis_material')  String? prosthesisMaterial, @JsonKey(name: 'prosthesis_fitted_date', fromJson: _parseDate, toJson: _formatDate)  DateTime? prosthesisFittedDate, @JsonKey(name: 'prosthesis_fitted_clinic')  String? prosthesisFittedClinic, @JsonKey(name: 'last_polish_date', fromJson: _parseDate, toJson: _formatDate)  DateTime? lastPolishDate, @JsonKey(name: 'next_polish_due', fromJson: _parseDate, toJson: _formatDate)  DateTime? nextPolishDue, @JsonKey(name: 'assistive_tech')@_AssistiveTechListConverter()  List<AssistiveTech> assistiveTech, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _VisionClinicalModel() when $default != null:
return $default(_that.userId,_that.diagnosis,_that.diagnosisSeverity,_that.affectedEyes,_that.diagnosedYear,_that.lightPerception,_that.centralAcuity,_that.visualField,_that.prosthesisEye,_that.prosthesisType,_that.prosthesisMaterial,_that.prosthesisFittedDate,_that.prosthesisFittedClinic,_that.lastPolishDate,_that.nextPolishDue,_that.assistiveTech,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisionClinicalModel implements VisionClinicalModel {
  const _VisionClinicalModel({@JsonKey(name: 'user_id') required this.userId, this.diagnosis, @JsonKey(name: 'diagnosis_severity') this.diagnosisSeverity, @JsonKey(name: 'affected_eyes') this.affectedEyes, @JsonKey(name: 'diagnosed_year') this.diagnosedYear, @JsonKey(name: 'light_perception') this.lightPerception, @JsonKey(name: 'central_acuity') this.centralAcuity, @JsonKey(name: 'visual_field') this.visualField, @JsonKey(name: 'prosthesis_eye') this.prosthesisEye, @JsonKey(name: 'prosthesis_type') this.prosthesisType, @JsonKey(name: 'prosthesis_material') this.prosthesisMaterial, @JsonKey(name: 'prosthesis_fitted_date', fromJson: _parseDate, toJson: _formatDate) this.prosthesisFittedDate, @JsonKey(name: 'prosthesis_fitted_clinic') this.prosthesisFittedClinic, @JsonKey(name: 'last_polish_date', fromJson: _parseDate, toJson: _formatDate) this.lastPolishDate, @JsonKey(name: 'next_polish_due', fromJson: _parseDate, toJson: _formatDate) this.nextPolishDue, @JsonKey(name: 'assistive_tech')@_AssistiveTechListConverter() final  List<AssistiveTech> assistiveTech = const [], @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): _assistiveTech = assistiveTech;
  factory _VisionClinicalModel.fromJson(Map<String, dynamic> json) => _$VisionClinicalModelFromJson(json);

/// Primary key — matches `profiles.id` / `auth.users.id` (UUID).
@override@JsonKey(name: 'user_id') final  String userId;
/// Primary eye diagnosis.
@override final  String? diagnosis;
/// Severity classification.
@override@JsonKey(name: 'diagnosis_severity') final  String? diagnosisSeverity;
/// Which eye(s) are affected.
@override@JsonKey(name: 'affected_eyes') final  String? affectedEyes;
/// Year of diagnosis confirmation.
@override@JsonKey(name: 'diagnosed_year') final  int? diagnosedYear;
/// Light perception capability.
@override@JsonKey(name: 'light_perception') final  String? lightPerception;
/// Best corrected visual acuity string.
@override@JsonKey(name: 'central_acuity') final  String? centralAcuity;
/// Visual field description or degrees.
@override@JsonKey(name: 'visual_field') final  String? visualField;
/// Which eye has the prosthesis.
@override@JsonKey(name: 'prosthesis_eye') final  String? prosthesisEye;
/// Type of ocular prosthesis.
@override@JsonKey(name: 'prosthesis_type') final  String? prosthesisType;
/// Material of the prosthesis.
@override@JsonKey(name: 'prosthesis_material') final  String? prosthesisMaterial;
/// Date the prosthesis was fitted (Supabase `date` column → ISO string).
@override@JsonKey(name: 'prosthesis_fitted_date', fromJson: _parseDate, toJson: _formatDate) final  DateTime? prosthesisFittedDate;
/// Name or location of the fitting clinic.
@override@JsonKey(name: 'prosthesis_fitted_clinic') final  String? prosthesisFittedClinic;
/// Date of the last prosthesis polish (Supabase `date` column → ISO string).
@override@JsonKey(name: 'last_polish_date', fromJson: _parseDate, toJson: _formatDate) final  DateTime? lastPolishDate;
/// Scheduled date for the next prosthesis polish (Supabase `date` column).
@override@JsonKey(name: 'next_polish_due', fromJson: _parseDate, toJson: _formatDate) final  DateTime? nextPolishDue;
/// JSONB list of assistive technology devices.
 final  List<AssistiveTech> _assistiveTech;
/// JSONB list of assistive technology devices.
@override@JsonKey(name: 'assistive_tech')@_AssistiveTechListConverter() List<AssistiveTech> get assistiveTech {
  if (_assistiveTech is EqualUnmodifiableListView) return _assistiveTech;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assistiveTech);
}

/// Row creation timestamp (nullable — set by Postgres default).
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
/// Row last-updated timestamp (nullable — managed by DB trigger).
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of VisionClinicalModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisionClinicalModelCopyWith<_VisionClinicalModel> get copyWith => __$VisionClinicalModelCopyWithImpl<_VisionClinicalModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VisionClinicalModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisionClinicalModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&(identical(other.diagnosisSeverity, diagnosisSeverity) || other.diagnosisSeverity == diagnosisSeverity)&&(identical(other.affectedEyes, affectedEyes) || other.affectedEyes == affectedEyes)&&(identical(other.diagnosedYear, diagnosedYear) || other.diagnosedYear == diagnosedYear)&&(identical(other.lightPerception, lightPerception) || other.lightPerception == lightPerception)&&(identical(other.centralAcuity, centralAcuity) || other.centralAcuity == centralAcuity)&&(identical(other.visualField, visualField) || other.visualField == visualField)&&(identical(other.prosthesisEye, prosthesisEye) || other.prosthesisEye == prosthesisEye)&&(identical(other.prosthesisType, prosthesisType) || other.prosthesisType == prosthesisType)&&(identical(other.prosthesisMaterial, prosthesisMaterial) || other.prosthesisMaterial == prosthesisMaterial)&&(identical(other.prosthesisFittedDate, prosthesisFittedDate) || other.prosthesisFittedDate == prosthesisFittedDate)&&(identical(other.prosthesisFittedClinic, prosthesisFittedClinic) || other.prosthesisFittedClinic == prosthesisFittedClinic)&&(identical(other.lastPolishDate, lastPolishDate) || other.lastPolishDate == lastPolishDate)&&(identical(other.nextPolishDue, nextPolishDue) || other.nextPolishDue == nextPolishDue)&&const DeepCollectionEquality().equals(other._assistiveTech, _assistiveTech)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,diagnosis,diagnosisSeverity,affectedEyes,diagnosedYear,lightPerception,centralAcuity,visualField,prosthesisEye,prosthesisType,prosthesisMaterial,prosthesisFittedDate,prosthesisFittedClinic,lastPolishDate,nextPolishDue,const DeepCollectionEquality().hash(_assistiveTech),createdAt,updatedAt);

@override
String toString() {
  return 'VisionClinicalModel(userId: $userId, diagnosis: $diagnosis, diagnosisSeverity: $diagnosisSeverity, affectedEyes: $affectedEyes, diagnosedYear: $diagnosedYear, lightPerception: $lightPerception, centralAcuity: $centralAcuity, visualField: $visualField, prosthesisEye: $prosthesisEye, prosthesisType: $prosthesisType, prosthesisMaterial: $prosthesisMaterial, prosthesisFittedDate: $prosthesisFittedDate, prosthesisFittedClinic: $prosthesisFittedClinic, lastPolishDate: $lastPolishDate, nextPolishDue: $nextPolishDue, assistiveTech: $assistiveTech, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$VisionClinicalModelCopyWith<$Res> implements $VisionClinicalModelCopyWith<$Res> {
  factory _$VisionClinicalModelCopyWith(_VisionClinicalModel value, $Res Function(_VisionClinicalModel) _then) = __$VisionClinicalModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId, String? diagnosis,@JsonKey(name: 'diagnosis_severity') String? diagnosisSeverity,@JsonKey(name: 'affected_eyes') String? affectedEyes,@JsonKey(name: 'diagnosed_year') int? diagnosedYear,@JsonKey(name: 'light_perception') String? lightPerception,@JsonKey(name: 'central_acuity') String? centralAcuity,@JsonKey(name: 'visual_field') String? visualField,@JsonKey(name: 'prosthesis_eye') String? prosthesisEye,@JsonKey(name: 'prosthesis_type') String? prosthesisType,@JsonKey(name: 'prosthesis_material') String? prosthesisMaterial,@JsonKey(name: 'prosthesis_fitted_date', fromJson: _parseDate, toJson: _formatDate) DateTime? prosthesisFittedDate,@JsonKey(name: 'prosthesis_fitted_clinic') String? prosthesisFittedClinic,@JsonKey(name: 'last_polish_date', fromJson: _parseDate, toJson: _formatDate) DateTime? lastPolishDate,@JsonKey(name: 'next_polish_due', fromJson: _parseDate, toJson: _formatDate) DateTime? nextPolishDue,@JsonKey(name: 'assistive_tech')@_AssistiveTechListConverter() List<AssistiveTech> assistiveTech,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$VisionClinicalModelCopyWithImpl<$Res>
    implements _$VisionClinicalModelCopyWith<$Res> {
  __$VisionClinicalModelCopyWithImpl(this._self, this._then);

  final _VisionClinicalModel _self;
  final $Res Function(_VisionClinicalModel) _then;

/// Create a copy of VisionClinicalModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? diagnosis = freezed,Object? diagnosisSeverity = freezed,Object? affectedEyes = freezed,Object? diagnosedYear = freezed,Object? lightPerception = freezed,Object? centralAcuity = freezed,Object? visualField = freezed,Object? prosthesisEye = freezed,Object? prosthesisType = freezed,Object? prosthesisMaterial = freezed,Object? prosthesisFittedDate = freezed,Object? prosthesisFittedClinic = freezed,Object? lastPolishDate = freezed,Object? nextPolishDue = freezed,Object? assistiveTech = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_VisionClinicalModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,diagnosisSeverity: freezed == diagnosisSeverity ? _self.diagnosisSeverity : diagnosisSeverity // ignore: cast_nullable_to_non_nullable
as String?,affectedEyes: freezed == affectedEyes ? _self.affectedEyes : affectedEyes // ignore: cast_nullable_to_non_nullable
as String?,diagnosedYear: freezed == diagnosedYear ? _self.diagnosedYear : diagnosedYear // ignore: cast_nullable_to_non_nullable
as int?,lightPerception: freezed == lightPerception ? _self.lightPerception : lightPerception // ignore: cast_nullable_to_non_nullable
as String?,centralAcuity: freezed == centralAcuity ? _self.centralAcuity : centralAcuity // ignore: cast_nullable_to_non_nullable
as String?,visualField: freezed == visualField ? _self.visualField : visualField // ignore: cast_nullable_to_non_nullable
as String?,prosthesisEye: freezed == prosthesisEye ? _self.prosthesisEye : prosthesisEye // ignore: cast_nullable_to_non_nullable
as String?,prosthesisType: freezed == prosthesisType ? _self.prosthesisType : prosthesisType // ignore: cast_nullable_to_non_nullable
as String?,prosthesisMaterial: freezed == prosthesisMaterial ? _self.prosthesisMaterial : prosthesisMaterial // ignore: cast_nullable_to_non_nullable
as String?,prosthesisFittedDate: freezed == prosthesisFittedDate ? _self.prosthesisFittedDate : prosthesisFittedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,prosthesisFittedClinic: freezed == prosthesisFittedClinic ? _self.prosthesisFittedClinic : prosthesisFittedClinic // ignore: cast_nullable_to_non_nullable
as String?,lastPolishDate: freezed == lastPolishDate ? _self.lastPolishDate : lastPolishDate // ignore: cast_nullable_to_non_nullable
as DateTime?,nextPolishDue: freezed == nextPolishDue ? _self.nextPolishDue : nextPolishDue // ignore: cast_nullable_to_non_nullable
as DateTime?,assistiveTech: null == assistiveTech ? _self._assistiveTech : assistiveTech // ignore: cast_nullable_to_non_nullable
as List<AssistiveTech>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
