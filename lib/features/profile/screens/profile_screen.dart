import '../../../shared.dart';
import '../widgets/profile_account_card.dart';
import '../widgets/profile_form.dart';
import '../widgets/profile_session_section.dart';

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

  bool get _isDirty =>
      fullName.text.trim() != initialFullName ||
      university.text.trim() != initialUniversity;

  Future<void> _saveProfile() async {
    if (!formKey.currentState!.validate()) return;
    await context.read<AuthProvider>().updateProfile(
      fullName.text,
      university.text,
    );
    if (!mounted) return;
    setState(() {
      initialFullName = fullName.text.trim();
      initialUniversity = university.text.trim();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.profileUpdatedSuccess)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      children: [
        const SealSectionHeader(
          title: AppStrings.profileTitle,
          subtitle: AppStrings.profileSubtitle,
          icon: Icons.person_outline,
        ),
        if (user == null)
          const EmptyState(message: AppStrings.noActiveSession)
        else ...[
          ProfileAccountCard(user: user),
          const SizedBox(height: AppSizes.paddingCompact),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.themeModeTitle,
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text(AppStrings.themeModeDark),
                        icon: Icon(Icons.dark_mode_outlined),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text(AppStrings.themeModeLight),
                        icon: Icon(Icons.light_mode_outlined),
                      ),
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text(AppStrings.themeModeSystem),
                        icon: Icon(Icons.brightness_auto_outlined),
                      ),
                    ],
                    selected: {context.watch<ThemeProvider>().mode},
                    onSelectionChanged: (selection) {
                      context.read<ThemeProvider>().setMode(selection.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.paddingCompact),
          ProfileForm(
            formKey: formKey,
            fullName: fullName,
            university: university,
            isLoading: auth.isLoading,
            isDirty: _isDirty,
            error: auth.error,
            onSave: _saveProfile,
          ),
          const SizedBox(height: AppSizes.paddingCompact),
          ProfileSessionSection(
            isLoading: auth.isLoading,
            onLogout: () => _logout(context),
          ),
        ],
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    if (auth.user == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.notLoggedInMessage)),
      );
      context.go(AppRoutes.login);
      return;
    }
    context.read<EventProvider>().clear();
    context.read<TeamProvider>().clear();
    context.read<SubmissionProvider>().clear();
    context.read<ScoreProvider>().clear();
    context.read<NotificationProvider>().clear();
    context.read<ChatProvider>().clear();
    final loggedOut = await auth.logout();
    if (!context.mounted) return;
    if (!loggedOut) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? AppStrings.logoutFailedMessage)),
      );
      return;
    }
    context.go(AppRoutes.login);
  }
}
