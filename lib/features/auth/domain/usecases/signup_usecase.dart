
import 'package:fpdart/fpdart.dart';
import 'package:travafa/core/error/failure.dart';
import 'package:travafa/core/usecases/usecase.dart';
import 'package:travafa/features/auth/data/model/user_model.dart';
import 'package:travafa/features/auth/domain/repository/auth_repository.dart';

class SignUpUseCase implements UseCase<UserModel, SignUpParams> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel>> call(SignUpParams params) {
    return repository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpParams {
  final String name;
  final String email;
  final String password;

  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
