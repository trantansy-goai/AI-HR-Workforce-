import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../data/default_notification_services.dart';
import '../domain/app_notification.dart';
import '../domain/notification_services.dart';

final inAppNotificationCenterProvider = Provider<InAppNotificationCenter>((
  ref,
) {
  final center = StreamInAppNotificationCenter();
  ref.onDispose(center.dispose);
  return center;
});

/// Override with a real implementation (e.g. flutter_local_notifications).
final localNotificationServiceProvider = Provider<LocalNotificationService>(
  (ref) => NoopLocalNotificationService(ref.watch(appLoggerProvider)),
);

/// Override with a real implementation (e.g. Firebase Messaging).
final pushNotificationServiceProvider = Provider<PushNotificationService>(
  (ref) => NoopPushNotificationService(),
);

/// Notification list provider with development fixtures.
/// Remote push/pull notification integration is BLOCKED awaiting backend contracts.
final notificationListProvider = Provider<List<AppNotification>>((ref) {
  return [
    AppNotification(
      id: 'notif-1',
      channel: NotificationChannel.inApp,
      title: 'Pending Approval Request',
      body: 'Equipment request #AP-101 requires your review.',
      deepLink: '/home/approvals',
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    AppNotification(
      id: 'notif-2',
      channel: NotificationChannel.inApp,
      title: 'Security Training Due',
      body: 'Please complete the Annual Information Security module.',
      deepLink: '/home/learning',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    AppNotification(
      id: 'notif-3',
      channel: NotificationChannel.inApp,
      title: 'Company Milestone Reached',
      body: 'GOAI Mobile Phase 1 Milestone Reached - read announcement.',
      deepLink: '/home/news/news-1',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
});
