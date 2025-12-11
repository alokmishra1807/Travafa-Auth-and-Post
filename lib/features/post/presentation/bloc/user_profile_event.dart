part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileEvent {}

class LoadUserProfileEvent extends UserProfileEvent {
  final String userId;
  final String username;
  final bool isCurrentUser;

  LoadUserProfileEvent({
    required this.userId,
    required this.username,
    required this.isCurrentUser,
  });
}

class TogglePrivacyEvent extends UserProfileEvent {}
