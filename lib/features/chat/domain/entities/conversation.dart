import 'package:equatable/equatable.dart';

import 'message.dart';
import 'participant.dart';

/// Shape of a conversation; used for UI hints only (icons, reply behavior).
enum ConversationKind {
  /// One-to-one between humans.
  direct,

  /// Many humans.
  group,

  /// User with a support desk (agents and/or bots).
  support,

  /// User with an AI/bot assistant.
  assistant,
}

class Conversation extends Equatable {
  const Conversation({
    required this.id,
    required this.title,
    required this.kind,
    required this.participants,
    required this.updatedAt,
    this.lastMessage,
    this.unreadCount = 0,
    this.isPinned = false,
  });

  final String id;
  final String title;
  final ConversationKind kind;
  final List<Participant> participants;
  final DateTime updatedAt;
  final Message? lastMessage;
  final int unreadCount;

  /// Kept at the top of conversation lists.
  final bool isPinned;

  /// First participant that is not [selfId].
  Participant? counterpart(String selfId) {
    for (final p in participants) {
      if (p.id != selfId) return p;
    }
    return null;
  }

  Conversation copyWith({
    String? title,
    List<Participant>? participants,
    DateTime? updatedAt,
    Message? lastMessage,
    int? unreadCount,
    bool? isPinned,
  }) => Conversation(
    id: id,
    title: title ?? this.title,
    kind: kind,
    participants: participants ?? this.participants,
    updatedAt: updatedAt ?? this.updatedAt,
    lastMessage: lastMessage ?? this.lastMessage,
    unreadCount: unreadCount ?? this.unreadCount,
    isPinned: isPinned ?? this.isPinned,
  );

  @override
  List<Object?> get props => [
    id,
    title,
    kind,
    participants,
    updatedAt,
    lastMessage,
    unreadCount,
    isPinned,
  ];
}
