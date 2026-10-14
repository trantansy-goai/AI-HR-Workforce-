import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/core/localization/l10n.dart';
import 'package:goai_mobile/core/storage/key_value_store.dart';
import 'package:goai_mobile/features/settings/application/settings_controller.dart';
import 'package:goai_mobile/features/settings/data/settings_repository.dart';

import '../../helpers/test_helpers.dart';

void main() {
  test('defaults to device locale', () {
    final container = createTestContainer();
    final settings = container.read(settingsControllerProvider);
    expect(settings.locale, isNull);
  });

  test('persists locale and restores it on restart', () async {
    final store = InMemoryKeyValueStore();
    final first = createTestContainer(keyValueStore: store);
    final controller = first.read(settingsControllerProvider.notifier);
    await controller.setLocale(const Locale('vi'));

    expect(store.getString(SettingsRepository.localeKey), 'vi');

    final second = createTestContainer(keyValueStore: store);
    final restored = second.read(settingsControllerProvider);
    expect(restored.locale, const Locale('vi'));
  });

  test('clearing locale follows the device again', () async {
    final store = InMemoryKeyValueStore({SettingsRepository.localeKey: 'vi'});
    final container = createTestContainer(keyValueStore: store);
    await container.read(settingsControllerProvider.notifier).setLocale(null);
    expect(container.read(settingsControllerProvider).locale, isNull);
    expect(store.getString(SettingsRepository.localeKey), isNull);
  });

  test('ignores unknown stored values', () {
    final store = InMemoryKeyValueStore({SettingsRepository.localeKey: 'xx'});
    final settings = SettingsRepository(store).load();
    expect(settings.locale, isNull);
  });

  test('keeps Simplified and Traditional Chinese apart', () async {
    final store = InMemoryKeyValueStore();
    final first = createTestContainer(keyValueStore: store);
    await first
        .read(settingsControllerProvider.notifier)
        .setLocale(AppLocales.chineseTraditional);

    expect(store.getString(SettingsRepository.localeKey), 'zh-Hant');
    final second = createTestContainer(keyValueStore: store);
    expect(
      second.read(settingsControllerProvider).locale,
      AppLocales.chineseTraditional,
    );
  });

  group('device locale resolution', () {
    Locale resolve(Locale device) =>
        AppLocales.resolve(device, AppLocales.supported);

    test('Chinese follows the script, then the region', () {
      expect(
        resolve(
          const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
        ),
        AppLocales.chineseTraditional,
      );
      expect(resolve(const Locale('zh', 'TW')), AppLocales.chineseTraditional);
      expect(resolve(const Locale('zh', 'HK')), AppLocales.chineseTraditional);
      expect(resolve(const Locale('zh', 'CN')), AppLocales.chineseSimplified);
      expect(
        resolve(
          const Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hans',
            countryCode: 'HK',
          ),
        ),
        AppLocales.chineseSimplified,
      );
    });

    test('other languages match the language code, else English', () {
      expect(resolve(const Locale('ja', 'JP')), AppLocales.japanese);
      expect(resolve(const Locale('ko', 'KR')), AppLocales.korean);
      expect(resolve(const Locale('fr', 'FR')), AppLocales.english);
    });
  });

  test('every supported language is in the picker', () {
    expect(AppLocales.pickerOrder.toSet(), AppLocales.supported.toSet());
  });
}
