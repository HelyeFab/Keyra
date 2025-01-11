// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthBlocEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() googleSignInRequested,
    required TResult Function(String email, String password, String name)
        emailSignUpRequested,
    required TResult Function(String email, String password)
        emailSignInRequested,
    required TResult Function() signOutRequested,
    required TResult Function(dynamic user) authStateChanged,
    required TResult Function() appleSignInRequested,
    required TResult Function() startAuthListening,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? googleSignInRequested,
    TResult? Function(String email, String password, String name)?
        emailSignUpRequested,
    TResult? Function(String email, String password)? emailSignInRequested,
    TResult? Function()? signOutRequested,
    TResult? Function(dynamic user)? authStateChanged,
    TResult? Function()? appleSignInRequested,
    TResult? Function()? startAuthListening,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? googleSignInRequested,
    TResult Function(String email, String password, String name)?
        emailSignUpRequested,
    TResult Function(String email, String password)? emailSignInRequested,
    TResult Function()? signOutRequested,
    TResult Function(dynamic user)? authStateChanged,
    TResult Function()? appleSignInRequested,
    TResult Function()? startAuthListening,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GoogleSignInRequested value)
        googleSignInRequested,
    required TResult Function(EmailSignUpRequested value) emailSignUpRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
    required TResult Function(AuthStateChanged value) authStateChanged,
    required TResult Function(AppleSignInRequested value) appleSignInRequested,
    required TResult Function(StartAuthListening value) startAuthListening,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(EmailSignUpRequested value)? emailSignUpRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
    TResult? Function(AuthStateChanged value)? authStateChanged,
    TResult? Function(AppleSignInRequested value)? appleSignInRequested,
    TResult? Function(StartAuthListening value)? startAuthListening,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(EmailSignUpRequested value)? emailSignUpRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    TResult Function(AuthStateChanged value)? authStateChanged,
    TResult Function(AppleSignInRequested value)? appleSignInRequested,
    TResult Function(StartAuthListening value)? startAuthListening,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthBlocEventCopyWith<$Res> {
  factory $AuthBlocEventCopyWith(
          AuthBlocEvent value, $Res Function(AuthBlocEvent) then) =
      _$AuthBlocEventCopyWithImpl<$Res, AuthBlocEvent>;
}

/// @nodoc
class _$AuthBlocEventCopyWithImpl<$Res, $Val extends AuthBlocEvent>
    implements $AuthBlocEventCopyWith<$Res> {
  _$AuthBlocEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthBlocEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GoogleSignInRequestedImplCopyWith<$Res> {
  factory _$$GoogleSignInRequestedImplCopyWith(
          _$GoogleSignInRequestedImpl value,
          $Res Function(_$GoogleSignInRequestedImpl) then) =
      __$$GoogleSignInRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GoogleSignInRequestedImplCopyWithImpl<$Res>
    extends _$AuthBlocEventCopyWithImpl<$Res, _$GoogleSignInRequestedImpl>
    implements _$$GoogleSignInRequestedImplCopyWith<$Res> {
  __$$GoogleSignInRequestedImplCopyWithImpl(_$GoogleSignInRequestedImpl _value,
      $Res Function(_$GoogleSignInRequestedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthBlocEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GoogleSignInRequestedImpl implements GoogleSignInRequested {
  const _$GoogleSignInRequestedImpl();

  @override
  String toString() {
    return 'AuthBlocEvent.googleSignInRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoogleSignInRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() googleSignInRequested,
    required TResult Function(String email, String password, String name)
        emailSignUpRequested,
    required TResult Function(String email, String password)
        emailSignInRequested,
    required TResult Function() signOutRequested,
    required TResult Function(dynamic user) authStateChanged,
    required TResult Function() appleSignInRequested,
    required TResult Function() startAuthListening,
  }) {
    return googleSignInRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? googleSignInRequested,
    TResult? Function(String email, String password, String name)?
        emailSignUpRequested,
    TResult? Function(String email, String password)? emailSignInRequested,
    TResult? Function()? signOutRequested,
    TResult? Function(dynamic user)? authStateChanged,
    TResult? Function()? appleSignInRequested,
    TResult? Function()? startAuthListening,
  }) {
    return googleSignInRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? googleSignInRequested,
    TResult Function(String email, String password, String name)?
        emailSignUpRequested,
    TResult Function(String email, String password)? emailSignInRequested,
    TResult Function()? signOutRequested,
    TResult Function(dynamic user)? authStateChanged,
    TResult Function()? appleSignInRequested,
    TResult Function()? startAuthListening,
    required TResult orElse(),
  }) {
    if (googleSignInRequested != null) {
      return googleSignInRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GoogleSignInRequested value)
        googleSignInRequested,
    required TResult Function(EmailSignUpRequested value) emailSignUpRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
    required TResult Function(AuthStateChanged value) authStateChanged,
    required TResult Function(AppleSignInRequested value) appleSignInRequested,
    required TResult Function(StartAuthListening value) startAuthListening,
  }) {
    return googleSignInRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(EmailSignUpRequested value)? emailSignUpRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
    TResult? Function(AuthStateChanged value)? authStateChanged,
    TResult? Function(AppleSignInRequested value)? appleSignInRequested,
    TResult? Function(StartAuthListening value)? startAuthListening,
  }) {
    return googleSignInRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(EmailSignUpRequested value)? emailSignUpRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    TResult Function(AuthStateChanged value)? authStateChanged,
    TResult Function(AppleSignInRequested value)? appleSignInRequested,
    TResult Function(StartAuthListening value)? startAuthListening,
    required TResult orElse(),
  }) {
    if (googleSignInRequested != null) {
      return googleSignInRequested(this);
    }
    return orElse();
  }
}

abstract class GoogleSignInRequested implements AuthBlocEvent {
  const factory GoogleSignInRequested() = _$GoogleSignInRequestedImpl;
}

/// @nodoc
abstract class _$$EmailSignUpRequestedImplCopyWith<$Res> {
  factory _$$EmailSignUpRequestedImplCopyWith(_$EmailSignUpRequestedImpl value,
          $Res Function(_$EmailSignUpRequestedImpl) then) =
      __$$EmailSignUpRequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String password, String name});
}

/// @nodoc
class __$$EmailSignUpRequestedImplCopyWithImpl<$Res>
    extends _$AuthBlocEventCopyWithImpl<$Res, _$EmailSignUpRequestedImpl>
    implements _$$EmailSignUpRequestedImplCopyWith<$Res> {
  __$$EmailSignUpRequestedImplCopyWithImpl(_$EmailSignUpRequestedImpl _value,
      $Res Function(_$EmailSignUpRequestedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthBlocEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? name = null,
  }) {
    return _then(_$EmailSignUpRequestedImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$EmailSignUpRequestedImpl implements EmailSignUpRequested {
  const _$EmailSignUpRequestedImpl(
      {required this.email, required this.password, required this.name});

  @override
  final String email;
  @override
  final String password;
  @override
  final String name;

  @override
  String toString() {
    return 'AuthBlocEvent.emailSignUpRequested(email: $email, password: $password, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailSignUpRequestedImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password, name);

  /// Create a copy of AuthBlocEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailSignUpRequestedImplCopyWith<_$EmailSignUpRequestedImpl>
      get copyWith =>
          __$$EmailSignUpRequestedImplCopyWithImpl<_$EmailSignUpRequestedImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() googleSignInRequested,
    required TResult Function(String email, String password, String name)
        emailSignUpRequested,
    required TResult Function(String email, String password)
        emailSignInRequested,
    required TResult Function() signOutRequested,
    required TResult Function(dynamic user) authStateChanged,
    required TResult Function() appleSignInRequested,
    required TResult Function() startAuthListening,
  }) {
    return emailSignUpRequested(email, password, name);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? googleSignInRequested,
    TResult? Function(String email, String password, String name)?
        emailSignUpRequested,
    TResult? Function(String email, String password)? emailSignInRequested,
    TResult? Function()? signOutRequested,
    TResult? Function(dynamic user)? authStateChanged,
    TResult? Function()? appleSignInRequested,
    TResult? Function()? startAuthListening,
  }) {
    return emailSignUpRequested?.call(email, password, name);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? googleSignInRequested,
    TResult Function(String email, String password, String name)?
        emailSignUpRequested,
    TResult Function(String email, String password)? emailSignInRequested,
    TResult Function()? signOutRequested,
    TResult Function(dynamic user)? authStateChanged,
    TResult Function()? appleSignInRequested,
    TResult Function()? startAuthListening,
    required TResult orElse(),
  }) {
    if (emailSignUpRequested != null) {
      return emailSignUpRequested(email, password, name);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GoogleSignInRequested value)
        googleSignInRequested,
    required TResult Function(EmailSignUpRequested value) emailSignUpRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
    required TResult Function(AuthStateChanged value) authStateChanged,
    required TResult Function(AppleSignInRequested value) appleSignInRequested,
    required TResult Function(StartAuthListening value) startAuthListening,
  }) {
    return emailSignUpRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(EmailSignUpRequested value)? emailSignUpRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
    TResult? Function(AuthStateChanged value)? authStateChanged,
    TResult? Function(AppleSignInRequested value)? appleSignInRequested,
    TResult? Function(StartAuthListening value)? startAuthListening,
  }) {
    return emailSignUpRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(EmailSignUpRequested value)? emailSignUpRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    TResult Function(AuthStateChanged value)? authStateChanged,
    TResult Function(AppleSignInRequested value)? appleSignInRequested,
    TResult Function(StartAuthListening value)? startAuthListening,
    required TResult orElse(),
  }) {
    if (emailSignUpRequested != null) {
      return emailSignUpRequested(this);
    }
    return orElse();
  }
}

abstract class EmailSignUpRequested implements AuthBlocEvent {
  const factory EmailSignUpRequested(
      {required final String email,
      required final String password,
      required final String name}) = _$EmailSignUpRequestedImpl;

  String get email;
  String get password;
  String get name;

  /// Create a copy of AuthBlocEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmailSignUpRequestedImplCopyWith<_$EmailSignUpRequestedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EmailSignInRequestedImplCopyWith<$Res> {
  factory _$$EmailSignInRequestedImplCopyWith(_$EmailSignInRequestedImpl value,
          $Res Function(_$EmailSignInRequestedImpl) then) =
      __$$EmailSignInRequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class __$$EmailSignInRequestedImplCopyWithImpl<$Res>
    extends _$AuthBlocEventCopyWithImpl<$Res, _$EmailSignInRequestedImpl>
    implements _$$EmailSignInRequestedImplCopyWith<$Res> {
  __$$EmailSignInRequestedImplCopyWithImpl(_$EmailSignInRequestedImpl _value,
      $Res Function(_$EmailSignInRequestedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthBlocEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
  }) {
    return _then(_$EmailSignInRequestedImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$EmailSignInRequestedImpl implements EmailSignInRequested {
  const _$EmailSignInRequestedImpl(
      {required this.email, required this.password});

  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'AuthBlocEvent.emailSignInRequested(email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailSignInRequestedImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  /// Create a copy of AuthBlocEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailSignInRequestedImplCopyWith<_$EmailSignInRequestedImpl>
      get copyWith =>
          __$$EmailSignInRequestedImplCopyWithImpl<_$EmailSignInRequestedImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() googleSignInRequested,
    required TResult Function(String email, String password, String name)
        emailSignUpRequested,
    required TResult Function(String email, String password)
        emailSignInRequested,
    required TResult Function() signOutRequested,
    required TResult Function(dynamic user) authStateChanged,
    required TResult Function() appleSignInRequested,
    required TResult Function() startAuthListening,
  }) {
    return emailSignInRequested(email, password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? googleSignInRequested,
    TResult? Function(String email, String password, String name)?
        emailSignUpRequested,
    TResult? Function(String email, String password)? emailSignInRequested,
    TResult? Function()? signOutRequested,
    TResult? Function(dynamic user)? authStateChanged,
    TResult? Function()? appleSignInRequested,
    TResult? Function()? startAuthListening,
  }) {
    return emailSignInRequested?.call(email, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? googleSignInRequested,
    TResult Function(String email, String password, String name)?
        emailSignUpRequested,
    TResult Function(String email, String password)? emailSignInRequested,
    TResult Function()? signOutRequested,
    TResult Function(dynamic user)? authStateChanged,
    TResult Function()? appleSignInRequested,
    TResult Function()? startAuthListening,
    required TResult orElse(),
  }) {
    if (emailSignInRequested != null) {
      return emailSignInRequested(email, password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GoogleSignInRequested value)
        googleSignInRequested,
    required TResult Function(EmailSignUpRequested value) emailSignUpRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
    required TResult Function(AuthStateChanged value) authStateChanged,
    required TResult Function(AppleSignInRequested value) appleSignInRequested,
    required TResult Function(StartAuthListening value) startAuthListening,
  }) {
    return emailSignInRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(EmailSignUpRequested value)? emailSignUpRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
    TResult? Function(AuthStateChanged value)? authStateChanged,
    TResult? Function(AppleSignInRequested value)? appleSignInRequested,
    TResult? Function(StartAuthListening value)? startAuthListening,
  }) {
    return emailSignInRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(EmailSignUpRequested value)? emailSignUpRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    TResult Function(AuthStateChanged value)? authStateChanged,
    TResult Function(AppleSignInRequested value)? appleSignInRequested,
    TResult Function(StartAuthListening value)? startAuthListening,
    required TResult orElse(),
  }) {
    if (emailSignInRequested != null) {
      return emailSignInRequested(this);
    }
    return orElse();
  }
}

abstract class EmailSignInRequested implements AuthBlocEvent {
  const factory EmailSignInRequested(
      {required final String email,
      required final String password}) = _$EmailSignInRequestedImpl;

  String get email;
  String get password;

  /// Create a copy of AuthBlocEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmailSignInRequestedImplCopyWith<_$EmailSignInRequestedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SignOutRequestedImplCopyWith<$Res> {
  factory _$$SignOutRequestedImplCopyWith(_$SignOutRequestedImpl value,
          $Res Function(_$SignOutRequestedImpl) then) =
      __$$SignOutRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignOutRequestedImplCopyWithImpl<$Res>
    extends _$AuthBlocEventCopyWithImpl<$Res, _$SignOutRequestedImpl>
    implements _$$SignOutRequestedImplCopyWith<$Res> {
  __$$SignOutRequestedImplCopyWithImpl(_$SignOutRequestedImpl _value,
      $Res Function(_$SignOutRequestedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthBlocEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SignOutRequestedImpl implements SignOutRequested {
  const _$SignOutRequestedImpl();

  @override
  String toString() {
    return 'AuthBlocEvent.signOutRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SignOutRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() googleSignInRequested,
    required TResult Function(String email, String password, String name)
        emailSignUpRequested,
    required TResult Function(String email, String password)
        emailSignInRequested,
    required TResult Function() signOutRequested,
    required TResult Function(dynamic user) authStateChanged,
    required TResult Function() appleSignInRequested,
    required TResult Function() startAuthListening,
  }) {
    return signOutRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? googleSignInRequested,
    TResult? Function(String email, String password, String name)?
        emailSignUpRequested,
    TResult? Function(String email, String password)? emailSignInRequested,
    TResult? Function()? signOutRequested,
    TResult? Function(dynamic user)? authStateChanged,
    TResult? Function()? appleSignInRequested,
    TResult? Function()? startAuthListening,
  }) {
    return signOutRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? googleSignInRequested,
    TResult Function(String email, String password, String name)?
        emailSignUpRequested,
    TResult Function(String email, String password)? emailSignInRequested,
    TResult Function()? signOutRequested,
    TResult Function(dynamic user)? authStateChanged,
    TResult Function()? appleSignInRequested,
    TResult Function()? startAuthListening,
    required TResult orElse(),
  }) {
    if (signOutRequested != null) {
      return signOutRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GoogleSignInRequested value)
        googleSignInRequested,
    required TResult Function(EmailSignUpRequested value) emailSignUpRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
    required TResult Function(AuthStateChanged value) authStateChanged,
    required TResult Function(AppleSignInRequested value) appleSignInRequested,
    required TResult Function(StartAuthListening value) startAuthListening,
  }) {
    return signOutRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(EmailSignUpRequested value)? emailSignUpRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
    TResult? Function(AuthStateChanged value)? authStateChanged,
    TResult? Function(AppleSignInRequested value)? appleSignInRequested,
    TResult? Function(StartAuthListening value)? startAuthListening,
  }) {
    return signOutRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(EmailSignUpRequested value)? emailSignUpRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    TResult Function(AuthStateChanged value)? authStateChanged,
    TResult Function(AppleSignInRequested value)? appleSignInRequested,
    TResult Function(StartAuthListening value)? startAuthListening,
    required TResult orElse(),
  }) {
    if (signOutRequested != null) {
      return signOutRequested(this);
    }
    return orElse();
  }
}

abstract class SignOutRequested implements AuthBlocEvent {
  const factory SignOutRequested() = _$SignOutRequestedImpl;
}

/// @nodoc
abstract class _$$AuthStateChangedImplCopyWith<$Res> {
  factory _$$AuthStateChangedImplCopyWith(_$AuthStateChangedImpl value,
          $Res Function(_$AuthStateChangedImpl) then) =
      __$$AuthStateChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({dynamic user});
}

/// @nodoc
class __$$AuthStateChangedImplCopyWithImpl<$Res>
    extends _$AuthBlocEventCopyWithImpl<$Res, _$AuthStateChangedImpl>
    implements _$$AuthStateChangedImplCopyWith<$Res> {
  __$$AuthStateChangedImplCopyWithImpl(_$AuthStateChangedImpl _value,
      $Res Function(_$AuthStateChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthBlocEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
  }) {
    return _then(_$AuthStateChangedImpl(
      freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$AuthStateChangedImpl implements AuthStateChanged {
  const _$AuthStateChangedImpl(this.user);

  @override
  final dynamic user;

  @override
  String toString() {
    return 'AuthBlocEvent.authStateChanged(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateChangedImpl &&
            const DeepCollectionEquality().equals(other.user, user));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(user));

  /// Create a copy of AuthBlocEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthStateChangedImplCopyWith<_$AuthStateChangedImpl> get copyWith =>
      __$$AuthStateChangedImplCopyWithImpl<_$AuthStateChangedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() googleSignInRequested,
    required TResult Function(String email, String password, String name)
        emailSignUpRequested,
    required TResult Function(String email, String password)
        emailSignInRequested,
    required TResult Function() signOutRequested,
    required TResult Function(dynamic user) authStateChanged,
    required TResult Function() appleSignInRequested,
    required TResult Function() startAuthListening,
  }) {
    return authStateChanged(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? googleSignInRequested,
    TResult? Function(String email, String password, String name)?
        emailSignUpRequested,
    TResult? Function(String email, String password)? emailSignInRequested,
    TResult? Function()? signOutRequested,
    TResult? Function(dynamic user)? authStateChanged,
    TResult? Function()? appleSignInRequested,
    TResult? Function()? startAuthListening,
  }) {
    return authStateChanged?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? googleSignInRequested,
    TResult Function(String email, String password, String name)?
        emailSignUpRequested,
    TResult Function(String email, String password)? emailSignInRequested,
    TResult Function()? signOutRequested,
    TResult Function(dynamic user)? authStateChanged,
    TResult Function()? appleSignInRequested,
    TResult Function()? startAuthListening,
    required TResult orElse(),
  }) {
    if (authStateChanged != null) {
      return authStateChanged(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GoogleSignInRequested value)
        googleSignInRequested,
    required TResult Function(EmailSignUpRequested value) emailSignUpRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
    required TResult Function(AuthStateChanged value) authStateChanged,
    required TResult Function(AppleSignInRequested value) appleSignInRequested,
    required TResult Function(StartAuthListening value) startAuthListening,
  }) {
    return authStateChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(EmailSignUpRequested value)? emailSignUpRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
    TResult? Function(AuthStateChanged value)? authStateChanged,
    TResult? Function(AppleSignInRequested value)? appleSignInRequested,
    TResult? Function(StartAuthListening value)? startAuthListening,
  }) {
    return authStateChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(EmailSignUpRequested value)? emailSignUpRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    TResult Function(AuthStateChanged value)? authStateChanged,
    TResult Function(AppleSignInRequested value)? appleSignInRequested,
    TResult Function(StartAuthListening value)? startAuthListening,
    required TResult orElse(),
  }) {
    if (authStateChanged != null) {
      return authStateChanged(this);
    }
    return orElse();
  }
}

abstract class AuthStateChanged implements AuthBlocEvent {
  const factory AuthStateChanged(final dynamic user) = _$AuthStateChangedImpl;

  dynamic get user;

  /// Create a copy of AuthBlocEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthStateChangedImplCopyWith<_$AuthStateChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AppleSignInRequestedImplCopyWith<$Res> {
  factory _$$AppleSignInRequestedImplCopyWith(_$AppleSignInRequestedImpl value,
          $Res Function(_$AppleSignInRequestedImpl) then) =
      __$$AppleSignInRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AppleSignInRequestedImplCopyWithImpl<$Res>
    extends _$AuthBlocEventCopyWithImpl<$Res, _$AppleSignInRequestedImpl>
    implements _$$AppleSignInRequestedImplCopyWith<$Res> {
  __$$AppleSignInRequestedImplCopyWithImpl(_$AppleSignInRequestedImpl _value,
      $Res Function(_$AppleSignInRequestedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthBlocEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AppleSignInRequestedImpl implements AppleSignInRequested {
  const _$AppleSignInRequestedImpl();

  @override
  String toString() {
    return 'AuthBlocEvent.appleSignInRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppleSignInRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() googleSignInRequested,
    required TResult Function(String email, String password, String name)
        emailSignUpRequested,
    required TResult Function(String email, String password)
        emailSignInRequested,
    required TResult Function() signOutRequested,
    required TResult Function(dynamic user) authStateChanged,
    required TResult Function() appleSignInRequested,
    required TResult Function() startAuthListening,
  }) {
    return appleSignInRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? googleSignInRequested,
    TResult? Function(String email, String password, String name)?
        emailSignUpRequested,
    TResult? Function(String email, String password)? emailSignInRequested,
    TResult? Function()? signOutRequested,
    TResult? Function(dynamic user)? authStateChanged,
    TResult? Function()? appleSignInRequested,
    TResult? Function()? startAuthListening,
  }) {
    return appleSignInRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? googleSignInRequested,
    TResult Function(String email, String password, String name)?
        emailSignUpRequested,
    TResult Function(String email, String password)? emailSignInRequested,
    TResult Function()? signOutRequested,
    TResult Function(dynamic user)? authStateChanged,
    TResult Function()? appleSignInRequested,
    TResult Function()? startAuthListening,
    required TResult orElse(),
  }) {
    if (appleSignInRequested != null) {
      return appleSignInRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GoogleSignInRequested value)
        googleSignInRequested,
    required TResult Function(EmailSignUpRequested value) emailSignUpRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
    required TResult Function(AuthStateChanged value) authStateChanged,
    required TResult Function(AppleSignInRequested value) appleSignInRequested,
    required TResult Function(StartAuthListening value) startAuthListening,
  }) {
    return appleSignInRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(EmailSignUpRequested value)? emailSignUpRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
    TResult? Function(AuthStateChanged value)? authStateChanged,
    TResult? Function(AppleSignInRequested value)? appleSignInRequested,
    TResult? Function(StartAuthListening value)? startAuthListening,
  }) {
    return appleSignInRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(EmailSignUpRequested value)? emailSignUpRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    TResult Function(AuthStateChanged value)? authStateChanged,
    TResult Function(AppleSignInRequested value)? appleSignInRequested,
    TResult Function(StartAuthListening value)? startAuthListening,
    required TResult orElse(),
  }) {
    if (appleSignInRequested != null) {
      return appleSignInRequested(this);
    }
    return orElse();
  }
}

abstract class AppleSignInRequested implements AuthBlocEvent {
  const factory AppleSignInRequested() = _$AppleSignInRequestedImpl;
}

/// @nodoc
abstract class _$$StartAuthListeningImplCopyWith<$Res> {
  factory _$$StartAuthListeningImplCopyWith(_$StartAuthListeningImpl value,
          $Res Function(_$StartAuthListeningImpl) then) =
      __$$StartAuthListeningImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StartAuthListeningImplCopyWithImpl<$Res>
    extends _$AuthBlocEventCopyWithImpl<$Res, _$StartAuthListeningImpl>
    implements _$$StartAuthListeningImplCopyWith<$Res> {
  __$$StartAuthListeningImplCopyWithImpl(_$StartAuthListeningImpl _value,
      $Res Function(_$StartAuthListeningImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthBlocEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StartAuthListeningImpl implements StartAuthListening {
  const _$StartAuthListeningImpl();

  @override
  String toString() {
    return 'AuthBlocEvent.startAuthListening()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StartAuthListeningImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() googleSignInRequested,
    required TResult Function(String email, String password, String name)
        emailSignUpRequested,
    required TResult Function(String email, String password)
        emailSignInRequested,
    required TResult Function() signOutRequested,
    required TResult Function(dynamic user) authStateChanged,
    required TResult Function() appleSignInRequested,
    required TResult Function() startAuthListening,
  }) {
    return startAuthListening();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? googleSignInRequested,
    TResult? Function(String email, String password, String name)?
        emailSignUpRequested,
    TResult? Function(String email, String password)? emailSignInRequested,
    TResult? Function()? signOutRequested,
    TResult? Function(dynamic user)? authStateChanged,
    TResult? Function()? appleSignInRequested,
    TResult? Function()? startAuthListening,
  }) {
    return startAuthListening?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? googleSignInRequested,
    TResult Function(String email, String password, String name)?
        emailSignUpRequested,
    TResult Function(String email, String password)? emailSignInRequested,
    TResult Function()? signOutRequested,
    TResult Function(dynamic user)? authStateChanged,
    TResult Function()? appleSignInRequested,
    TResult Function()? startAuthListening,
    required TResult orElse(),
  }) {
    if (startAuthListening != null) {
      return startAuthListening();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GoogleSignInRequested value)
        googleSignInRequested,
    required TResult Function(EmailSignUpRequested value) emailSignUpRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
    required TResult Function(AuthStateChanged value) authStateChanged,
    required TResult Function(AppleSignInRequested value) appleSignInRequested,
    required TResult Function(StartAuthListening value) startAuthListening,
  }) {
    return startAuthListening(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(EmailSignUpRequested value)? emailSignUpRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
    TResult? Function(AuthStateChanged value)? authStateChanged,
    TResult? Function(AppleSignInRequested value)? appleSignInRequested,
    TResult? Function(StartAuthListening value)? startAuthListening,
  }) {
    return startAuthListening?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(EmailSignUpRequested value)? emailSignUpRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    TResult Function(AuthStateChanged value)? authStateChanged,
    TResult Function(AppleSignInRequested value)? appleSignInRequested,
    TResult Function(StartAuthListening value)? startAuthListening,
    required TResult orElse(),
  }) {
    if (startAuthListening != null) {
      return startAuthListening(this);
    }
    return orElse();
  }
}

abstract class StartAuthListening implements AuthBlocEvent {
  const factory StartAuthListening() = _$StartAuthListeningImpl;
}

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String uid) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String uid)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String uid)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'AuthState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String uid) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String uid)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String uid)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements AuthState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'AuthState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String uid) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String uid)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String uid)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements AuthState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$AuthenticatedImplCopyWith<$Res> {
  factory _$$AuthenticatedImplCopyWith(
          _$AuthenticatedImpl value, $Res Function(_$AuthenticatedImpl) then) =
      __$$AuthenticatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String uid});
}

/// @nodoc
class __$$AuthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthenticatedImpl>
    implements _$$AuthenticatedImplCopyWith<$Res> {
  __$$AuthenticatedImplCopyWithImpl(
      _$AuthenticatedImpl _value, $Res Function(_$AuthenticatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
  }) {
    return _then(_$AuthenticatedImpl(
      null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthenticatedImpl implements _Authenticated {
  const _$AuthenticatedImpl(this.uid);

  @override
  final String uid;

  @override
  String toString() {
    return 'AuthState.authenticated(uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticatedImpl &&
            (identical(other.uid, uid) || other.uid == uid));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uid);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticatedImplCopyWith<_$AuthenticatedImpl> get copyWith =>
      __$$AuthenticatedImplCopyWithImpl<_$AuthenticatedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String uid) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String message) error,
  }) {
    return authenticated(uid);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String uid)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String message)? error,
  }) {
    return authenticated?.call(uid);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String uid)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(uid);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Error value) error,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Error value)? error,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class _Authenticated implements AuthState {
  const factory _Authenticated(final String uid) = _$AuthenticatedImpl;

  String get uid;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthenticatedImplCopyWith<_$AuthenticatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnauthenticatedImplCopyWith<$Res> {
  factory _$$UnauthenticatedImplCopyWith(_$UnauthenticatedImpl value,
          $Res Function(_$UnauthenticatedImpl) then) =
      __$$UnauthenticatedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnauthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$UnauthenticatedImpl>
    implements _$$UnauthenticatedImplCopyWith<$Res> {
  __$$UnauthenticatedImplCopyWithImpl(
      _$UnauthenticatedImpl _value, $Res Function(_$UnauthenticatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UnauthenticatedImpl implements _Unauthenticated {
  const _$UnauthenticatedImpl();

  @override
  String toString() {
    return 'AuthState.unauthenticated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UnauthenticatedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String uid) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String message) error,
  }) {
    return unauthenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String uid)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String message)? error,
  }) {
    return unauthenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String uid)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Error value) error,
  }) {
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Error value)? error,
  }) {
    return unauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }
}

abstract class _Unauthenticated implements AuthState {
  const factory _Unauthenticated() = _$UnauthenticatedImpl;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AuthState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String uid) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String uid)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String uid)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements AuthState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
