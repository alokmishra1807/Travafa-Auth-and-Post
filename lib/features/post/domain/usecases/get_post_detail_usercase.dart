

import 'package:fpdart/fpdart.dart';
import 'package:travafa/core/error/failure.dart';
import 'package:travafa/core/usecases/usecase.dart';
import 'package:travafa/features/post/data/model/post_model.dart';
import 'package:travafa/features/post/domain/repository/post_repository.dart';

class GetPostDetailUseCase implements UseCase<PostModel, GetPostDetailParams> {
  final PostRepository _repository;

  GetPostDetailUseCase(this._repository);

  @override
  Future<Either<Failure, PostModel>> call(GetPostDetailParams params) {
    return _repository.getPostById(params.postId);
  }
}

class GetPostDetailParams {
  final String postId;

  const GetPostDetailParams({required this.postId});
}

