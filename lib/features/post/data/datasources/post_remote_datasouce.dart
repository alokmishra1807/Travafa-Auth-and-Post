import 'dart:async';

import 'package:travafa/core/error/exception.dart';
import 'package:travafa/features/post/data/model/post_model.dart';



abstract interface class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();
  Future<PostModel> createPost({
    required String userId,
    required String username,
    required String content,
  });
  Future<void> deletePost(String postId);
  Future<PostModel> getPostById(String postId);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final List<PostModel> _posts = [];

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      await Future.delayed(const Duration(milliseconds: 700)); // loading

      // newest first
      final sorted = List<PostModel>.from(_posts)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return sorted;
    } catch (e) {
      throw ServerException('Failed to load posts: $e');
    }
  }

  @override
  Future<PostModel> createPost({
    required String userId,
    required String username,
    required String content,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      if (content.trim().isEmpty) {
        throw const ServerException('Post content cannot be empty');
      }

      final post = PostModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        username: username,
        content: content.trim(),
        createdAt: DateTime.now(),
      );

      _posts.add(post);
      return post;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to create post: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final before = _posts.length;
      _posts.removeWhere((p) => p.id == postId);

      if (_posts.length == before) {
        throw const ServerException('Post not found');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to delete post: $e');
    }
  }

  @override
  Future<PostModel> getPostById(String postId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final post = _posts.firstWhere(
        (p) => p.id == postId,
        orElse: () => throw const ServerException('Post not found'),
      );
      return post;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to load post detail: $e');
    }
  }
}
