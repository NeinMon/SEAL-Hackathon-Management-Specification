import '../../shared.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key, required this.eventId});
  final String eventId;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamProvider>().loadTeams();
      context.read<SubmissionProvider>().loadSubmissions();
      context.read<ScoreProvider>().loadScores();
      context.read<EventProvider>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final event = eventProvider.byIdOrNull(widget.eventId);
    if (event == null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SealSectionHeader(
            title: 'Chi tiết Event',
            subtitle: 'Đang tải thông tin hackathon từ hệ thống.',
            icon: Icons.event_outlined,
          ),
          if (eventProvider.error != null)
            StatusBanner(message: eventProvider.error!, isError: true),
          if (eventProvider.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            )
          else
            const EmptyState(message: 'Không tìm thấy event.'),
        ],
      );
    }
    final teams = context.watch<TeamProvider>().teams;
    final submissions = context.watch<SubmissionProvider>().submissions;
    final scores = context.watch<ScoreProvider>();
    final role = context.watch<AuthProvider>().user?.role;
    final eventTeams = teams.where((team) => team.eventId == event.id).toList();
    final eventTeamIds = eventTeams.map((team) => team.id).toSet();
    final eventSubmissions =
        submissions
            .where((submission) => eventTeamIds.contains(submission.teamId))
            .toList()
          ..sort(
            (a, b) =>
                scores.averageFor(b.id).compareTo(scores.averageFor(a.id)),
          );
    final overview = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 8,
                child: EventNetworkImage(
                  url: event.bannerUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusPill(
                      label:
                          'Đóng đăng ký ${DateFormat('dd/MM').format(event.registrationDeadline)}',
                      color: SealPalette.tertiary,
                      icon: Icons.schedule_outlined,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      style: const TextStyle(
                        color: SealPalette.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _EventTimeline(event: event),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            InfoChip(
              icon: Icons.calendar_month_outlined,
              text:
                  '${DateFormat('dd/MM/yyyy').format(event.startDate)} - ${DateFormat('dd/MM/yyyy').format(event.endDate)}',
            ),
            InfoChip(icon: Icons.place_outlined, text: event.location),
            InfoChip(
              icon: Icons.groups_outlined,
              text: 'Tối đa ${event.maxTeamSize} thành viên',
            ),
          ],
        ),
        const SizedBox(height: 16),
        DetailTile(title: 'Luật thi', value: event.rules),
        DetailTile(title: 'Giải thưởng', value: event.prize),
        const SizedBox(height: 12),
        _EventRoleActions(role: role),
      ],
    );
    final leaderboard = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Bảng xếp hạng',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        if (eventSubmissions.isEmpty)
          const EmptyState(message: 'Chưa có bài nào được chấm.')
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: eventSubmissions.length,
            itemBuilder: (context, index) {
              final submission = eventSubmissions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: SealPalette.primary.withValues(
                      alpha: 0.14,
                    ),
                    child: Text(
                      '#${index + 1}',
                      style: const TextStyle(
                        color: SealPalette.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  title: Text(submission.projectName),
                  subtitle: Text(
                    '${_teamName(submission.teamId, eventTeams)}\n${scores.scoreCountFor(submission.id)} lượt chấm',
                  ),
                  isThreeLine: true,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        scores.averageFor(submission.id).toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        'TB',
                        style: TextStyle(
                          color: SealPalette.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SealSectionHeader(
          title: 'Chi tiết Event',
          subtitle: 'Timeline, luật thi, địa điểm và bảng xếp hạng.',
          icon: Icons.event_outlined,
          trailing: IconButton.filledTonal(
            tooltip: 'Về Events',
            onPressed: () => context.go(AppRoutes.events),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        AdaptiveTwoPane(leading: overview, trailing: leaderboard),
      ],
    );
  }

  String _teamName(String teamId, List<Team> teams) {
    for (final team in teams) {
      if (team.id == teamId) return team.name;
    }
    return 'Chưa tải team';
  }
}

class _EventRoleActions extends StatelessWidget {
  const _EventRoleActions({required this.role});

  final String? role;

  @override
  Widget build(BuildContext context) {
    final primary = switch (role) {
      AppRoles.judge => (
        path: AppRoutes.judge,
        icon: Icons.rate_review_outlined,
        label: 'Mở hàng chờ chấm',
      ),
      AppRoles.organizer => (
        path: AppRoutes.organizer,
        icon: Icons.dashboard_customize_outlined,
        label: 'Mở Dashboard ban tổ chức',
      ),
      AppRoles.mentor => (
        path: AppRoutes.chat,
        icon: Icons.chat_outlined,
        label: 'Mở Mentor Chat',
      ),
      _ => (
        path: AppRoutes.teams,
        icon: Icons.group_add_outlined,
        label: 'Tạo hoặc quản lý team',
      ),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: () => context.go(primary.path),
          icon: Icon(primary.icon),
          label: Text(primary.label),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => context.go(AppRoutes.map),
          icon: const Icon(Icons.map_outlined),
          label: const Text('Xem địa điểm'),
        ),
      ],
    );
  }
}

class _EventTimeline extends StatelessWidget {
  const _EventTimeline({required this.event});

  final HackathonEvent event;

  @override
  Widget build(BuildContext context) {
    final items = [
      _TimelineItem(
        icon: Icons.how_to_reg_outlined,
        label: 'Đăng ký',
        date: event.registrationDeadline,
      ),
      _TimelineItem(
        icon: Icons.flag_outlined,
        label: 'Kickoff',
        date: event.startDate,
      ),
      _TimelineItem(
        icon: Icons.emoji_events_outlined,
        label: 'Chung kết',
        date: event.endDate,
      ),
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SealPalette.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SealPalette.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Timeline',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Icon(item.icon, color: SealPalette.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.label,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(item.date),
                    style: const TextStyle(
                      color: SealPalette.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TimelineItem {
  const _TimelineItem({
    required this.icon,
    required this.label,
    required this.date,
  });

  final IconData icon;
  final String label;
  final DateTime date;
}
