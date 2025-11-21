import 'package:flutter/material.dart';

/// A circular badge widget that displays the number of comments
/// Positioned as an overlay on the top-right corner of an image
class CommentBadge extends StatelessWidget {
  final int commentCount;
  final double size;
  final Color backgroundColor;
  final Color textColor;

  const CommentBadge({
    super.key,
    required this.commentCount,
    this.size = 32.0,
    this.backgroundColor = Colors.orange,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    if (commentCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          commentCount > 99 ? '99+' : commentCount.toString(),
          style: TextStyle(
            color: textColor,
            fontSize: size * 0.45,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
