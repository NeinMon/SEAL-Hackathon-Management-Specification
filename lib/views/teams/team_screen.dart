part of '../../main.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  final name = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().loadEvents();
      context.read<TeamProvider>().loadTeams();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final events = context.watch<EventProvider>();
    final teams = context.watch<TeamProvider>();
    final user = auth.user;
    final canCreateTeam =
        user != null &&
        {'participant', 'organizer'}.contains(user.role) &&
        events.events.isNotEmpty;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SealSectionHeader(
          title: 'Team Hub',
          subtitle: 'Create, invite, and manage hackathon team membership.',
          icon: Icons.groups_outlined,
        ),
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
                    fontSize: 28,
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
          onPressed: teams.teams.isEmpty
              ? null
              : () => _showInviteDialog(context, teams.teams.first),
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
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Team name'),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: !canCreateTeam || name.text.trim().isEmpty
                      ? null
                      : () async {
                          await teams.createTeam(
                            name.text.trim(),
                            events.events.first,
                            user,
                          );
                          if (!context.mounted) return;
                          await context.read<NotificationProvider>().push(
                            'Team created',
                            '${name.text.trim()} joined the event.',
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
                    !{'participant', 'organizer'}.contains(user.role)) ...[
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
            TeamCard(team: team, currentUser: user),
        ],
      ],
    );
  }

  Future<void> _showInviteDialog(BuildContext context, Team team) async {
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
    await context.read<TeamProvider>().inviteMember(team.id, email);
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

class TeamCard extends StatelessWidget {
  const TeamCard({super.key, required this.team, required this.currentUser});

  final Team team;
  final AppUser? currentUser;

  @override
  Widget build(BuildContext context) {
    final user = currentUser;
    final isMember =
        user != null && team.members.any((member) => member.id == user.id);
    final isLeader = user != null && team.leaderId == user.id;
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
              title: Text(team.name),
              subtitle: Text(
                team.members.isEmpty
                    ? 'No members'
                    : 'Members: ${team.members.map((member) => member.fullName).join(', ')}',
              ),
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
                        ),
                  icon: const Icon(Icons.group_add_outlined),
                  label: const Text('Join'),
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
                    onPressed: () => _showInviteDialog(context, team),
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

  Future<void> _showInviteDialog(BuildContext context, Team team) async {
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
    await context.read<TeamProvider>().inviteMember(team.id, email);
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
