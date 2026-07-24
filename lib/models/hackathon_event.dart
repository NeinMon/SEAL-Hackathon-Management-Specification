import '../core/l10n/l10n_service.dart';

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
    this.submissionDeadline,
    this.supportHotline,
    this.openingHours,
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
  final DateTime? submissionDeadline;
  final String? supportHotline;
  final String? openingHours;

  String get displayHotline {
    final value = supportHotline?.trim();
    if (value != null && value.isNotEmpty) return value;
    return L10nService.strings.defaultHotline;
  }

  String get displayOpeningHours {
    final value = openingHours?.trim();
    if (value != null && value.isNotEmpty) return value;
    return L10nService.strings.defaultOpeningHours;
  }

  DateTime get effectiveSubmissionDeadline {
    final explicit = submissionDeadline;
    if (explicit != null) return explicit;
    final duration = endDate.difference(startDate);
    if (duration.inMilliseconds <= 0) return endDate;
    return startDate.add(
      Duration(milliseconds: (duration.inMilliseconds * 0.7).round()),
    );
  }

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
      submissionDeadline: DateTime.tryParse(
        (json['submission_deadline'] ?? '').toString(),
      ),
      supportHotline: (json['support_hotline'] as String?)?.trim(),
      openingHours: (json['opening_hours'] as String?)?.trim(),
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
      if (submissionDeadline != null)
        'submission_deadline': submissionDeadline!.toIso8601String(),
      if (supportHotline != null && supportHotline!.trim().isNotEmpty)
        'support_hotline': supportHotline!.trim(),
      if (openingHours != null && openingHours!.trim().isNotEmpty)
        'opening_hours': openingHours!.trim(),
    };
  }

  bool registrationOpen([DateTime? at]) {
    final now = at ?? DateTime.now();
    return !endDate.isBefore(now) && !registrationDeadline.isBefore(now);
  }

  String? registrationBlockReason([DateTime? at]) {
    final now = at ?? DateTime.now();
    if (endDate.isBefore(now)) {
      return L10nService.strings.errorEventEnded;
    }
    if (registrationDeadline.isBefore(now)) {
      return L10nService.strings.errorRegistrationDeadlinePassed;
    }
    return null;
  }

  bool submissionOpen([DateTime? at]) {
    final now = at ?? DateTime.now();
    return !startDate.isAfter(now) &&
        effectiveSubmissionDeadline.isAfter(now);
  }

  String? submissionBlockReason([DateTime? at]) {
    final now = at ?? DateTime.now();
    if (startDate.isAfter(now)) {
      return L10nService.strings.errorSubmissionNotStarted;
    }
    if (!effectiveSubmissionDeadline.isAfter(now)) {
      return L10nService.strings.errorSubmissionClosed;
    }
    return null;
  }

  bool judgingOpen([DateTime? at]) {
    final now = at ?? DateTime.now();
    return !startDate.isAfter(now) && !endDate.isBefore(now);
  }

  String? judgingBlockReason([DateTime? at]) {
    final now = at ?? DateTime.now();
    if (startDate.isAfter(now)) {
      return L10nService.strings.errorJudgingNotStarted;
    }
    if (endDate.isBefore(now)) {
      return L10nService.strings.errorJudgingClosed;
    }
    return null;
  }
}
