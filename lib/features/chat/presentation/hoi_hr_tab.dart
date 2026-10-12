import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../my_work/application/my_work_providers.dart';
import '../../my_work/domain/my_work_item.dart';
import 'ask_hr_page.dart';
import 'chat_hub_page.dart';

/// Tab 2: HR staff get the specialist agents with their chat history;
/// employees get the Hỏi HR question page (M03).
class HoiHrTab extends ConsumerWidget {
  const HoiHrTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(workRoleProvider)) {
      WorkRole.hrAdmin => const ChatHubPage(asTab: true),
      WorkRole.employee => const AskHrPage(),
    };
  }
}
