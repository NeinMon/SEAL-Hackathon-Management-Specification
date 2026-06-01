part of '../../main.dart';

class OrganizerDashboardScreen extends StatefulWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  State<OrganizerDashboardScreen> createState() =>
      _OrganizerDashboardScreenState();
}

class _OrganizerDashboardScreenState extends State<OrganizerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  Future<void> _reload() async {
    await Future.wait([
      context.read<EventProvider>().loadEvents(),
      context.read<TeamProvider>().loadTeams(),
      context.read<SubmissionProvider>().loadSubmissions(),
      context.read<ScoreProvider>().loadScores(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return RoleGate(
      allowedRoles: const {AppRoles.organizer},
      message: 'Only organizers can access the operations dashboard.',
      child: _OrganizerDashboardContent(onRefresh: _reload),
    );
  }
}

class _OrganizerDashboardContent extends StatelessWidget {
  const _OrganizerDashboardContent({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final events = context.watch<EventProvider>();
    final teams = context.watch<TeamProvider>();
    final submissions = context.watch<SubmissionProvider>();
    final scores = context.watch<ScoreProvider>();
    final unscored = submissions.submissions
        .where((submission) => scores.scoreCountFor(submission.id) == 0)
        .length;
    final activeEvents = events.events.where((event) {
      final now = DateTime.now();
      return event.startDate.isBefore(now) && event.endDate.isAfter(now);
    }).length;
    final loading =
        events.isLoading ||
        teams.isLoading ||
        submissions.isLoading ||
        scores.isLoading;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SealSectionHeader(
          title: 'Organizer',
          subtitle: 'Monitor event health, team progress, and judging status.',
          icon: Icons.dashboard_customize_outlined,
          trailing: IconButton.filledTonal(
            tooltip: 'Refresh dashboard',
            onPressed: loading ? null : onRefresh,
            icon: const Icon(Icons.refresh),
          ),
        ),
        if (events.error != null)
          StatusBanner(message: events.error!, isError: true),
        if (events.message != null) StatusBanner(message: events.message!),
        if (teams.error != null)
          StatusBanner(message: teams.error!, isError: true),
        if (submissions.error != null)
          StatusBanner(message: submissions.error!, isError: true),
        if (scores.error != null)
          StatusBanner(message: scores.error!, isError: true),
        if (loading) const LoadingCardList(itemCount: 3),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: 'Events',
                value: '${events.events.length}',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                label: 'Active',
                value: '$activeEvents',
                accent: SealPalette.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MetricCard(label: 'Teams', value: '${teams.teams.length}'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                label: 'Unscored',
                value: '$unscored',
                accent: unscored == 0
                    ? SealPalette.secondary
                    : SealPalette.tertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _DashboardBars(
          teams: teams.teams.length,
          submissions: submissions.submissions.length,
          scored: submissions.submissions.length - unscored,
          unscored: unscored,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Operations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.icon(
                      onPressed: () => _showEventDialog(context),
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('Create event'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _showAnnouncementDialog(context),
                      icon: const Icon(Icons.notifications_outlined),
                      label: const Text('Send announcement'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  title: const Text(
                    'More actions',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  children: [
                    _OrganizerAction(
                      icon: Icons.download_outlined,
                      title: 'Export leaderboard CSV',
                      value: 'Copy ranking data to clipboard',
                      onTap: () => _copyLeaderboardCsv(
                        context,
                        submissions.submissions,
                        scores,
                        teams.teams,
                      ),
                    ),
                    _OrganizerAction(
                      icon: Icons.rate_review_outlined,
                      title: 'Judging queue',
                      value: '$unscored submissions waiting for scores',
                      onTap: () => context.go(AppRoutes.judge),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Events',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        if (events.events.isEmpty)
          EmptyState(
            message: 'No events available',
            icon: Icons.event_busy_outlined,
            actionLabel: 'Create event',
            onAction: () => _showEventDialog(context),
          )
        else
          for (final event in events.events.take(4))
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.event_available_outlined),
                title: Text(event.title),
                subtitle: Text('${event.location}\n${_dateRange(event)}'),
                isThreeLine: true,
                trailing: IconButton(
                  tooltip: 'Edit event',
                  onPressed: () => _showEventDialog(context, existing: event),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ),
            ),
        const SizedBox(height: 16),
        const Text(
          'Recent submissions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        if (submissions.submissions.isEmpty)
          EmptyState(
            message: 'No submissions yet',
            icon: Icons.assignment_outlined,
            actionLabel: 'Open teams',
            onAction: () => context.go(AppRoutes.teams),
          )
        else
          for (final submission in submissions.submissions.take(5))
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.assignment_turned_in_outlined),
                title: Text(submission.projectName),
                subtitle: Text(
                  '${submission.status} - ${scores.scoreCountFor(submission.id)} score${scores.scoreCountFor(submission.id) == 1 ? '' : 's'}',
                ),
                trailing: Text(
                  scores.averageFor(submission.id).toStringAsFixed(1),
                  style: const TextStyle(
                    color: SealPalette.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
      ],
    );
  }

  static String _dateRange(HackathonEvent event) {
    final formatter = DateFormat('dd/MM/yyyy');
    return '${formatter.format(event.startDate)} - ${formatter.format(event.endDate)}';
  }

  static String _teamName(String teamId, List<Team> teams) {
    for (final team in teams) {
      if (team.id == teamId) return team.name;
    }
    return 'Unknown team';
  }

  Future<void> _copyLeaderboardCsv(
    BuildContext context,
    List<ProjectSubmission> submissions,
    ScoreProvider scores,
    List<Team> teams,
  ) async {
    final ranked = [...submissions]
      ..sort(
        (a, b) => scores.averageFor(b.id).compareTo(scores.averageFor(a.id)),
      );
    final rows = [
      'rank,project,team,status,score_count,average',
      for (var index = 0; index < ranked.length; index++)
        '${index + 1},"${ranked[index].projectName.replaceAll('"', '""')}","${_teamName(ranked[index].teamId, teams).replaceAll('"', '""')}",${ranked[index].status},${scores.scoreCountFor(ranked[index].id)},${scores.averageFor(ranked[index].id).toStringAsFixed(2)}',
    ];
    await Clipboard.setData(ClipboardData(text: rows.join('\n')));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Leaderboard CSV copied.')));
  }

  Future<void> _showAnnouncementDialog(BuildContext context) async {
    final title = TextEditingController();
    final content = TextEditingController();
    var role = 'all';
    final sent = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Send announcement'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: role,
                  decoration: const InputDecoration(
                    labelText: 'Audience',
                    prefixIcon: Icon(Icons.people_outline),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Everyone')),
                    DropdownMenuItem(
                      value: AppRoles.participant,
                      child: Text('Participants'),
                    ),
                    DropdownMenuItem(
                      value: AppRoles.mentor,
                      child: Text('Mentors'),
                    ),
                    DropdownMenuItem(
                      value: AppRoles.judge,
                      child: Text('Judges'),
                    ),
                  ],
                  onChanged: (value) =>
                      setDialogState(() => role = value ?? 'all'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.campaign_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: content,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(labelText: 'Message'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              icon: const Icon(Icons.send_outlined),
              label: const Text('Send'),
            ),
          ],
        ),
      ),
    );
    if (sent != true || !context.mounted) return;
    final cleanTitle = title.text.trim();
    final cleanContent = content.text.trim();
    if (cleanTitle.isEmpty || cleanContent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Announcement title and message required.'),
        ),
      );
      return;
    }
    final notifications = context.read<NotificationProvider>();
    final users = await const UserDirectoryService().fetchUsers();
    final recipients = users
        .where((user) => role == 'all' || user.role == role)
        .toList();
    for (final user in recipients) {
      await notifications.push(
        cleanTitle,
        cleanContent,
        'announcement',
        userId: user.id,
      );
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Announcement sent to ${recipients.length} users.'),
      ),
    );
  }

  Future<void> _showEventDialog(
    BuildContext context, {
    HackathonEvent? existing,
  }) async {
    final now = DateTime.now();
    final title = TextEditingController(text: existing?.title ?? '');
    final description = TextEditingController(
      text: existing?.description ?? '',
    );
    final location = TextEditingController(text: existing?.location ?? '');
    final banner = TextEditingController(
      text:
          existing?.bannerUrl ??
          'https://images.unsplash.com/photo-1517048676732-d65bc937f952',
    );
    final rules = TextEditingController(text: existing?.rules ?? '');
    final prize = TextEditingController(text: existing?.prize ?? '');
    final maxTeamSize = TextEditingController(
      text: '${existing?.maxTeamSize ?? 4}',
    );
    final start = TextEditingController(
      text: _inputDate(existing?.startDate ?? now.add(const Duration(days: 1))),
    );
    final end = TextEditingController(
      text: _inputDate(existing?.endDate ?? now.add(const Duration(days: 2))),
    );
    final deadline = TextEditingController(
      text: _inputDate(existing?.registrationDeadline ?? now),
    );
    final latitude = TextEditingController(
      text: '${existing?.latitude ?? 10.7769}',
    );
    final longitude = TextEditingController(
      text: '${existing?.longitude ?? 106.7009}',
    );

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(existing == null ? 'Create event' : 'Edit event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogField(controller: title, label: 'Title'),
              _DialogField(
                controller: description,
                label: 'Description',
                lines: 3,
              ),
              _DialogField(controller: location, label: 'Location'),
              _DialogField(controller: banner, label: 'Banner URL'),
              _DialogField(controller: start, label: 'Start date'),
              _DialogField(controller: end, label: 'End date'),
              _DialogField(
                controller: deadline,
                label: 'Registration deadline',
              ),
              _DialogField(
                controller: maxTeamSize,
                label: 'Max team size',
                keyboardType: TextInputType.number,
              ),
              _DialogField(controller: rules, label: 'Rules', lines: 2),
              _DialogField(controller: prize, label: 'Prize'),
              Row(
                children: [
                  Expanded(
                    child: _DialogField(
                      controller: latitude,
                      label: 'Latitude',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _DialogField(
                      controller: longitude,
                      label: 'Longitude',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save'),
          ),
        ],
      ),
    );
    if (shouldSave != true || !context.mounted) return;
    if (title.text.trim().isEmpty || location.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event title and location required.')),
      );
      return;
    }
    await context.read<EventProvider>().saveEvent(
      HackathonEvent(
        id: existing?.id ?? 'event-${DateTime.now().millisecondsSinceEpoch}',
        title: title.text.trim(),
        description: description.text.trim(),
        startDate: _parseDate(start.text, now.add(const Duration(days: 1))),
        endDate: _parseDate(end.text, now.add(const Duration(days: 2))),
        location: location.text.trim(),
        bannerUrl: banner.text.trim(),
        registrationDeadline: _parseDate(deadline.text, now),
        maxTeamSize: int.tryParse(maxTeamSize.text.trim()) ?? 4,
        rules: rules.text.trim(),
        prize: prize.text.trim(),
        latitude: double.tryParse(latitude.text.trim()) ?? 10.7769,
        longitude: double.tryParse(longitude.text.trim()) ?? 106.7009,
      ),
      existingEventId: existing?.id,
    );
  }

  static String _inputDate(DateTime value) =>
      DateFormat('yyyy-MM-dd HH:mm').format(value);

  static DateTime _parseDate(String value, DateTime fallback) {
    return DateFormat('yyyy-MM-dd HH:mm').tryParseStrict(value.trim()) ??
        DateTime.tryParse(value.trim()) ??
        fallback;
  }
}

class _DashboardBars extends StatelessWidget {
  const _DashboardBars({
    required this.teams,
    required this.submissions,
    required this.scored,
    required this.unscored,
  });

  final int teams;
  final int submissions;
  final int scored;
  final int unscored;

  @override
  Widget build(BuildContext context) {
    final maxValue = [
      teams,
      submissions,
      scored,
      unscored,
      1,
    ].reduce((value, element) => value > element ? value : element);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            _BarRow(label: 'Teams', value: teams, maxValue: maxValue),
            _BarRow(
              label: 'Submissions',
              value: submissions,
              maxValue: maxValue,
            ),
            _BarRow(
              label: 'Scored',
              value: scored,
              maxValue: maxValue,
              color: SealPalette.secondary,
            ),
            _BarRow(
              label: 'Unscored',
              value: unscored,
              maxValue: maxValue,
              color: SealPalette.tertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _BarRow extends StatelessWidget {
  const _BarRow({
    required this.label,
    required this.value,
    required this.maxValue,
    this.color = SealPalette.primary,
  });

  final String label;
  final int value;
  final int maxValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: value / maxValue,
                minHeight: 12,
                backgroundColor: SealPalette.surfaceContainerLow,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 32,
            child: Text(
              '$value',
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogField extends StatelessWidget {
  const _DialogField({
    required this.controller,
    required this.label,
    this.lines = 1,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final int lines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        minLines: lines,
        maxLines: lines == 1 ? 1 : lines + 1,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

class _OrganizerAction extends StatelessWidget {
  const _OrganizerAction({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: SealPalette.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(value),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
