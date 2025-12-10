import 'package:fpdart/fpdart.dart';
import 'package:travafa/core/error/failure.dart';
import 'package:travafa/features/post/data/model/post_model.dart';


abstract interface class PostRepository {
  Future<Either<Failure, List<PostModel>>> getPosts();
  Future<Either<Failure, PostModel>> createPost({
    required String userId,
    required String username,
    required String content,
  });
  Future<Either<Failure, void>> deletePost(String postId);
  Future<Either<Failure, PostModel>> getPostById(String postId);
}
