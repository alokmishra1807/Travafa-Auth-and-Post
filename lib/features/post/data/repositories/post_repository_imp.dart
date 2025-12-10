import 'package:fpdart/fpdart.dart';
import 'package:travafa/core/error/exception.dart';
import 'package:travafa/core/error/failure.dart';
import 'package:travafa/features/post/data/datasources/post_remote_datasouce.dart';
import 'package:travafa/features/post/data/model/post_model.dart';
import 'package:travafa/features/post/domain/repository/post_repository.dart';


class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource _remote;

  PostRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<PostModel>>> getPosts() async {
    try {
      final posts = await _remote.getPosts();
      return right(posts);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostModel>> createPost({
    required String userId,
    required String username,
    required String content,
  }) async {
    try {
      final post = await _remote.createPost(
        userId: userId,
        username: username,
        content: content,
      );
      return right(post);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    try {
      await _remote.deletePost(postId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostModel>> getPostById(String postId) async {
    try {
      final post = await _remote.getPostById(postId);
      return right(post);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
