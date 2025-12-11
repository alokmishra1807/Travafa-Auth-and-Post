import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:travafa/core/utils/profile_privacy.dart';
import 'package:travafa/features/post/data/model/post_model.dart';
import 'package:travafa/features/post/domain/repository/post_repository.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final PostRepository _postRepository;
  final ProfilePrivacyStore _privacyStore;

  UserProfileBloc({
    required PostRepository postRepository,
    required ProfilePrivacyStore privacyStore,
  })  : _postRepository = postRepository,
        _privacyStore = privacyStore,
        super(UserProfileInitial()) {
    on<LoadUserProfileEvent>(_onLoadProfile);
    on<TogglePrivacyEvent>(_onTogglePrivacy);
  }

  Future<void> _onLoadProfile(
    LoadUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());
    final isPrivate = _privacyStore.isPrivate(event.userId);

    final res = await _postRepository.getPosts();
    res.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (allPosts) {
        final userPosts = allPosts.where((p) => p.userId == event.userId).toList();
        emit(UserProfileLoaded(
          userId: event.userId,
          username: event.username,
          isCurrentUser: event.isCurrentUser,
          isPrivate: isPrivate,
          posts: userPosts,
        ));
      },
    );
  }

  Future<void> _onTogglePrivacy(
    TogglePrivacyEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    final s = state;
    if (s is! UserProfileLoaded) return;
    if (!s.isCurrentUser) return;

    final newVal = !s.isPrivate;
    _privacyStore.setPrivacy(s.userId, newVal);

    emit(s.copyWith(isPrivate: newVal));
  }
}
