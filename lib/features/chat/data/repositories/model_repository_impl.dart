import '../../domain/extensions/ai_extensions.dart';
import '../../domain/repositories/model_repository.dart';
import '../sources/open_webui_client.dart';

class ModelRepositoryImpl implements ModelRepository, AgentRepository {
  ModelRepositoryImpl(this._webUiClient);

  final OpenWebUiClient _webUiClient;

  @override
  Future<List<ModelInfo>> getModels() async {
    return _webUiClient.fetchModels();
  }

  @override
  ModelInfo getSelectedModel() {
    return _webUiClient.model;
  }

  @override
  void setSelectedModel(ModelInfo model) {
    _webUiClient.setModel(model);
  }

  @override
  Future<List<ModelInfo>> getAgents() async {
    // Current Open WebUI endpoints expose models via /api/models.
    // Dedicated GOAI Agent metadata endpoint is NEEDS_BACKEND_CONFIRMATION.
    return getModels();
  }
}
