import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

/// Chat bubble from the Hỏi HR mockups: employee messages are tinted and
/// right-aligned, assistant replies are white, bordered and left-aligned.
class HrChatBubble extends StatelessWidget {
  const HrChatBubble({super.key, required this.text, required this.fromUser});

  final String text;
  final bool fromUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: 0.86,
        alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Align(
          alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: fromUser ? AppHrPalette.accentSoft : AppHrPalette.surface,
              borderRadius: AppRadius.mdAll,
              border: fromUser ? null : Border.all(color: AppHrPalette.border),
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: AppHrPalette.ink,
                fontSize: 14.5,
                height: 1.45,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
