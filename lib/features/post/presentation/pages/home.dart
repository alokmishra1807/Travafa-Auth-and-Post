import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:travafa/features/post/presentation/bloc/feed_bloc.dart';
import 'package:travafa/features/post/presentation/pages/post_detail_page.dart';
import 'package:travafa/features/post/presentation/widgets/empty_view.dart';
import 'package:travafa/features/post/presentation/widgets/error_view.dart';
import 'package:travafa/features/post/presentation/widgets/post_list_item.dart';
import 'package:travafa/init_dependencies.dart';

class FeedPage extends StatefulWidget {
  final String currentUserId;
  final String currentUsername;

  const FeedPage({
    super.key,
    required this.currentUserId,
    required this.currentUsername,
  });

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  void _openCreatePostBottomSheet(BuildContext blocContext) {
    final TextEditingController controller = TextEditingController();

    showModalBottomSheet(
      context: blocContext,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Create Post',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'What\'s on your mind?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isEmpty) return;

                    // 👇 use blocContext which is definitely under BlocProvider<FeedBloc>
                    blocContext.read<FeedBloc>().add(
                          CreatePostEvent(
                            userId: widget.currentUserId,
                            username: widget.currentUsername,
                            content: text,
                          ),
                        );

                    Navigator.of(sheetContext).pop();
                  },
                  child: const Text('Post'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext blocContext, String postId) {
    showDialog(
      context: blocContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text(
          'Are you sure you want to delete this post permanently?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              blocContext.read<FeedBloc>().add(DeletePostEvent(postId));
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // IMPORTANT:
    // 1. We create the FeedBloc here.
    // 2. We immediately dispatch LoadFeedEvent() once.
    return BlocProvider(
      create: (_) => serviceLocator<FeedBloc>()..add(LoadFeedEvent()),
      child: Builder(
        // This Builder gives us a new context *under* the BlocProvider.
        builder: (blocContext) {
          return Scaffold(
            appBar: AppBar(title: const Text('Home Feed')),
            body: BlocConsumer<FeedBloc, FeedState>(
              listener: (blocContext, state) {
                if (state is FeedError) {
                  ScaffoldMessenger.of(blocContext).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (blocContext, state) {
                if (state is FeedLoading || state is FeedPosting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is FeedError) {
                  return ErrorView(
                    message: state.message,
                    onRetry: () {
                      blocContext.read<FeedBloc>().add(LoadFeedEvent());
                    },
                  );
                }

                if (state is FeedEmpty) {
                  return EmptyView(
                    message: 'No posts yet. Be the first to post!',
                    onAction: () => _openCreatePostBottomSheet(blocContext),
                    actionLabel: 'Create Post',
                  );
                }

                if (state is FeedLoaded) {
                  final posts = state.posts;

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: posts.length,
                    itemBuilder: (itemContext, index) {
                      final post = posts[index];
                      return PostListItem(
                        post: post,
                        onTapPost: () {
                          Navigator.of(itemContext).push(
                            MaterialPageRoute(
                              builder: (_) => PostDetailPage(postId: post.id),
                            ),
                          );
                        },
                        onTapUser: () {
                          // TODO: Navigate to user profile page
                        },
                        onDelete: () {
                          _showDeleteConfirmation(blocContext, post.id);
                        },
                      );
                    },
                  );
                }

                if (state is FeedDeleting) {
                  // For assignment, simple loader while deleting is enough
                  return const Center(child: CircularProgressIndicator());
                }

                return const SizedBox.shrink();
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _openCreatePostBottomSheet(blocContext),
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
