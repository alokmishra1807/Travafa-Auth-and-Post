import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travafa/features/post/presentation/bloc/post_detail_bloc.dart';
import 'package:travafa/features/post/presentation/widgets/error_view.dart';
import 'package:travafa/features/post/presentation/widgets/user_avatar.dart';
import 'package:travafa/init_dependencies.dart';


class PostDetailPage extends StatelessWidget {
  final String postId;

  const PostDetailPage({
    super.key,
    required this.postId,
  });

  String _formatTimestamp(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<PostDetailBloc>()..add(LoadPostDetailEvent(postId: postId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Post Detail'),
        ),
        body: BlocBuilder<PostDetailBloc, PostDetailState>(
          builder: (context, state) {
            if (state is PostDetailLoading || state is PostDetailInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PostDetailError) {
              return ErrorView(
                message: state.message,
                onRetry: () {
                  context
                      .read<PostDetailBloc>()
                      .add(LoadPostDetailEvent(postId: postId));
                },
              );
            }

            if (state is PostDetailLoaded) {
              final post = state.post;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author info
                    Row(
                      children: [
                        UserAvatar(
                          username: post.username,
                          radius: 22,
                          onTap: () {
                            // TODO: Navigate to profile page
                          },
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            // TODO: Navigate to profile page
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                _formatTimestamp(post.createdAt),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    // Full content
                    Text(
                      post.content,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),

                    // Placeholder for future likes/comments
                    Text(
                      'Likes & comments: (future extension)',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
