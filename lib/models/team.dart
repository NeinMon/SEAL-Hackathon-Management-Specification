part of '../main.dart';

class Team {
  const Team({
    required this.id,
    required this.name,
    required this.leaderId,
    required this.eventId,
    required this.members,
  });

  final String id;
  final String name;
  final String leaderId;
  final String eventId;
  final List<AppUser> members;

  factory Team.fromJson(Map<String, dynamic> json) {
    final rawMembers = json['team_members'];
    final members = rawMembers is List
        ? rawMembers
              .map((member) => member['users'])
              .whereType<Map<String, dynamic>>()
              .map(AppUser.fromJson)
              .toList()
        : <AppUser>[];
    return Team(
      id: json['id'] as String,
      name: (json['name'] ?? '') as String,
      leaderId: (json['leader_id'] ?? '') as String,
      eventId: (json['event_id'] ?? '') as String,
      members: members,
    );
  }
}
