import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:travafa/features/post/presentation/pages/post_detail_page.dart';
import 'package:travafa/features/post/presentation/widgets/empty_view.dart';
import 'package:travafa/features/post/presentation/widgets/error_view.dart';
import 'package:travafa/features/post/presentation/widgets/post_list_item.dart';
import 'package:travafa/features/post/presentation/widgets/user_avatar.dart';
import 'package:travafa/init_dependencies.dart';
import '../bloc/user_profile_bloc.dart';

class UserProfilePage extends StatelessWidget {
  final String userId;
  final String username;
  final bool isCurrentUser;

  const UserProfilePage({
    super.key,
    required this.userId,
    required this.username,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<UserProfileBloc>()
        ..add(LoadUserProfileEvent(
          userId: userId,
          username: username,
          isCurrentUser: isCurrentUser,
        )),
      child: Scaffold(
        appBar: AppBar(title: Text(username)),
        body: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading || state is UserProfileInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UserProfileError) {
              return ErrorView(
                message: state.message,
                onRetry: () {
                  context.read<UserProfileBloc>().add(LoadUserProfileEvent(
                    userId: userId,
                    username: username,
                    isCurrentUser: isCurrentUser,
                  ));
                },
              );
            }

            if (state is UserProfileLoaded) {
              final isPrivate = state.isPrivate;
              final isOwner = state.isCurrentUser;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        UserAvatar(username: state.username, radius: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(state.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              const SizedBox(height: 4),
                              Text(isPrivate ? 'Private profile' : 'Public profile',
                                  style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        if (isOwner)
                          Row(
                            children: [
                              const Text('Private'),
                              Switch(
                                value: isPrivate,
                                onChanged: (_) {
                                  context.read<UserProfileBloc>().add(TogglePrivacyEvent());
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  const SizedBox(height: 8),

                  if (isPrivate && !isOwner)
                    const Expanded(child: Center(child: Text('This profile is private.')))
                  else
                    Expanded(
                      child: state.posts.isEmpty
                          ? const EmptyView(message: 'No posts from this user yet.')
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              itemCount: state.posts.length,
                              itemBuilder: (ctx, i) {
                                final post = state.posts[i];
                                return PostListItem(
                                  post: post,
                                  onTapPost: () {
                                    Navigator.of(ctx).push(MaterialPageRoute(
                                      builder: (_) => PostDetailPage(postId: post.id),
                                    ));
                                  },
                                  onTapUser: () {
                                    // already on profile
                                  },
                                  onDelete: isOwner ? null : null,
                                );
                              },
                            ),
                    ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
