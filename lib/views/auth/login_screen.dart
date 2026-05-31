part of '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final university = TextEditingController();
  String role = 'participant';
  bool registerMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.user != null && mounted) {
        context.go(_homeForRole(auth.user!.role));
      }
    });
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    university.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.hasCheckedSession) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: SealPalette.background,
          gradient: RadialGradient(
            center: const Alignment(-0.65, -0.85),
            radius: 1.1,
            colors: [
              SealPalette.primary.withValues(alpha: 0.16),
              SealPalette.background,
              SealPalette.surfaceContainerLowest,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const HackCommandTopBar(),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                      children: [
                        _LoginHero(),
                        const SizedBox(height: 24),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  registerMode
                                      ? 'Create your account'
                                      : 'Sign in',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.6,
                                    color: SealPalette.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                if (registerMode) ...[
                                  TextField(
                                    controller: name,
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const [AutofillHints.name],
                                    decoration: const InputDecoration(
                                      labelText: 'Full name',
                                      prefixIcon: Icon(Icons.badge_outlined),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: university,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      labelText: 'University',
                                      prefixIcon: Icon(Icons.school_outlined),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                TextField(
                                  controller: email,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.email],
                                  decoration: const InputDecoration(
                                    labelText: 'Email address',
                                    prefixIcon: Icon(Icons.alternate_email),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: password,
                                  obscureText: true,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [AutofillHints.password],
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: Icon(Icons.lock_outline),
                                  ),
                                ),
                                if (registerMode) ...[
                                  const SizedBox(height: 12),
                                  DropdownButtonFormField<String>(
                                    initialValue: role,
                                    decoration: const InputDecoration(
                                      labelText: 'Account role',
                                      prefixIcon: Icon(
                                        Icons.verified_user_outlined,
                                      ),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'participant',
                                        child: Text('Participant'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'judge',
                                        child: Text('Judge'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'mentor',
                                        child: Text('Mentor'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'organizer',
                                        child: Text('Organizer'),
                                      ),
                                    ],
                                    onChanged: (value) => setState(() {
                                      role = value!;
                                    }),
                                  ),
                                ],
                                if (!registerMode) ...[
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Your role is managed by your account profile.',
                                    style: TextStyle(
                                      color: SealPalette.onSurfaceVariant,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                                if (auth.error != null) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    auth.error!,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 20),
                                FilledButton.icon(
                                  onPressed: auth.isLoading
                                      ? null
                                      : () => _submit(context),
                                  icon: auth.isLoading
                                      ? const SizedBox.square(
                                          dimension: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.login),
                                  label: Text(
                                    registerMode ? 'Create account' : 'Sign in',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              onPressed: () => setState(() {
                                registerMode = !registerMode;
                              }),
                              icon: Icon(
                                registerMode
                                    ? Icons.login
                                    : Icons.person_add_alt_outlined,
                              ),
                              label: Text(
                                registerMode
                                    ? 'I already have an account'
                                    : 'Create new account',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    if (registerMode) {
      await auth.register(
        name.text,
        email.text,
        password.text,
        role,
        university.text,
      );
    } else {
      await auth.login(email.text, password.text);
    }
    if (context.mounted && auth.user != null) {
      context.go(_homeForRole(auth.user!.role));
    }
  }

  String _homeForRole(String role) {
    switch (role) {
      case 'judge':
        return AppRoutes.judge;
      case 'mentor':
        return AppRoutes.chat;
      case 'organizer':
        return AppRoutes.organizer;
      case 'participant':
      default:
        return AppRoutes.events;
    }
  }
}

class _LoginHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: SealPalette.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: SealPalette.primary.withValues(alpha: 0.30),
            ),
          ),
          child: const Icon(
            Icons.workspace_premium_outlined,
            color: SealPalette.primary,
            size: 38,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'SEAL Hackathon',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        const Text(
          'Events, teams, submissions, scoring, messages, and venue support in one mobile workspace.',
          textAlign: TextAlign.center,
          style: TextStyle(color: SealPalette.onSurfaceVariant, height: 1.35),
        ),
      ],
    );
  }
}
