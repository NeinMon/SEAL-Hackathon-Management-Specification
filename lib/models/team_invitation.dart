import 'app_user.dart';
import 'team.dart';

class TeamInvitation {
  const TeamInvitation({
    required this.id,
    required this.teamId,
    required this.inviterId,
    required this.inviteeId,
    required this.status,
    required this.createdAt,
    this.respondedAt,
    this.team,
    this.inviter,
  });

  final String id;
  final String teamId;
  final String inviterId;
  final String inviteeId;
  final String status;
  final DateTime createdAt;
  final DateTime? respondedAt;
  final Team? team;
  final AppUser? inviter;

  bool get isPending => status == 'pending';

  factory TeamInvitation.fromJson(Map<String, dynamic> json) {
    final teamJson = json['team'];
    final inviterJson = json['inviter'];
    return TeamInvitation(
      id: (json['id'] ?? '') as String,
      teamId: (json['team_id'] ?? '') as String,
      inviterId: (json['inviter_id'] ?? '') as String,
      inviteeId: (json['invitee_id'] ?? '') as String,
      status: (json['status'] ?? 'pending') as String,
      createdAt: DateTime.tryParse('${json['created_at']}') ?? DateTime.now(),
      respondedAt: json['responded_at'] == null
          ? null
          : DateTime.tryParse('${json['responded_at']}'),
      team: teamJson is Map<String, dynamic> ? Team.fromJson(teamJson) : null,
      inviter: inviterJson is Map<String, dynamic>
          ? AppUser.fromJson(inviterJson)
          : null,
    );
  }
}
