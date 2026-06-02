import '../../shared.dart';

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
      message: 'Chỉ ban tổ chức mới truy cập được Dashboard vận hành.',
      child: _OrganizerDashboardContent(onRefresh: _reload),
    );
  }
}

class _OrganizerDashboardContent extends StatefulWidget {
  const _OrganizerDashboardContent({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  State<_OrganizerDashboardContent> createState() =>
      _OrganizerDashboardContentState();
}

class _OrganizerDashboardContentState
    extends State<_OrganizerDashboardContent> {
  String section = 'overview';

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
          subtitle: 'Theo dõi event, tiến độ team và trạng thái chấm điểm.',
          icon: Icons.dashboard_customize_outlined,
          trailing: IconButton.filledTonal(
            tooltip: 'Tải lại Dashboard',
            onPressed: loading ? null : widget.onRefresh,
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
        _OrganizerSectionPicker(
          value: section,
          onChanged: (value) => setState(() => section = value),
        ),
        const SizedBox(height: 14),
        if (loading) const DashboardMetricSkeleton(),
        if (section == 'overview') ...[
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
                  label: 'Đang mở',
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
                child: MetricCard(
                  label: 'Team',
                  value: '${teams.teams.length}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MetricCard(
                  label: 'Chưa chấm',
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
          _SystemStatusCard(
            events: events,
            teams: teams,
            submissions: submissions,
            scores: scores,
          ),
        ],
        if (section == 'operations') ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vận hành',
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
                        label: const Text('Tạo event'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _showAnnouncementDialog(context),
                        icon: const Icon(Icons.notifications_outlined),
                        label: const Text('Gửi thông báo'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.zero,
                    title: const Text(
                      'Thao tác khác',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    children: [
                      _OrganizerAction(
                        icon: Icons.download_outlined,
                        title: 'Export leaderboard CSV',
                        value: 'Copy dữ liệu xếp hạng vào clipboard',
                        onTap: () => _copyLeaderboardCsv(
                          context,
                          submissions.submissions,
                          scores,
                          teams.teams,
                        ),
                      ),
                      _OrganizerAction(
                        icon: Icons.rate_review_outlined,
                        title: 'Hàng chờ chấm',
                        value: '$unscored bài đang chờ điểm',
                        onTap: () => context.go(AppRoutes.judge),
                      ),
                      _OrganizerAction(
                        icon: Icons.manage_accounts_outlined,
                        title: 'Role người dùng',
                        value: 'Xem role tài khoản dùng trong RLS',
                        onTap: () => _showUserRolesDialog(context),
                      ),
                      _OrganizerAction(
                        icon: Icons.restore_page_outlined,
                        title: 'Reset dữ liệu demo',
                        value: 'Gọi Edge Function có kiểm role organizer',
                        onTap: () => _resetDemoData(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        if (section == 'events') ...[
          const Text(
            'Events',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          if (events.events.isEmpty)
            EmptyState(
              message: 'Chưa có event.',
              icon: Icons.event_busy_outlined,
              actionLabel: 'Tạo event',
              onAction: () => _showEventDialog(context),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.events.take(4).length,
              itemBuilder: (context, index) {
                final event = events.events[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const Icon(Icons.event_available_outlined),
                    title: Text(event.title),
                    subtitle: Text('${event.location}\n${_dateRange(event)}'),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      tooltip: 'Thao tác event',
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showEventDialog(context, existing: event);
                        }
                        if (value == 'close') {
                          _closeRegistration(context, event);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit_outlined),
                            title: Text('Sửa event'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'close',
                          child: ListTile(
                            leading: Icon(Icons.lock_clock_outlined),
                            title: Text('Đóng đăng ký'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
        if (section == 'submissions') ...[
          const Text(
            'Bài nộp gần đây',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          if (submissions.submissions.isEmpty)
            EmptyState(
              message: 'Chưa có bài nộp.',
              icon: Icons.assignment_outlined,
              actionLabel: 'Mở Team',
              onAction: () => context.go(AppRoutes.teams),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: submissions.submissions.take(5).length,
              itemBuilder: (context, index) {
                final submission = submissions.submissions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const Icon(Icons.assignment_turned_in_outlined),
                    title: Text(submission.projectName),
                    subtitle: Text(
                      '${AppLabels.submissionStatus(submission.status)} - ${scores.scoreCountFor(submission.id)} lượt chấm',
                    ),
                    trailing: Text(
                      scores.averageFor(submission.id).toStringAsFixed(1),
                      style: const TextStyle(
                        color: SealPalette.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    onTap: () => _showSubmissionDetails(
                      context,
                      submission,
                      scores,
                      teams.teams,
                    ),
                  ),
                );
              },
            ),
        ],
        if (section == 'teams') ...[
          const Text(
            'Chi tiết team',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          if (teams.teams.isEmpty)
            const EmptyState(message: 'Chưa có team để xem.')
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: teams.teams.take(5).length,
              itemBuilder: (context, index) {
                final team = teams.teams[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const Icon(Icons.groups_outlined),
                    title: Text(team.name),
                    subtitle: Text('${team.members.length} thành viên'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showTeamDetails(context, team),
                  ),
                );
              },
            ),
        ],
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
    return 'Chưa rõ team';
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
    ).showSnackBar(const SnackBar(content: Text('Đã copy leaderboard CSV.')));
  }

  Future<void> _showAnnouncementDialog(BuildContext context) async {
    final title = TextEditingController();
    final content = TextEditingController();
    var role = 'all';
    final sent = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Gửi thông báo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: role,
                  decoration: const InputDecoration(
                    labelText: 'Người nhận',
                    prefixIcon: Icon(Icons.people_outline),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Tất cả')),
                    DropdownMenuItem(
                      value: AppRoles.participant,
                      child: Text('Thí sinh'),
                    ),
                    DropdownMenuItem(
                      value: AppRoles.mentor,
                      child: Text('Mentor'),
                    ),
                    DropdownMenuItem(
                      value: AppRoles.judge,
                      child: Text('Giám khảo'),
                    ),
                  ],
                  onChanged: (value) =>
                      setDialogState(() => role = value ?? 'all'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề',
                    prefixIcon: Icon(Icons.campaign_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: content,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(labelText: 'Nội dung'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Hủy'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              icon: const Icon(Icons.send_outlined),
              label: const Text('Gửi'),
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
          content: Text('Tiêu đề và nội dung thông báo là bắt buộc.'),
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
        content: Text('Đã gửi thông báo cho ${recipients.length} người dùng.'),
      ),
    );
  }

  Future<void> _closeRegistration(
    BuildContext context,
    HackathonEvent event,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Đóng đăng ký?'),
        content: Text(
          'Deadline đăng ký của ${event.title} sẽ được đặt thành thời điểm hiện tại.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Đóng đăng ký'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final closedEvent = HackathonEvent(
      id: event.id,
      title: event.title,
      description: event.description,
      startDate: event.startDate,
      endDate: event.endDate,
      location: event.location,
      bannerUrl: event.bannerUrl,
      registrationDeadline: DateTime.now(),
      maxTeamSize: event.maxTeamSize,
      rules: event.rules,
      prize: event.prize,
      latitude: event.latitude,
      longitude: event.longitude,
    );
    await context.read<EventProvider>().saveEvent(
      closedEvent,
      existingEventId: event.id,
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã đóng đăng ký cho event này.')),
    );
  }

  Future<void> _showUserRolesDialog(BuildContext context) async {
    final users = await const UserDirectoryService().fetchUsers();
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Role người dùng'),
        content: SizedBox(
          width: 420,
          child: users.isEmpty
              ? const EmptyState(message: 'Chưa có người dùng.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(user.fullName),
                      subtitle: Text(user.email),
                      trailing: StatusPill(label: AppRoles.label(user.role)),
                    );
                  },
                ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Xong'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetDemoData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset dữ liệu demo?'),
        content: const Text(
          'Edge Function sẽ xóa dữ liệu demo cũ và seed lại workspace sạch. Chỉ role Ban tổ chức được phép chạy.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      final message = await const AdminService().resetDemoData();
      if (!context.mounted) return;
      await widget.onRefresh();
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(FriendlyErrorMapper.message(error)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _showTeamDetails(BuildContext context, Team team) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(team.name),
        content: SizedBox(
          width: 420,
          child: ListView(
            shrinkWrap: true,
            children: [
              StatusPill(
                label: '${team.members.length} thành viên',
                icon: Icons.groups_outlined,
              ),
              const SizedBox(height: 12),
              for (final member in team.members)
                ListTile(
                  leading: Icon(
                    member.id == team.leaderId
                        ? Icons.verified_outlined
                        : Icons.person_outline,
                  ),
                  title: Text(member.fullName),
                  subtitle: Text(
                    '${member.email}\n${AppRoles.label(member.role)}',
                  ),
                  isThreeLine: true,
                ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Xong'),
          ),
        ],
      ),
    );
  }

  Future<void> _showSubmissionDetails(
    BuildContext context,
    ProjectSubmission submission,
    ScoreProvider scores,
    List<Team> teams,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(submission.projectName),
        content: SizedBox(
          width: 420,
          child: ListView(
            shrinkWrap: true,
            children: [
              StatusPill(
                label: AppLabels.submissionStatus(submission.status),
                icon: Icons.task_alt_outlined,
              ),
              const SizedBox(height: 12),
              DetailTile(
                title: 'Team',
                value: _teamName(submission.teamId, teams),
              ),
              DetailTile(title: 'Repository', value: submission.githubUrl),
              DetailTile(title: 'Demo', value: submission.videoUrl),
              DetailTile(title: 'Mô tả', value: submission.description),
              DetailTile(
                title: 'Điểm trung bình',
                value: scores.averageFor(submission.id).toStringAsFixed(1),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Xong'),
          ),
        ],
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
        title: Text(existing == null ? 'Tạo event' : 'Sửa event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogField(controller: title, label: 'Tiêu đề'),
              _DialogField(controller: description, label: 'Mô tả', lines: 3),
              _DialogField(controller: location, label: 'Địa điểm'),
              _DialogField(controller: banner, label: 'Banner URL'),
              _DialogField(controller: start, label: 'Ngày bắt đầu'),
              _DialogField(controller: end, label: 'Ngày kết thúc'),
              _DialogField(controller: deadline, label: 'Deadline đăng ký'),
              _DialogField(
                controller: maxTeamSize,
                label: 'Số thành viên tối đa',
                keyboardType: TextInputType.number,
              ),
              _DialogField(controller: rules, label: 'Luật thi', lines: 2),
              _DialogField(controller: prize, label: 'Giải thưởng'),
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
            child: const Text('Hủy'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            icon: const Icon(Icons.save_outlined),
            label: const Text('Lưu'),
          ),
        ],
      ),
    );
    if (shouldSave != true || !context.mounted) return;
    if (title.text.trim().isEmpty || location.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tiêu đề và địa điểm event là bắt buộc.')),
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

class _OrganizerSectionPicker extends StatelessWidget {
  const _OrganizerSectionPicker({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CommandChip(
            label: 'Tổng quan',
            selected: value == 'overview',
            onTap: () => onChanged('overview'),
            icon: Icons.dashboard_outlined,
          ),
          const SizedBox(width: 8),
          CommandChip(
            label: 'Vận hành',
            selected: value == 'operations',
            onTap: () => onChanged('operations'),
            icon: Icons.tune_outlined,
          ),
          const SizedBox(width: 8),
          CommandChip(
            label: 'Events',
            selected: value == 'events',
            onTap: () => onChanged('events'),
            icon: Icons.event_outlined,
          ),
          const SizedBox(width: 8),
          CommandChip(
            label: 'Team',
            selected: value == 'teams',
            onTap: () => onChanged('teams'),
            icon: Icons.groups_outlined,
          ),
          const SizedBox(width: 8),
          CommandChip(
            label: 'Bài nộp',
            selected: value == 'submissions',
            onTap: () => onChanged('submissions'),
            icon: Icons.assignment_outlined,
          ),
        ],
      ),
    );
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
            _BarRow(label: 'Team', value: teams, maxValue: maxValue),
            _BarRow(label: 'Bài nộp', value: submissions, maxValue: maxValue),
            _BarRow(
              label: 'Đã chấm',
              value: scored,
              maxValue: maxValue,
              color: SealPalette.secondary,
            ),
            _BarRow(
              label: 'Chưa chấm',
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

class _SystemStatusCard extends StatelessWidget {
  const _SystemStatusCard({
    required this.events,
    required this.teams,
    required this.submissions,
    required this.scores,
  });

  final EventProvider events;
  final TeamProvider teams;
  final SubmissionProvider submissions;
  final ScoreProvider scores;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final loading =
        events.isLoading ||
        teams.isLoading ||
        submissions.isLoading ||
        scores.isLoading;
    final errors = [
      events.error,
      teams.error,
      submissions.error,
      scores.error,
    ].whereType<String>().toList();
    return Semantics(
      label: 'Trạng thái hệ thống database và state app',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'System Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Text(
                'Trạng thái Database/API và Provider để demo.',
                style: TextStyle(color: SealPalette.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusPill(
                    label: SupabaseConfig.displayName,
                    icon: Icons.dns_outlined,
                  ),
                  StatusPill(
                    label: SupabaseConfig.isConfigured
                        ? 'Database đã kết nối'
                        : 'Thiếu Database',
                    color: SupabaseConfig.isConfigured
                        ? SealPalette.secondary
                        : SealPalette.error,
                    icon: SupabaseConfig.isConfigured
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_off_outlined,
                  ),
                  StatusPill(
                    label: loading ? 'Đang đồng bộ' : 'State sẵn sàng',
                    color: loading ? SealPalette.tertiary : SealPalette.primary,
                    icon: loading
                        ? Icons.sync_outlined
                        : Icons.check_circle_outline,
                  ),
                  StatusPill(
                    label: auth.user == null
                        ? 'Chưa đăng nhập'
                        : AppRoles.label(auth.user!.role),
                    icon: Icons.verified_user_outlined,
                  ),
                  StatusPill(
                    label: errors.isEmpty
                        ? 'Không có lỗi API'
                        : '${errors.length} lỗi',
                    color: errors.isEmpty
                        ? SealPalette.secondary
                        : SealPalette.error,
                    icon: errors.isEmpty
                        ? Icons.verified_outlined
                        : Icons.error_outline,
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
                      label: 'Team',
                      value: '${teams.teams.length}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      label: 'Bài nộp',
                      value: '${submissions.submissions.length}',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MetricCard(
                      label: 'Scores',
                      value: '${scores.scores.length}',
                    ),
                  ),
                ],
              ),
            ],
          ),
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
