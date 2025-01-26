// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_language_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppLanguageEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String languageCode) changeLanguage,
    required TResult Function() loadSavedLanguage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String languageCode)? changeLanguage,
    TResult? Function()? loadSavedLanguage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String languageCode)? changeLanguage,
    TResult Function()? loadSavedLanguage,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangeLanguage value) changeLanguage,
    required TResult Function(_LoadSavedLanguage value) loadSavedLanguage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangeLanguage value)? changeLanguage,
    TResult? Function(_LoadSavedLanguage value)? loadSavedLanguage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangeLanguage value)? changeLanguage,
    TResult Function(_LoadSavedLanguage value)? loadSavedLanguage,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppLanguageEventCopyWith<$Res> {
  factory $AppLanguageEventCopyWith(
          AppLanguageEvent value, $Res Function(AppLanguageEvent) then) =
      _$AppLanguageEventCopyWithImpl<$Res, AppLanguageEvent>;
}

/// @nodoc
class _$AppLanguageEventCopyWithImpl<$Res, $Val extends AppLanguageEvent>
    implements $AppLanguageEventCopyWith<$Res> {
  _$AppLanguageEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppLanguageEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ChangeLanguageImplCopyWith<$Res> {
  factory _$$ChangeLanguageImplCopyWith(_$ChangeLanguageImpl value,
          $Res Function(_$ChangeLanguageImpl) then) =
      __$$ChangeLanguageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String languageCode});
}

/// @nodoc
class __$$ChangeLanguageImplCopyWithImpl<$Res>
    extends _$AppLanguageEventCopyWithImpl<$Res, _$ChangeLanguageImpl>
    implements _$$ChangeLanguageImplCopyWith<$Res> {
  __$$ChangeLanguageImplCopyWithImpl(
      _$ChangeLanguageImpl _value, $Res Function(_$ChangeLanguageImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppLanguageEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCode = null,
  }) {
    return _then(_$ChangeLanguageImpl(
      null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ChangeLanguageImpl implements _ChangeLanguage {
  const _$ChangeLanguageImpl(this.languageCode);

  @override
  final String languageCode;

  @override
  String toString() {
    return 'AppLanguageEvent.changeLanguage(languageCode: $languageCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangeLanguageImpl &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, languageCode);

  /// Create a copy of AppLanguageEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangeLanguageImplCopyWith<_$ChangeLanguageImpl> get copyWith =>
      __$$ChangeLanguageImplCopyWithImpl<_$ChangeLanguageImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String languageCode) changeLanguage,
    required TResult Function() loadSavedLanguage,
  }) {
    return changeLanguage(languageCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String languageCode)? changeLanguage,
    TResult? Function()? loadSavedLanguage,
  }) {
    return changeLanguage?.call(languageCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String languageCode)? changeLanguage,
    TResult Function()? loadSavedLanguage,
    required TResult orElse(),
  }) {
    if (changeLanguage != null) {
      return changeLanguage(languageCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangeLanguage value) changeLanguage,
    required TResult Function(_LoadSavedLanguage value) loadSavedLanguage,
  }) {
    return changeLanguage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangeLanguage value)? changeLanguage,
    TResult? Function(_LoadSavedLanguage value)? loadSavedLanguage,
  }) {
    return changeLanguage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangeLanguage value)? changeLanguage,
    TResult Function(_LoadSavedLanguage value)? loadSavedLanguage,
    required TResult orElse(),
  }) {
    if (changeLanguage != null) {
      return changeLanguage(this);
    }
    return orElse();
  }
}

abstract class _ChangeLanguage implements AppLanguageEvent {
  const factory _ChangeLanguage(final String languageCode) =
      _$ChangeLanguageImpl;

  String get languageCode;

  /// Create a copy of AppLanguageEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangeLanguageImplCopyWith<_$ChangeLanguageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadSavedLanguageImplCopyWith<$Res> {
  factory _$$LoadSavedLanguageImplCopyWith(_$LoadSavedLanguageImpl value,
          $Res Function(_$LoadSavedLanguageImpl) then) =
      __$$LoadSavedLanguageImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadSavedLanguageImplCopyWithImpl<$Res>
    extends _$AppLanguageEventCopyWithImpl<$Res, _$LoadSavedLanguageImpl>
    implements _$$LoadSavedLanguageImplCopyWith<$Res> {
  __$$LoadSavedLanguageImplCopyWithImpl(_$LoadSavedLanguageImpl _value,
      $Res Function(_$LoadSavedLanguageImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppLanguageEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadSavedLanguageImpl implements _LoadSavedLanguage {
  const _$LoadSavedLanguageImpl();

  @override
  String toString() {
    return 'AppLanguageEvent.loadSavedLanguage()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadSavedLanguageImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String languageCode) changeLanguage,
    required TResult Function() loadSavedLanguage,
  }) {
    return loadSavedLanguage();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String languageCode)? changeLanguage,
    TResult? Function()? loadSavedLanguage,
  }) {
    return loadSavedLanguage?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String languageCode)? changeLanguage,
    TResult Function()? loadSavedLanguage,
    required TResult orElse(),
  }) {
    if (loadSavedLanguage != null) {
      return loadSavedLanguage();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangeLanguage value) changeLanguage,
    required TResult Function(_LoadSavedLanguage value) loadSavedLanguage,
  }) {
    return loadSavedLanguage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangeLanguage value)? changeLanguage,
    TResult? Function(_LoadSavedLanguage value)? loadSavedLanguage,
  }) {
    return loadSavedLanguage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangeLanguage value)? changeLanguage,
    TResult Function(_LoadSavedLanguage value)? loadSavedLanguage,
    required TResult orElse(),
  }) {
    if (loadSavedLanguage != null) {
      return loadSavedLanguage(this);
    }
    return orElse();
  }
}

abstract class _LoadSavedLanguage implements AppLanguageEvent {
  const factory _LoadSavedLanguage() = _$LoadSavedLanguageImpl;
}

/// @nodoc
mixin _$AppLanguageState {
  String get languageCode => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String languageCode) initial,
    required TResult Function(String languageCode) changed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String languageCode)? initial,
    TResult? Function(String languageCode)? changed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String languageCode)? initial,
    TResult Function(String languageCode)? changed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Changed value) changed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Changed value)? changed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Changed value)? changed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of AppLanguageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppLanguageStateCopyWith<AppLanguageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppLanguageStateCopyWith<$Res> {
  factory $AppLanguageStateCopyWith(
          AppLanguageState value, $Res Function(AppLanguageState) then) =
      _$AppLanguageStateCopyWithImpl<$Res, AppLanguageState>;
  @useResult
  $Res call({String languageCode});
}

/// @nodoc
class _$AppLanguageStateCopyWithImpl<$Res, $Val extends AppLanguageState>
    implements $AppLanguageStateCopyWith<$Res> {
  _$AppLanguageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppLanguageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCode = null,
  }) {
    return _then(_value.copyWith(
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res>
    implements $AppLanguageStateCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String languageCode});
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$AppLanguageStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppLanguageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCode = null,
  }) {
    return _then(_$InitialImpl(
      null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl(this.languageCode);

  @override
  final String languageCode;

  @override
  String toString() {
    return 'AppLanguageState.initial(languageCode: $languageCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitialImpl &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, languageCode);

  /// Create a copy of AppLanguageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InitialImplCopyWith<_$InitialImpl> get copyWith =>
      __$$InitialImplCopyWithImpl<_$InitialImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String languageCode) initial,
    required TResult Function(String languageCode) changed,
  }) {
    return initial(languageCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String languageCode)? initial,
    TResult? Function(String languageCode)? changed,
  }) {
    return initial?.call(languageCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String languageCode)? initial,
    TResult Function(String languageCode)? changed,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(languageCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Changed value) changed,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Changed value)? changed,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Changed value)? changed,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements AppLanguageState {
  const factory _Initial(final String languageCode) = _$InitialImpl;

  @override
  String get languageCode;

  /// Create a copy of AppLanguageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InitialImplCopyWith<_$InitialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChangedImplCopyWith<$Res>
    implements $AppLanguageStateCopyWith<$Res> {
  factory _$$ChangedImplCopyWith(
          _$ChangedImpl value, $Res Function(_$ChangedImpl) then) =
      __$$ChangedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String languageCode});
}

/// @nodoc
class __$$ChangedImplCopyWithImpl<$Res>
    extends _$AppLanguageStateCopyWithImpl<$Res, _$ChangedImpl>
    implements _$$ChangedImplCopyWith<$Res> {
  __$$ChangedImplCopyWithImpl(
      _$ChangedImpl _value, $Res Function(_$ChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppLanguageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCode = null,
  }) {
    return _then(_$ChangedImpl(
      null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ChangedImpl implements _Changed {
  const _$ChangedImpl(this.languageCode);

  @override
  final String languageCode;

  @override
  String toString() {
    return 'AppLanguageState.changed(languageCode: $languageCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangedImpl &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, languageCode);

  /// Create a copy of AppLanguageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangedImplCopyWith<_$ChangedImpl> get copyWith =>
      __$$ChangedImplCopyWithImpl<_$ChangedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String languageCode) initial,
    required TResult Function(String languageCode) changed,
  }) {
    return changed(languageCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String languageCode)? initial,
    TResult? Function(String languageCode)? changed,
  }) {
    return changed?.call(languageCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String languageCode)? initial,
    TResult Function(String languageCode)? changed,
    required TResult orElse(),
  }) {
    if (changed != null) {
      return changed(languageCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Changed value) changed,
  }) {
    return changed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Changed value)? changed,
  }) {
    return changed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Changed value)? changed,
    required TResult orElse(),
  }) {
    if (changed != null) {
      return changed(this);
    }
    return orElse();
  }
}

abstract class _Changed implements AppLanguageState {
  const factory _Changed(final String languageCode) = _$ChangedImpl;

  @override
  String get languageCode;

  /// Create a copy of AppLanguageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangedImplCopyWith<_$ChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
