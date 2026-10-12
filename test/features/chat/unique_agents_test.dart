import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/features/chat/application/chat_providers.dart';
import 'package:goai_mobile/features/chat/domain/extensions/ai_extensions.dart';

void main() {
  test(
    'agents with the same name are listed once, keeping the described one',
    () {
      const pipe = ModelInfo(
        id: 'go_ai_orchestrator.chief',
        displayName: 'GO AI HR Orchestrator (Chief)',
        description: 'GO AI HR Orchestrator (Chief)',
      );
      const payroll = ModelInfo(id: 'payroll', displayName: 'GO AI Payroll');
      const chief = ModelInfo(
        id: 'hr_chief',
        displayName: 'GO AI HR Orchestrator (Chief)',
        description: 'Single entry point; routes work across HR agents.',
      );

      expect(uniqueByName([pipe, payroll, chief]), [payroll, chief]);
      expect(uniqueByName([chief, payroll, pipe]), [chief, payroll]);
    },
  );
}
