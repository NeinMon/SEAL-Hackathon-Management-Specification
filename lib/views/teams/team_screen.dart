import '../../shared.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  final name = TextEditingController();
  String? selectedEventId;
  bool showCreateTeam = false;

  @override
  void initState() {
    super.initState();
    name.addListener(_refreshCreateForm);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().loadEvents();
      context.read<TeamProvider>().loadTeams();
    });
  }

  @override
  void dispose() {
    name
      ..removeListener(_refreshCreateForm)
      ..dispose();
    super.dispose();
  }

  void _refreshCreateForm() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final events = context.watch<EventProvider>();
    final teams = context.watch<TeamProvider>();
    final user = auth.user;
    final selectedEvent = _selectedEvent(events.events);
    final loading = events.isLoading || teams.isLoading;
    final myTeams = user == null
        ? <Team>[]
        : teams.teams
              .where(
                (team) => team.members.any((member) => member.id == user.id),
              )
              .toList();
    final otherTeams = user == null
        ? teams.teams
        : teams.teams
              .where(
                (team) => !team.members.any((member) => member.id == user.id),
              )
              .toList();
    final canCreateTeamRole =
        user != null && AppRoles.participantCreators.contains(user.role);
    final canCreateTeam =
        canCreateTeamRole &&
        selectedEvent != null &&
        name.text.trim().isNotEmpty &&
        !loading;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SealSectionHeader(
          title: 'Team',
          subtitle: 'Tạo team, mời thành viên và quản lý tham gia.',
          icon: Icons.groups_outlined,
          trailing: IconButton.filledTonal(
            tooltip: 'Tải lại Team',
            onPressed: loading
                ? null
                : () => Future.wait([
                    context.read<EventProvider>().loadEvents(),
                    context.read<TeamProvider>().loadTeams(),
                  ]),
            icon: const Icon(Icons.refresh),
          ),
        ),
        if (events.error != null)
          StatusBanner(message: events.error!, isError: true),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Tổng quan team',
                        style: TextStyle(
                          color: SealPalette.onSurfaceVariant,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: SealPalette.secondary.withValues(alpha: 0.12),
                        border: Border.all(
                          color: SealPalette.secondary.withValues(alpha: 0.45),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Đang mở',
                        style: TextStyle(
                          color: SealPalette.secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  teams.teams.isEmpty ? 'Chưa có team' : 'Team đang có',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 18),
                LinearProgressIndicator(
                  value: teams.teams.isEmpty ? 0.25 : 0.85,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(8),
                  color: SealPalette.secondary,
                  backgroundColor: SealPalette.surfaceContainerHighest,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: MetricCard(label: 'Team', value: '${teams.teams.length}'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                label: 'Check-in',
                value: teams.teams.isEmpty ? 'Chờ' : 'Đã xác nhận',
                accent: teams.teams.isEmpty
                    ? SealPalette.tertiary
                    : SealPalette.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (myTeams.isNotEmpty) ...[
          FilledButton.icon(
            onPressed: loading ? null : () => context.go(AppRoutes.submit),
            icon: const Icon(Icons.upload_file_outlined),
            label: const Text('Nộp project'),
          ),
          const SizedBox(height: 16),
        ] else if (canCreateTeamRole &&
            teams.teams.isNotEmpty &&
            !showCreateTeam) ...[
          FilledButton.icon(
            onPressed: loading
                ? null
                : () => setState(() => showCreateTeam = true),
            icon: const Icon(Icons.add),
            label: const Text('Tạo team'),
          ),
          const SizedBox(height: 16),
        ],
        if (showCreateTeam || teams.teams.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tạo team',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    key: ValueKey(
                      'team-event-${selectedEvent?.id}-${events.events.length}',
                    ),
                    initialValue: selectedEvent?.id,
                    decoration: const InputDecoration(
                      labelText: 'Event',
                      prefixIcon: Icon(Icons.event_outlined),
                    ),
                    items: [
                      for (final event in events.events)
                        DropdownMenuItem(
                          value: event.id,
                          child: Text(event.title),
                        ),
                    ],
                    onChanged: events.events.isEmpty
                        ? null
                        : (value) => setState(() => selectedEventId = value),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: name,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Tên team',
                      prefixIcon: Icon(Icons.groups_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (teams.teams.isNotEmpty) ...[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: loading
                                ? null
                                : () => setState(() {
                                    showCreateTeam = false;
                                    name.clear();
                                  }),
                            icon: const Icon(Icons.close),
                            label: const Text('Hủy'),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: !canCreateTeam
                              ? null
                              : () async {
                                  final teamName = name.text.trim();
                                  await teams.createTeam(
                                    teamName,
                                    selectedEvent,
                                    user,
                                  );
                                  if (!context.mounted) return;
                                  if (teams.error == null) {
                                    setState(() {
                                      showCreateTeam = false;
                                      name.clear();
                                    });
                                    await context.read<NotificationProvider>().push(
                                      'Đã tạo team',
                                      '$teamName đã tham gia ${selectedEvent.title}.',
                                      'invitation',
                                      userId: user.id,
                                    );
                                  }
                                },
                          icon: loading
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.add),
                          label: const Text('Tạo team'),
                        ),
                      ),
                    ],
                  ),
                  if (events.events.isEmpty) ...[
                    const SizedBox(height: 10),
                    const Text(
                      'Chưa có event. Tải event trước khi tạo team.',
                      style: TextStyle(color: SealPalette.error),
                    ),
                  ],
                  if (user != null &&
                      !AppRoles.participantCreators.contains(user.role)) ...[
                    const SizedBox(height: 10),
                    const Text(
                      'Role này chỉ xem team, không tạo team thí sinh.',
                      style: TextStyle(color: SealPalette.onSurfaceVariant),
                    ),
                  ],
                ],
              ),
            ),
          )
        else if (canCreateTeamRole)
          OutlinedButton.icon(
            onPressed: loading
                ? null
                : () => setState(() => showCreateTeam = true),
            icon: const Icon(Icons.add),
            label: const Text('Tạo team'),
          ),
        const SizedBox(height: 16),
        if (teams.error != null && teams.teams.isEmpty)
          ErrorState(
            message: teams.error!,
            onRetry: () => context.read<TeamProvider>().loadTeams(),
          )
        else if (teams.error != null)
          StatusBanner(message: teams.error!, isError: true),
        if (teams.message != null) StatusBanner(message: teams.message!),
        if (loading)
          const LoadingCardList(itemCount: 2)
        else if (teams.teams.isEmpty)
          const EmptyState(message: 'Chưa có team. Tạo team để tiếp tục.')
        else ...[
          if (myTeams.isNotEmpty) ...[
            const _TeamGroupTitle(title: 'Team của tôi'),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myTeams.length,
              itemBuilder: (context, index) {
                final team = myTeams[index];
                return TeamCard(
                  team: team,
                  currentUser: user,
                  event: _eventFor(team.eventId, events.events),
                  highlighted: true,
                );
              },
            ),
          ],
          if (otherTeams.isNotEmpty) ...[
            const _TeamGroupTitle(title: 'Team khác'),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: otherTeams.length,
              itemBuilder: (context, index) {
                final team = otherTeams[index];
                return TeamCard(
                  team: team,
                  currentUser: user,
                  event: _eventFor(team.eventId, events.events),
                );
              },
            ),
          ],
        ],
      ],
    );
  }

  HackathonEvent? _selectedEvent(List<HackathonEvent> events) {
    if (events.isEmpty) return null;
    for (final event in events) {
      if (event.id == selectedEventId) return event;
    }
    return events.first;
  }

  HackathonEvent? _eventFor(String eventId, List<HackathonEvent> events) {
    for (final event in events) {
      if (event.id == eventId) return event;
    }
    return null;
  }
}

class _TeamGroupTitle extends StatelessWidget {
  const _TeamGroupTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  const TeamCard({
    super.key,
    required this.team,
    required this.currentUser,
    required this.event,
    this.highlighted = false,
  });

  final Team team;
  final AppUser? currentUser;
  final HackathonEvent? event;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final user = currentUser;
    final isMember =
        user != null && team.members.any((member) => member.id == user.id);
    final isLeader = user != null && team.leaderId == user.id;
    final leaderName = _leaderName(team);
    final eventTitle = event?.title ?? 'Chưa tải event';
    final memberLimit = event?.maxTeamSize ?? 0;
    final teamIsFull = memberLimit > 0 && team.members.length >= memberLimit;
    return Semantics(
      label:
          'Team ${team.name}, ${team.members.length} thành viên, leader $leaderName',
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: highlighted ? SealPalette.primary.withValues(alpha: 0.08) : null,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MemberAvatarStack(members: team.members),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          team.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          eventTitle,
                          style: const TextStyle(
                            color: SealPalette.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Leader: $leaderName',
                          style: const TextStyle(
                            color: SealPalette.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLeader)
                    const StatusPill(
                      label: 'Leader',
                      color: SealPalette.secondary,
                      icon: Icons.verified_outlined,
                    )
                  else if (teamIsFull)
                    const StatusPill(
                      label: 'Đã đầy',
                      color: SealPalette.tertiary,
                      icon: Icons.lock_outline,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  StatusPill(
                    label:
                        '${team.members.length}${memberLimit > 0 ? '/$memberLimit' : ''} thành viên',
                    icon: Icons.groups_outlined,
                  ),
                  for (final member in team.members.take(3))
                    StatusPill(label: member.fullName),
                ],
              ),
              const SizedBox(height: 12),
              _TeamActions(
                isLeader: isLeader,
                isMember: isMember,
                teamIsFull: teamIsFull,
                user: user,
                onSubmit: () => context.go(AppRoutes.submit),
                onJoin: user == null
                    ? null
                    : () => context.read<TeamProvider>().joinTeam(
                        team.id,
                        user,
                        event: event,
                      ),
                onLeave: user == null
                    ? null
                    : () => _confirmLeaveTeam(context, team, user),
                onEdit: () => _showEditTeamDialog(context, team),
                onInvite: () => _showInviteDialog(context, team, event),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _leaderName(Team team) {
    for (final member in team.members) {
      if (member.id == team.leaderId) return member.fullName;
    }
    return 'Chưa rõ';
  }

  Future<void> _showEditTeamDialog(BuildContext context, Team team) async {
    final controller = TextEditingController(text: team.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cập nhật team'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Tên team'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
    if (newName == null || newName.isEmpty || !context.mounted) return;
    await context.read<TeamProvider>().updateTeamName(team.id, newName);
  }

  Future<void> _confirmLeaveTeam(
    BuildContext context,
    Team team,
    AppUser user,
  ) async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rời team?'),
        content: Text('Bạn sẽ rời ${team.name}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Rời team'),
          ),
        ],
      ),
    );
    if (shouldLeave != true || !context.mounted) return;
    await context.read<TeamProvider>().leaveTeam(team.id, user);
  }

  Future<void> _showInviteDialog(
    BuildContext context,
    Team team,
    HackathonEvent? event,
  ) async {
    await TeamInviteFlow.show(context, team: team, event: event);
  }
}

class _MemberAvatarStack extends StatelessWidget {
  const _MemberAvatarStack({required this.members});

  final List<AppUser> members;

  @override
  Widget build(BuildContext context) {
    final visible = members.take(3).toList();
    return SizedBox(
      width: 58,
      height: 42,
      child: Stack(
        children: [
          if (visible.isEmpty)
            const _MemberAvatar(label: '?')
          else
            for (var index = 0; index < visible.length; index++)
              Positioned(
                left: index * 16,
                child: _MemberAvatar(label: _initials(visible[index].fullName)),
              ),
        ],
      ),
    );
  }

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first.substring(0, 1);
    final last = parts.length > 1 && parts.last.isNotEmpty
        ? parts.last.substring(0, 1)
        : '';
    return (first + last).toUpperCase();
  }
}

class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 19,
      backgroundColor: SealPalette.primaryContainer,
      foregroundColor: Colors.white,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
    );
  }
}

class _TeamActions extends StatelessWidget {
  const _TeamActions({
    required this.isLeader,
    required this.isMember,
    required this.teamIsFull,
    required this.user,
    required this.onSubmit,
    required this.onJoin,
    required this.onLeave,
    required this.onEdit,
    required this.onInvite,
  });

  final bool isLeader;
  final bool isMember;
  final bool teamIsFull;
  final AppUser? user;
  final VoidCallback onSubmit;
  final VoidCallback? onJoin;
  final VoidCallback? onLeave;
  final VoidCallback onEdit;
  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    if (user == null) return const SizedBox.shrink();
    if (isLeader) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilledButton.icon(
            onPressed: teamIsFull ? null : onInvite,
            icon: const Icon(Icons.person_add_alt_outlined),
            label: const Text('Mời'),
          ),
          OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Sửa'),
          ),
          TextButton.icon(
            onPressed: onSubmit,
            icon: const Icon(Icons.upload_file_outlined),
            label: const Text('Nộp bài'),
          ),
        ],
      );
    }
    if (isMember) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilledButton.icon(
            onPressed: onSubmit,
            icon: const Icon(Icons.upload_file_outlined),
            label: const Text('Nộp project'),
          ),
          OutlinedButton.icon(
            onPressed: onLeave,
            icon: const Icon(Icons.exit_to_app_outlined),
            label: const Text('Rời team'),
          ),
        ],
      );
    }
    if (teamIsFull) {
      return const StatusPill(
        label: 'Team đã đầy',
        color: SealPalette.tertiary,
        icon: Icons.lock_outline,
      );
    }
    return FilledButton.icon(
      onPressed: onJoin,
      icon: const Icon(Icons.group_add_outlined),
      label: const Text('Tham gia team'),
    );
  }
}

class TeamInviteFlow {
  const TeamInviteFlow._();

  static Future<void> show(
    BuildContext context, {
    required Team team,
    required HackathonEvent? event,
  }) async {
    final controller = TextEditingController();
    final email = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mời thành viên'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Team: ${team.name}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            if (event != null) ...[
              const SizedBox(height: 4),
              Text(
                event.title,
                style: const TextStyle(color: SealPalette.onSurfaceVariant),
              ),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email thành viên'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Gửi lời mời'),
          ),
        ],
      ),
    );
    if (email == null || email.isEmpty || !context.mounted) return;
    final teamProvider = context.read<TeamProvider>();
    await teamProvider.inviteMember(team.id, email, event: event);
    if (!context.mounted) return;
    if (teamProvider.error != null) return;
    final invited = await const UserDirectoryService().findByEmail(email);
    if (!context.mounted) return;
    if (invited != null) {
      await context.read<NotificationProvider>().push(
        'Lời mời vào team',
        'Bạn được mời vào ${team.name}.',
        'invitation',
        userId: invited.id,
      );
    }
  }
}
