import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/storage/key_value_store.dart';
import '../domain/app_settings.dart';

/// Persists [AppSettings] in the key-value store.
class SettingsRepository {
  SettingsRepository(this._store);

  static const localeKey = 'settings.locale';

  final KeyValueStore _store;

  /// Synchronous so the first frame already uses the saved language.
  AppSettings load() {
    return AppSettings(
      locale: AppLocales.fromCode(_store.getString(localeKey)),
    );
  }

  Future<void> saveLocale(Locale? locale) => locale == null
      ? _store.remove(localeKey)
      : _store.setString(localeKey, locale.toLanguageTag());
}
