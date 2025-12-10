part of 'feed_bloc.dart';

@immutable
abstract class FeedState {}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedPosting extends FeedState {}

class FeedDeleting extends FeedState {
  final String deletingPostId;
  FeedDeleting(this.deletingPostId);
}

class FeedLoaded extends FeedState {
  final List<PostModel> posts;
  FeedLoaded(this.posts);
}

class FeedEmpty extends FeedState {}

class FeedError extends FeedState {
  final String message;
  FeedError(this.message);
}
