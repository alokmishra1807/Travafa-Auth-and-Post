import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travafa/features/auth/domain/usecases/login_usecase.dart';
import 'package:travafa/features/auth/domain/usecases/signup_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase _userSignUp;
   final LoginUseCase _userLogin;

  AuthBloc({
    required SignUpUseCase userSignUp,
    required LoginUseCase userLogin,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
  }

  Future<void> _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _userSignUp(
      SignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
  (failure) => emit(AuthFailure(failure.message)),
  (user) => emit(AuthSuccess(
      userId: user.id,
      username: user.name,
  )),
);
  }

  Future<void> _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _userLogin(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );

res.fold(
  (failure) => emit(AuthFailure(failure.message)),
  (user) => emit(AuthSuccess(
      userId: user.id,
      username: user.name,
  )),
);
  }

  // void _emitAuthSuccess(String value, Emitter<AuthState> emit) {
    // `value` is the String your usecase returns (could be userId or a message)
  //  emit(AuthSuccess(uid: value));
  }

