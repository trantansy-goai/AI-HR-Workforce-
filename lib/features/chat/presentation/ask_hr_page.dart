import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/hr_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/hr_top_bar.dart';
import '../../../shared/widgets/hr_widgets.dart';
import '../application/chat_providers.dart';
import '../domain/entities/agent_item.dart';
import 'widgets/hr_answer_widgets.dart';

/// Tab 2: Hỏi HR (M03 · A4) — ask a policy question, jump to common topics,
/// and see how answers are handled (sample exchange + privacy notice).
///
/// Typing a question opens a new HR-assistant conversation with it. Phones
/// and portrait tablets show one column; landscape tablets put the question
/// area beside the sample exchange.
class AskHrPage extends ConsumerStatefulWidget {
  const AskHrPage({super.key});

  @override
  ConsumerState<AskHrPage> createState() => _AskHrPageState();
}

class _AskHrPageState extends ConsumerState<AskHrPage> {
  final _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _ask([String? text]) {
    final question = (text ?? _questionController.text).trim();
    if (question.isEmpty) return;
    _questionController.clear();
    FocusScope.of(context).unfocus();
    final id = AgentItem.newConversationId(AgentItem.hrAssistantId);
    context.push(AppRoutes.conversation(id, initialMessage: question));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Theme(
      data: hrScopedTheme(Theme.of(context)),
      child: Scaffold(
        backgroundColor: AppHrPalette.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              HrTopBar(
                title: l10n.homeAppBarTitle,
                actions: const [HrNotificationButton()],
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    if (width >= ResponsiveBreakpoints.wideTablet) {
                      return _buildWide();
                    }
                    return _buildSingleColumn(
                      isTablet: width >= ResponsiveBreakpoints.tablet,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleColumn({required bool isTablet}) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? AppSpacing.xl : AppSpacing.lg,
        vertical: isTablet ? AppSpacing.xxl : AppSpacing.xl,
      ),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ..._buildQuestionArea(),
                const SizedBox(height: AppSpacing.xl),
                ..._buildSampleExchange(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWide() {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildQuestionArea(large: true),
                  ),
                ),
                const SizedBox(width: AppSpacing.xxl),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildSampleExchange(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Heading, question field and topic shortcuts.
  List<Widget> _buildQuestionArea({bool large = false}) {
    final l10n = context.l10n;
    return [
      HrPageTitle(l10n.askHrTitle, large: large),
      const SizedBox(height: AppSpacing.lg),
      ValueListenableBuilder(
        valueListenable: _questionController,
        builder: (context, value, _) => TextField(
          controller: _questionController,
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => _ask(),
          decoration: InputDecoration(
            hintText: l10n.askHrSearchPrompt,
            suffixIcon: value.text.trim().isEmpty
                ? null
                : IconButton(
                    tooltip: l10n.askHrSend,
                    onPressed: _ask,
                    icon: const Icon(
                      Icons.send_rounded,
                      color: AppHrPalette.accent,
                    ),
                  ),
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _TopicPill(
            label: l10n.askHrPolicyChip,
            background: AppHrPalette.accentSoft,
            foreground: AppHrPalette.accent,
            onTap: () => context.go(AppRoutes.askHrAnswer),
          ),
          _TopicPill(
            label: l10n.askHrFormChip,
            background: AppHrPalette.infoSoft,
            foreground: AppHrPalette.infoInk,
            onTap: () => context.push(AppRoutes.documents),
          ),
          _TopicPill(
            label: l10n.askHrMyRequestsChip,
            background: AppHrPalette.violetSoft,
            foreground: AppHrPalette.violetInk,
            onTap: () => context.go(AppRoutes.myWork),
          ),
        ],
      ),
      // Starters and prompt templates configured on the server, if any.
      if (ref.watch(promptSuggestionsProvider(AgentItem.hrAssistantId)).value
          case final suggestions? when suggestions.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final s in suggestions)
              ActionChip(
                label: Text(
                  s.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: () => _ask(s.text),
              ),
          ],
        ),
      ],
    ];
  }

  /// Sample question/answer, privacy notice and the policy-sources CTA.
  List<Widget> _buildSampleExchange() {
    final l10n = context.l10n;
    return [
      HrChatBubble(text: l10n.askHrSampleQuestion, fromUser: true),
      const SizedBox(height: AppSpacing.lg),
      HrChatBubble(text: l10n.askHrSampleAnswer, fromUser: false),
      const SizedBox(height: AppSpacing.lg),
      HrNoticeBox(text: l10n.askHrPrivacyNotice),
      const SizedBox(height: AppSpacing.md),
      AppButton(
        label: l10n.askHrViewPolicySources,
        onPressed: () => context.go(AppRoutes.askHrAnswer),
        expand: true,
      ),
    ];
  }
}

class _TopicPill extends StatelessWidget {
  const _TopicPill({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Material(
        color: background,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 36),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Center(
                widthFactor: 1,
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
