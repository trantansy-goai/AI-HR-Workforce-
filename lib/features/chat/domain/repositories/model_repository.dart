import '../extensions/ai_extensions.dart';

abstract interface class ModelRepository {
  Future<List<ModelInfo>> getModels();
  ModelInfo getSelectedModel();
  void setSelectedModel(ModelInfo model);
}

/// Boundary contract for GOAI Agents.
abstract interface class AgentRepository {
  Future<List<ModelInfo>> getAgents();
}
