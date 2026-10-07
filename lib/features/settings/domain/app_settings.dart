import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// User preferences that affect the whole app.
class AppSettings extends Equatable {
  const AppSettings({this.locale});

  /// Null means "follow the device language".
  final Locale? locale;

  AppSettings copyWith({Locale? Function()? locale}) =>
      AppSettings(locale: locale == null ? this.locale : locale());

  @override
  List<Object?> get props => [locale];
}
