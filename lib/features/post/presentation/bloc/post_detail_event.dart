part of 'post_detail_bloc.dart';

@immutable
abstract class PostDetailEvent {}

class LoadPostDetailEvent extends PostDetailEvent {
  final String postId;

  LoadPostDetailEvent({required this.postId});
}
