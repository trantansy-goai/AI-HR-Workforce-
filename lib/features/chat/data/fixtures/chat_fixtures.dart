import '../../domain/entities/agent_item.dart';

/// Centralized development fixtures for AI Agents and Human chat boundaries.
abstract final class ChatFixtures {
  static const agents = [
    AgentItem(
      id: 'mock-assistant',
      name: 'Mock Assistant',
      description: 'General enterprise AI assistant powered by Open WebUI',
      role: 'Enterprise AI',
      modelId: 'mock-1',
    ),
    AgentItem(
      id: 'hr-assistant',
      name: 'HR Assistant',
      description:
          'Inquiries about company policies, benefits, leave, and onboarding',
      role: 'Human Resources',
      modelId: 'hr-model',
    ),
    AgentItem(
      id: 'legal-assistant',
      name: 'Legal Assistant',
      description:
          'Contract reviews, compliance guidelines, and corporate policies',
      role: 'Legal & Compliance',
      modelId: 'legal-model',
    ),
  ];
}
