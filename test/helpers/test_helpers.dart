import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/core/config/app_config.dart';
import 'package:goai_mobile/core/di/core_providers.dart';
import 'package:goai_mobile/core/localization/l10n.dart';
import 'package:goai_mobile/core/logging/app_logger.dart';
import 'package:goai_mobile/core/storage/key_value_store.dart';
import 'package:goai_mobile/core/storage/secure_store.dart';
import 'package:goai_mobile/core/theme/app_theme.dart';
import 'package:goai_mobile/features/auth/application/auth_providers.dart';
import 'package:goai_mobile/features/auth/data/fake_auth_remote_data_source.dart';

const testConfig = AppConfig(
  environment: AppEnvironment.development,
  appName: 'Test App',
  apiBaseUrl: 'https://api.test',
  useFakeBackend: true,
  useFakeNativeAdapters: true,
);

/// Overrides that make the whole app run in-memory with no delays.
List<Override> baseTestOverrides({
  KeyValueStore? keyValueStore,
  SecureStore? secureStore,
  AppConfig config = testConfig,
}) => [
  appConfigProvider.overrideWithValue(config),
  appLoggerProvider.overrideWithValue(const SilentLogger()),
  keyValueStoreProvider.overrideWithValue(
    keyValueStore ?? InMemoryKeyValueStore(),
  ),
  secureStoreProvider.overrideWithValue(secureStore ?? InMemorySecureStore()),
  authRemoteDataSourceProvider.overrideWithValue(
    FakeAuthRemoteDataSource(latency: Duration.zero),
  ),
];

/// Disables Riverpod's automatic retry so failing providers settle in tests.
Duration? noRetry(int retryCount, Object error) => null;

ProviderContainer createTestContainer({
  KeyValueStore? keyValueStore,
  SecureStore? secureStore,
  List<Override> overrides = const [],
}) {
  final container = ProviderContainer(
    overrides: [
      ...baseTestOverrides(
        keyValueStore: keyValueStore,
        secureStore: secureStore,
      ),
      ...overrides,
    ],
    retry: noRetry,
  );
  addTearDown(container.dispose);
  return container;
}

/// Wraps [child] with theme + localization for widget tests.
Widget testApp(Widget child, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    theme: const AppTheme().light,
    locale: locale,
    supportedLocales: AppLocales.supported,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Scaffold(body: child),
  );
}
