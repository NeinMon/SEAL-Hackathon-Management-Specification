part of '../../main.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  final name = TextEditingController();
  String? selectedEventId;

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
    final manageableTeams = user == null
        ? <Team>[]
        : teams.teams.where((team) => team.leaderId == user.id).toList();
    final canCreateTeam =
        user != null &&
        AppRoles.participantCreators.contains(user.role) &&
        selectedEvent != null &&
        name.text.trim().isNotEmpty;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SealSectionHeader(
          title: 'Teams',
          subtitle: 'Create a team, invite members, and manage participation.',
          icon: Icons.groups_outlined,
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
                        'Team overview',
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
                        'Active',
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
                  teams.teams.isEmpty ? 'No teams yet' : 'Teams available',
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
              child: MetricCard(label: 'Teams', value: '${teams.teams.length}'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                label: 'Check-in',
                value: teams.teams.isEmpty ? 'Pending' : 'Verified',
                accent: teams.teams.isEmpty
                    ? SealPalette.tertiary
                    : SealPalette.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => context.go('/submit'),
          icon: const Icon(Icons.upload_file_outlined),
          label: const Text('Submit Project'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: manageableTeams.isEmpty
              ? null
              : () => _showInviteDialog(
                  context,
                  manageableTeams.first,
                  _eventFor(manageableTeams.first.eventId, events.events),
                ),
          icon: const Icon(Icons.person_add_alt_outlined),
          label: const Text('Invite Member'),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Team',
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
                    labelText: 'Team name',
                    prefixIcon: Icon(Icons.groups_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: !canCreateTeam
                      ? null
                      : () async {
                          final teamName = name.text.trim();
                          await teams.createTeam(teamName, selectedEvent, user);
                          if (!context.mounted) return;
                          if (teams.error == null) name.clear();
                          await context.read<NotificationProvider>().push(
                            'Team created',
                            '$teamName joined ${selectedEvent.title}.',
                            'invitation',
                            userId: user.id,
                          );
                        },
                  icon: const Icon(Icons.add),
                  label: const Text('Create team'),
                ),
                if (events.events.isEmpty) ...[
                  const SizedBox(height: 10),
                  const Text(
                    'No event is available. Load events before creating a team.',
                    style: TextStyle(color: SealPalette.error),
                  ),
                ],
                if (user != null &&
                    !AppRoles.participantCreators.contains(user.role)) ...[
                  const SizedBox(height: 10),
                  const Text(
                    'This role can view teams but cannot create participant teams.',
                    style: TextStyle(color: SealPalette.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (teams.error != null)
          StatusBanner(message: teams.error!, isError: true),
        if (teams.message != null) StatusBanner(message: teams.message!),
        if (teams.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          )
        else if (teams.teams.isEmpty)
          const EmptyState(message: 'No team yet. Create one to continue.')
        else ...[
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Team Roster',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
          ),
          for (final team in teams.teams)
            TeamCard(
              team: team,
              currentUser: user,
              event: _eventFor(team.eventId, events.events),
            ),
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

  Future<void> _showInviteDialog(
    BuildContext context,
    Team team,
    HackathonEvent? event,
  ) async {
    await TeamInviteFlow.show(context, team: team, event: event);
  }
}

class TeamCard extends StatelessWidget {
  const TeamCard({
    super.key,
    required this.team,
    required this.currentUser,
    required this.event,
  });

  final Team team;
  final AppUser? currentUser;
  final HackathonEvent? event;

  @override
  Widget build(BuildContext context) {
    final user = currentUser;
    final isMember =
        user != null && team.members.any((member) => member.id == user.id);
    final isLeader = user != null && team.leaderId == user.id;
    final leaderName = _leaderName(team);
    final eventTitle = event?.title ?? 'Event not loaded';
    final memberLimit = event?.maxTeamSize ?? 0;
    final teamIsFull = memberLimit > 0 && team.members.length >= memberLimit;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.groups_outlined),
              title: Text(
                team.name,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                team.members.isEmpty
                    ? '$eventTitle\nNo members yet'
                    : '$eventTitle\nLeader: $leaderName\nMembers (${team.members.length}${memberLimit > 0 ? '/$memberLimit' : ''}): ${team.members.map((member) => member.fullName).join(', ')}',
              ),
              isThreeLine: true,
              trailing: isLeader
                  ? const StatusPill(
                      label: 'Leader',
                      color: SealPalette.secondary,
                      icon: Icons.verified_outlined,
                    )
                  : teamIsFull
                  ? const StatusPill(
                      label: 'Full',
                      color: SealPalette.tertiary,
                      icon: Icons.lock_outline,
                    )
                  : null,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: user == null || isMember
                      ? null
                      : () => context.read<TeamProvider>().joinTeam(
                          team.id,
                          user,
                          event: event,
                        ),
                  icon: const Icon(Icons.group_add_outlined),
                  label: Text(teamIsFull ? 'Full' : 'Join'),
                ),
                OutlinedButton.icon(
                  onPressed: user == null || !isMember
                      ? null
                      : () => context.read<TeamProvider>().leaveTeam(
                          team.id,
                          user,
                        ),
                  icon: const Icon(Icons.exit_to_app_outlined),
                  label: const Text('Leave'),
                ),
                if (isLeader)
                  OutlinedButton.icon(
                    onPressed: () => _showEditTeamDialog(context, team),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit'),
                  ),
                if (isLeader)
                  OutlinedButton.icon(
                    onPressed: teamIsFull
                        ? null
                        : () => _showInviteDialog(context, team, event),
                    icon: const Icon(Icons.person_add_alt_outlined),
                    label: const Text('Invite'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _leaderName(Team team) {
    for (final member in team.members) {
      if (member.id == team.leaderId) return member.fullName;
    }
    return 'Unknown';
  }

  Future<void> _showEditTeamDialog(BuildContext context, Team team) async {
    final controller = TextEditingController(text: team.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update team'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Team name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (newName == null || newName.isEmpty || !context.mounted) return;
    await context.read<TeamProvider>().updateTeamName(team.id, newName);
  }

  Future<void> _showInviteDialog(
    BuildContext context,
    Team team,
    HackathonEvent? event,
  ) async {
    await TeamInviteFlow.show(context, team: team, event: event);
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
        title: const Text('Invite member'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Member email'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Invite'),
          ),
        ],
      ),
    );
    if (email == null || email.isEmpty || !context.mounted) return;
    await context.read<TeamProvider>().inviteMember(
      team.id,
      email,
      event: event,
    );
    if (!context.mounted) return;
    final invited = await const UserDirectoryService().findByEmail(email);
    if (!context.mounted) return;
    if (invited != null) {
      await context.read<NotificationProvider>().push(
        'Team invitation',
        'You were invited to ${team.name}.',
        'invitation',
        userId: invited.id,
      );
    }
  }
}
