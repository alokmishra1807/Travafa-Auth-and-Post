import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:travafa/features/post/data/model/post_model.dart';
import 'package:travafa/features/post/domain/usecases/create_post_usecase.dart';
import 'package:travafa/features/post/domain/usecases/delete_post_usercase.dart';
import 'package:travafa/features/post/domain/usecases/get_post_usecase.dart';


part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetPostsUseCase _getPosts;
  final CreatePostUseCase _createPost;
  final DeletePostUseCase _deletePost;

  FeedBloc({
    required GetPostsUseCase getPosts,
    required CreatePostUseCase createPost,
    required DeletePostUseCase deletePost,
  })  : _getPosts = getPosts,
        _createPost = createPost,
        _deletePost = deletePost,
        super(FeedInitial()) {
    on<LoadFeedEvent>(_onLoadFeed);
    on<CreatePostEvent>(_onCreatePost);
    on<DeletePostEvent>(_onDeletePost);
  }

  Future<void> _onLoadFeed(
    LoadFeedEvent event,
    Emitter<FeedState> emit,
  ) async {
    emit(FeedLoading());
    final res = await _getPosts(const NoParams());
    res.fold(
      (failure) => emit(FeedError(failure.message)),
      (posts) => posts.isEmpty ? emit(FeedEmpty()) : emit(FeedLoaded(posts)),
    );
  }

  Future<void> _onCreatePost(
    CreatePostEvent event,
    Emitter<FeedState> emit,
  ) async {
    emit(FeedPosting()); // for showing loading while posting

    final res = await _createPost(
      CreatePostParams(
        userId: event.userId,
        username: event.username,
        content: event.content,
      ),
    );

    await res.fold(
      (failure) async => emit(FeedError(failure.message)),
      (_) async {
        // reload feed after successful post
        final result = await _getPosts(const NoParams());
        result.fold(
          (failure) => emit(FeedError(failure.message)),
          (posts) =>
              posts.isEmpty ? emit(FeedEmpty()) : emit(FeedLoaded(posts)),
        );
      },
    );
  }

  Future<void> _onDeletePost(
    DeletePostEvent event,
    Emitter<FeedState> emit,
  ) async {
    emit(FeedDeleting(event.postId));

    final res = await _deletePost(DeletePostParams(event.postId));

    await res.fold(
      (failure) async => emit(FeedError(failure.message)),
      (_) async {
        final result = await _getPosts(const NoParams());
        result.fold(
          (failure) => emit(FeedError(failure.message)),
          (posts) =>
              posts.isEmpty ? emit(FeedEmpty()) : emit(FeedLoaded(posts)),
        );
      },
    );
  }
}
