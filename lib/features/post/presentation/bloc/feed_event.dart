part of 'feed_bloc.dart';

abstract class FeedEvent {}

class LoadFeedEvent extends FeedEvent {}

class CreatePostEvent extends FeedEvent {
  final String userId;
  final String username;
  final String content;

  CreatePostEvent({
    required this.userId,
    required this.username,
    required this.content,
  });
}

class DeletePostEvent extends FeedEvent {
  final String postId;

  DeletePostEvent(this.postId);
}
