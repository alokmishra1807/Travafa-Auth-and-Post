

import 'package:fpdart/fpdart.dart';
import 'package:travafa/core/error/failure.dart';
import 'package:travafa/core/usecases/usecase.dart';
import 'package:travafa/features/post/domain/repository/post_repository.dart';

class DeletePostUseCase implements UseCase<void, DeletePostParams> {
  final PostRepository _repository;

  DeletePostUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(DeletePostParams params) {
    return _repository.deletePost(params.postId);
  }
}

class DeletePostParams {
  final String postId;
  const DeletePostParams(this.postId);
}
