import 'package:flutter/material.dart';

enum AppState { loading, empty, error, noNetwork, success }

class AppStateWidget extends StatelessWidget {
  final AppState state;
  final String? message;
  final Widget? child;
  final VoidCallback? onRetry;

  const AppStateWidget({
    super.key,
    required this.state,
    this.message,
    this.child,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case AppState.loading:
        return const Center(child: CircularProgressIndicator());

      case AppState.empty:
        return _buildMessage(
          icon: Icons.inbox,
          text: message ?? "No items found",
        );

      case AppState.error:
        return _buildMessage(
          icon: Icons.error,
          text: message ?? "Something went wrong",
          retry: onRetry,
        );

      case AppState.noNetwork:
        return _buildMessage(
          icon: Icons.wifi_off,
          text: message ?? "No Internet Connection",
          retry: onRetry,
        );

      case AppState.success:
        return child ?? const SizedBox.shrink();
    }
  }

  Widget _buildMessage({
    required IconData icon,
    required String text,
    VoidCallback? retry,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          Text(text, style: const TextStyle(fontSize: 16)),
          if (retry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(onPressed: retry, child: const Text("Retry")),
          ],
        ],
      ),
    );
  }
}
