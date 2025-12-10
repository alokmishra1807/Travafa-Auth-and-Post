part of 'post_detail_bloc.dart';

@immutable
abstract class PostDetailState {}

class PostDetailInitial extends PostDetailState {}

class PostDetailLoading extends PostDetailState {}

class PostDetailLoaded extends PostDetailState {
  final PostModel post;

  PostDetailLoaded(this.post);
}

class PostDetailError extends PostDetailState {
  final String message;

  PostDetailError(this.message);
}

