

import 'package:fpdart/fpdart.dart';
import 'package:travafa/core/error/failure.dart';
import 'package:travafa/features/auth/data/model/user_model.dart';


abstract interface class AuthRepository {
  Future<Either<Failure, UserModel>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, UserModel>> loginWithEmailPassword({
    required String email,
    required String password,
  });
 
}