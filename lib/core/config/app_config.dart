/// Runtime environments supported by the app.
enum AppEnvironment {
  development,
  staging,
  production;

  static AppEnvironment parse(String? value) {
    return AppEnvironment.values.firstWhere(
      (e) => e.name == value?.trim().toLowerCase(),
      orElse: () => AppEnvironment.development,
    );
  }
}

/// Immutable application configuration.
class AppConfig {
  const AppConfig({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    this.businessApiBaseUrl = 'https://api.example.com',
    this.openWebUiBaseUrl = 'https://openwebui.example.com',
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 30),
    this.enableNetworkLogs = false,
    this.logNetworkBodies = false,
    this.useFakeBackend = false,
    this.openWebUiApiKey = '',
  });

  /// Reads configuration from compile-time environment declarations.
  factory AppConfig.fromEnvironment() {
    const env = String.fromEnvironment('APP_ENV', defaultValue: 'development');
    final environment = AppEnvironment.parse(env);
    final isProd = environment == AppEnvironment.production;

    const defaultApiUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://api.example.com',
    );
    const businessApiUrl = String.fromEnvironment(
      'BUSINESS_API_BASE_URL',
      defaultValue: defaultApiUrl,
    );
    const openWebUiUrl = String.fromEnvironment(
      'OPEN_WEBUI_BASE_URL',
      defaultValue: 'https://openwebui.example.com',
    );
    const openWebUiKey = String.fromEnvironment(
      'OPEN_WEBUI_API_KEY',
      defaultValue: '',
    );

    return AppConfig(
      environment: environment,
      appName: const String.fromEnvironment(
        'APP_NAME',
        defaultValue: 'GOAI Mobile',
      ),
      apiBaseUrl: defaultApiUrl,
      businessApiBaseUrl: businessApiUrl,
      openWebUiBaseUrl: openWebUiUrl,
      openWebUiApiKey: openWebUiKey,
      connectTimeout: Duration(
        milliseconds: const int.fromEnvironment(
          'CONNECT_TIMEOUT_MS',
          defaultValue: 15000,
        ),
      ),
      receiveTimeout: Duration(
        milliseconds: const int.fromEnvironment(
          'RECEIVE_TIMEOUT_MS',
          defaultValue: 30000,
        ),
      ),
      enableNetworkLogs:
          !isProd &&
          const bool.fromEnvironment('ENABLE_NETWORK_LOGS', defaultValue: true),
      logNetworkBodies:
          !isProd &&
          const bool.fromEnvironment('LOG_NETWORK_BODIES', defaultValue: false),
      useFakeBackend: const bool.hasEnvironment('USE_FAKE_BACKEND')
          ? const bool.fromEnvironment('USE_FAKE_BACKEND')
          : (!isProd && environment != AppEnvironment.staging),
    );
  }

  final AppEnvironment environment;
  final String appName;
  final String apiBaseUrl;
  final String businessApiBaseUrl;
  final String openWebUiBaseUrl;
  final String openWebUiApiKey;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final bool enableNetworkLogs;
  final bool logNetworkBodies;

  /// When true, features use in-process fake data sources instead of HTTP.
  final bool useFakeBackend;

  bool get isProduction => environment == AppEnvironment.production;
  bool get isDevelopment => environment == AppEnvironment.development;
}
