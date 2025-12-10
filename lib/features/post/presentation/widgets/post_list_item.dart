import 'package:flutter/material.dart';

import 'package:travafa/features/post/data/model/post_model.dart';
import 'package:travafa/features/post/presentation/widgets/user_avatar.dart';

class PostListItem extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onTapPost;
  final VoidCallback? onTapUser;
  final VoidCallback? onDelete;

  const PostListItem({
    super.key,
    required this.post,
    this.onTapPost,
    this.onTapUser,
    this.onDelete,
  });

  String _formatTimestamp(DateTime dateTime) {
    // Simple formatting. You can replace with intl for nicer format.
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')} '
        '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: InkWell(
        onTap: onTapPost,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar + username + timestamp + delete icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserAvatar(
                    username: post.username,
                    radius: 18,
                    onTap: onTapUser,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: onTapUser,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
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
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: onDelete,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Post text
              Text(
                post.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
