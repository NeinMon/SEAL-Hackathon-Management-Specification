part of '../main.dart';

class HackathonEvent {
  const HackathonEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.bannerUrl,
    required this.registrationDeadline,
    required this.maxTeamSize,
    required this.rules,
    required this.prize,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String bannerUrl;
  final DateTime registrationDeadline;
  final int maxTeamSize;
  final String rules;
  final String prize;
  final double latitude;
  final double longitude;

  factory HackathonEvent.fromJson(Map<String, dynamic> json) {
    return HackathonEvent(
      id: json['id'] as String,
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      startDate:
          DateTime.tryParse((json['start_date'] ?? '').toString()) ??
          DateTime.now(),
      endDate:
          DateTime.tryParse((json['end_date'] ?? '').toString()) ??
          DateTime.now(),
      location: (json['location'] ?? '') as String,
      bannerUrl: (json['banner_url'] ?? '') as String,
      registrationDeadline:
          DateTime.tryParse((json['registration_deadline'] ?? '').toString()) ??
          DateTime.now(),
      maxTeamSize: (json['max_team_size'] ?? 0) as int,
      rules: (json['rules'] ?? '') as String,
      prize: (json['prize'] ?? '') as String,
      latitude: ((json['latitude'] ?? 0) as num).toDouble(),
      longitude: ((json['longitude'] ?? 0) as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'location': location,
      'banner_url': bannerUrl,
      'registration_deadline': registrationDeadline.toIso8601String(),
      'max_team_size': maxTeamSize,
      'rules': rules,
      'prize': prize,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
