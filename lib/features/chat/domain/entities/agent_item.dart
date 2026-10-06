import 'package:equatable/equatable.dart';

/// Descriptor for an enterprise AI Assistant Agent.
class AgentItem extends Equatable {
  const AgentItem({
    required this.id,
    required this.name,
    required this.description,
    required this.role,
    this.avatarUrl,
    this.modelId,
  });

  final String id;
  final String name;
  final String description;
  final String role;
  final String? avatarUrl;
  final String? modelId;

  @override
  List<Object?> get props => [id, name, description, role, avatarUrl, modelId];
}
