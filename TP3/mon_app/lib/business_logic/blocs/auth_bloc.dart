import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository.dart';
import '../events/auth_event.dart';
import '../states/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo;

  AuthBloc(this._repo) : super(AuthState.initial) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthLogoutRequested>(_onLogout);
  }

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    // Écoute en continu l'état de connexion Firebase
    await emit.forEach<String?>(
      _repo.authStateChanges(),
      onData: (uid) {
        if (uid == null) {
          return const AuthState(status: AuthStatus.unauthenticated);
        }
        return AuthState(status: AuthStatus.authenticated, uid: uid);
      },
      onError: (e, _) =>
          AuthState(status: AuthStatus.failure, error: e.toString()),
    );
  }

  Future<void> _onLogin(
      AuthLoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      await _repo.signIn(event.email, event.password);
      // Pas besoin d'emit authenticated ici :
      // le stream authStateChanges() va le faire automatiquement.
    } catch (e) {
      emit(AuthState(status: AuthStatus.failure, error: e.toString()));
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> _onRegister(
      AuthRegisterRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      await _repo.signUp(event.email, event.password);
      // Stream fera la transition vers authenticated.
    } catch (e) {
      emit(AuthState(status: AuthStatus.failure, error: e.toString()));
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> _onLogout(
      AuthLogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    await _repo.signOut();
    // Stream fera la transition vers unauthenticated.
  }
}
