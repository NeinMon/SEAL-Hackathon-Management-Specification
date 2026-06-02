import '../../shared.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController fullName;
  late final TextEditingController university;
  String initialFullName = '';
  String initialUniversity = '';

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    initialFullName = user?.fullName ?? '';
    initialUniversity = user?.university ?? '';
    fullName = TextEditingController(text: initialFullName);
    university = TextEditingController(text: initialUniversity);
    fullName.addListener(_refreshDirtyState);
    university.addListener(_refreshDirtyState);
  }

  @override
  void dispose() {
    fullName
      ..removeListener(_refreshDirtyState)
      ..dispose();
    university
      ..removeListener(_refreshDirtyState)
      ..dispose();
    super.dispose();
  }

  void _refreshDirtyState() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final dirty =
        fullName.text.trim() != initialFullName ||
        university.text.trim() != initialUniversity;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SealSectionHeader(
          title: 'Hồ sơ',
          subtitle: 'Quản lý thông tin tài khoản dùng trong các luồng role.',
          icon: Icons.person_outline,
        ),
        if (user == null)
          const EmptyState(message: 'Chưa có phiên đăng nhập.')
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
                    subtitle: Text(AppRoles.label(user.role)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Thông tin tài khoản',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Semantics(
                          label: 'Ô nhập họ tên hồ sơ',
                          child: TextFormField(
                            controller: fullName,
                            validator: (value) =>
                                (value ?? '').trim().length < 2
                                ? 'Nhập họ tên của bạn.'
                                : null,
                            decoration: const InputDecoration(
                              labelText: 'Họ tên',
                              prefixIcon: Icon(Icons.badge_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Semantics(
                          label: 'Ô nhập trường',
                          child: TextFormField(
                            controller: university,
                            validator: (value) =>
                                (value ?? '').trim().length < 2
                                ? 'Nhập trường của bạn.'
                                : null,
                            decoration: const InputDecoration(
                              labelText: 'Trường',
                              prefixIcon: Icon(Icons.school_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (auth.error != null) ...[
                    const SizedBox(height: 12),
                    StatusBanner(message: auth.error!, isError: true),
                  ],
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: auth.isLoading || !dirty
                        ? null
                        : () async {
                            if (!formKey.currentState!.validate()) return;
                            await context.read<AuthProvider>().updateProfile(
                              fullName.text,
                              university.text,
                            );
                            if (!context.mounted) return;
                            initialFullName = fullName.text.trim();
                            initialUniversity = university.text.trim();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đã cập nhật hồ sơ.'),
                              ),
                            );
                          },
                    icon: auth.isLoading
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: const Text('Lưu hồ sơ'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: SealPalette.errorContainer.withValues(alpha: 0.10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Phiên đăng nhập',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Đăng xuất sẽ xóa state cục bộ và quay về màn đăng nhập.',
                    style: TextStyle(color: SealPalette.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: auth.isLoading ? null : () => _logout(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Đăng xuất'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    context.read<EventProvider>().clear();
    context.read<TeamProvider>().clear();
    context.read<SubmissionProvider>().clear();
    context.read<ScoreProvider>().clear();
    context.read<NotificationProvider>().clear();
    context.read<ChatProvider>().clear();
    await context.read<AuthProvider>().logout();
    if (!context.mounted) return;
    context.go(AppRoutes.login);
  }
}
