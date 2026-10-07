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
      title: 'Checklist sắp đến hạn',
      body: 'Xác minh giấy tờ trước 10/10 · 09:00',
      deepLink: '/home/my-work',
      createdAt: DateTime(2026, 10, 7, 9),
    ),
    AppNotification(
      id: 'notif-2',
      channel: NotificationChannel.inApp,
      title: 'Khóa học được giao',
      body: 'An toàn lao động cơ bản · 06/10',
      deepLink: '/home/learning',
      createdAt: DateTime(2026, 10, 6, 8),
    ),
    AppNotification(
      id: 'notif-3',
      channel: NotificationChannel.inApp,
      title: 'Case đã được tiếp nhận',
      body: '#HR-1042 · 07/10',
      deepLink: '/home/my-work',
      createdAt: DateTime(2026, 10, 7, 10),
    ),
  ];
});
