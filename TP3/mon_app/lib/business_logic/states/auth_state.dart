import 'package:equatable/equatable.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? uid;
  final String? error;

  const AuthState({
    required this.status,
    this.uid,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? uid,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      uid: uid ?? this.uid,
      error: error,
    );
  }

  static const initial = AuthState(status: AuthStatus.initial);

  @override
  List<Object?> get props => [status, uid, error];
}
