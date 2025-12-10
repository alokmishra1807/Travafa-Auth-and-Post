
import 'package:fpdart/fpdart.dart';
import 'package:travafa/core/error/failure.dart';
import 'package:travafa/core/usecases/usecase.dart';
import 'package:travafa/features/auth/data/model/user_model.dart';
import 'package:travafa/features/auth/domain/repository/auth_repository.dart';

class LoginUseCase implements UseCase<UserModel, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel>> call(LoginParams params) {
    return repository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}



class LoginParams {
 
  final String email;
  final String password;

  const LoginParams({
    
    required this.email,
    required this.password,
  });
}
