

import 'package:fpdart/fpdart.dart';
import 'package:travafa/core/error/failure.dart';
import 'package:travafa/core/usecases/usecase.dart';
import 'package:travafa/features/post/data/model/post_model.dart';
import 'package:travafa/features/post/domain/repository/post_repository.dart';

class GetPostsUseCase implements UseCase<List<PostModel>, NoParams> {
  final PostRepository _repository;

  GetPostsUseCase(this._repository);

  @override
  Future<Either<Failure, List<PostModel>>> call(NoParams params) {
    return _repository.getPosts();
  }
}

class NoParams {
  const NoParams();
}
