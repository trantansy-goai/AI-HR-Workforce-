import 'package:flutter/widgets.dart';

import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

/// Supported locales. Add a locale here AND an `app_<code>.arb` file
/// (see README "Adding a language").
///
/// Chinese has two entries that share the language code `zh`, so locales are
/// identified by their language tag (`zh`, `zh-Hant`), not the language code.
abstract final class AppLocales {
  static const english = Locale('en');
  static const vietnamese = Locale('vi');
  static const chineseSimplified = Locale('zh');
  static const chineseTraditional = Locale.fromSubtags(
    languageCode: 'zh',
    scriptCode: 'Hant',
  );
  static const japanese = Locale('ja');
  static const korean = Locale('ko');

  static const supported = AppLocalizations.supportedLocales;

  /// Order of the language picker.
  static const pickerOrder = [
    english,
    vietnamese,
    chineseSimplified,
    chineseTraditional,
    japanese,
    korean,
  ];

  /// Regions whose Chinese is written in Traditional characters.
  static const _traditionalChineseRegions = {'TW', 'HK', 'MO'};

  /// The supported locale stored as [code] (a language tag such as `vi` or
  /// `zh-Hant`), or null when unknown.
  static Locale? fromCode(String? code) {
    if (code == null) return null;
    for (final locale in supported) {
      if (locale.toLanguageTag() == code) return locale;
    }
    return null;
  }

  /// The supported locale for the device [locale]. Like Flutter's default,
  /// except that Chinese from Taiwan, Hong Kong or Macau without a script
  /// subtag (e.g. `zh_TW` on some Android devices) gets Traditional Chinese.
  static Locale resolve(Locale? locale, Iterable<Locale> supported) {
    if (locale == null) return supported.first;
    if (locale.languageCode == chineseTraditional.languageCode) {
      final traditional =
          locale.scriptCode == chineseTraditional.scriptCode ||
          (locale.scriptCode == null &&
              _traditionalChineseRegions.contains(locale.countryCode));
      final match = traditional ? chineseTraditional : chineseSimplified;
      if (supported.contains(match)) return match;
    }
    for (final candidate in supported) {
      if (candidate.languageCode == locale.languageCode &&
          candidate.scriptCode == null) {
        return candidate;
      }
    }
    return supported.first;
  }

  /// Language names in their own language (endonyms), shown untranslated.
  static String nativeName(Locale locale) => switch (locale.toLanguageTag()) {
    'en' => 'English',
    'vi' => 'Tiếng Việt',
    'zh' => '简体中文',
    'zh-Hant' => '繁體中文',
    'ja' => '日本語',
    'ko' => '한국어',
    final tag => tag,
  };
}

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
