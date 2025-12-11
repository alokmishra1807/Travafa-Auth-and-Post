part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileError extends UserProfileState {
  final String message;
  UserProfileError(this.message);
}

class UserProfileLoaded extends UserProfileState {
  final String userId;
  final String username;
  final bool isCurrentUser;
  final bool isPrivate;
  final List<PostModel> posts;

  UserProfileLoaded({
    required this.userId,
    required this.username,
    required this.isCurrentUser,
    required this.isPrivate,
    required this.posts,
  });

  UserProfileLoaded copyWith({
    String? userId,
    String? username,
    bool? isCurrentUser,
    bool? isPrivate,
    List<PostModel>? posts,
  }) {
    return UserProfileLoaded(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      isPrivate: isPrivate ?? this.isPrivate,
      posts: posts ?? this.posts,
    );
  }
}
