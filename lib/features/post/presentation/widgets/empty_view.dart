import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyView({
    super.key,
    required this.message,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
