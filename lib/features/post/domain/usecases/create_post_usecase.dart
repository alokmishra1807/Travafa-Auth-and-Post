

import 'package:fpdart/fpdart.dart';
import 'package:travafa/core/error/failure.dart';
import 'package:travafa/core/usecases/usecase.dart';
import 'package:travafa/features/post/data/model/post_model.dart';
import 'package:travafa/features/post/domain/repository/post_repository.dart';

class CreatePostUseCase implements UseCase<PostModel, CreatePostParams> {
  final PostRepository _repository;

  CreatePostUseCase(this._repository);

  @override
  Future<Either<Failure, PostModel>> call(CreatePostParams params) {
    return _repository.createPost(
      userId: params.userId,
      username: params.username,
      content: params.content,
    );
  }
}

class CreatePostParams {
  final String userId;
  final String username;
  final String content;

  const CreatePostParams({
    required this.userId,
    required this.username,
    required this.content,
  });
}
