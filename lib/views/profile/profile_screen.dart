part of '../../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController fullName;
  late final TextEditingController university;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    fullName = TextEditingController(text: user?.fullName ?? '');
    university = TextEditingController(text: user?.university ?? '');
  }

  @override
  void dispose() {
    fullName.dispose();
    university.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SealSectionHeader(
          title: 'Profile',
          subtitle: 'Manage account identity used by role-based workflows.',
          icon: Icons.person_outline,
        ),
        if (user == null)
          const EmptyState(message: 'No active session.')
        else ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.alternate_email),
                    title: const Text('Email'),
                    subtitle: Text(user.email),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.verified_user_outlined),
                    title: const Text('Role'),
                    subtitle: Text(user.role),
                  ),
                  TextField(
                    controller: fullName,
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: university,
                    decoration: const InputDecoration(
                      labelText: 'University',
                      prefixIcon: Icon(Icons.school_outlined),
                    ),
                  ),
                  if (auth.error != null) ...[
                    const SizedBox(height: 12),
                    StatusBanner(message: auth.error!, isError: true),
                  ],
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: auth.isLoading
                        ? null
                        : () async {
                            await context.read<AuthProvider>().updateProfile(
                              fullName.text,
                              university.text,
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Profile updated.')),
                            );
                          },
                    icon: auth.isLoading
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: const Text('Save Profile'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
