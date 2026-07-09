import '../../../shared.dart';
import '../widgets/login_form.dart';
import '../widgets/login_hero.dart';
import '../widgets/login_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final otp = TextEditingController();
  final name = TextEditingController();
  final university = TextEditingController();
  bool registerMode = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      if (auth.user != null) {
        context.go(_homeForRole(auth.user!.role));
      }
    });
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    otp.dispose();
    name.dispose();
    university.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final router = GoRouter.of(context);
        if (router.state.uri.path == AppRoutes.login) {
          router.go(_homeForRole(auth.user!.role));
        }
      });
    }

    if (!auth.hasCheckedSession) {
      return const LoginSessionBootstrapView();
    }

    final awaitingVerification = auth.pendingVerificationEmail != null;

    return LoginScaffold(
      child: Column(
        children: [
          const HackCommandTopBar(),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.paddingMedium,
                    AppSizes.paddingLarge,
                    AppSizes.paddingMedium,
                    AppSizes.paddingLarge,
                  ),
                  children: [
                    const LoginHero(),
                    const SizedBox(height: AppSizes.paddingLarge),
                    LoginForm(
                      formKey: formKey,
                      email: email,
                      password: password,
                      confirmPassword: confirmPassword,
                      otp: otp,
                      name: name,
                      university: university,
                      registerMode: registerMode,
                      awaitingVerification: awaitingVerification,
                      pendingVerificationEmail: auth.pendingVerificationEmail,
                      showPassword: showPassword,
                      showConfirmPassword: showConfirmPassword,
                      isLoading: auth.isLoading,
                      error: auth.error,
                      infoMessage: auth.infoMessage,
                      onTogglePassword: () =>
                          setState(() => showPassword = !showPassword),
                      onToggleConfirmPassword: () => setState(
                        () => showConfirmPassword = !showConfirmPassword,
                      ),
                      onSubmit: () => _submit(context),
                      onForgotPassword: () => _forgotPassword(context),
                      onCancelVerification: () {
                        auth.cancelEmailVerification();
                        setState(() {
                          registerMode = false;
                          otp.clear();
                        });
                      },
                    ),
                    if (!awaitingVerification) ...[
                      const SizedBox(height: AppSizes.paddingMedium),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              setState(() => registerMode = !registerMode);
                              confirmPassword.clear();
                              context.read<AuthProvider>().clearFeedback();
                            },
                            icon: Icon(
                              registerMode
                                  ? Icons.login
                                  : Icons.person_add_alt_outlined,
                            ),
                            label: Text(
                              registerMode
                                  ? L10nService.strings.haveAccountButton
                                  : L10nService.strings.createAccountButton,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _forgotPassword(BuildContext context) async {
    final emailError = AppValidators.loginEmail(email.text);
    if (emailError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailError)),
      );
      return;
    }
    final auth = context.read<AuthProvider>();
    await auth.requestPasswordReset(email.text);
    if (!context.mounted) return;
    if (auth.infoMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.infoMessage!)),
      );
    }
  }

  Future<void> _submit(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    if (auth.pendingVerificationEmail != null) {
      await auth.verifySignupOtp(otp.text);
    } else if (registerMode) {
      await auth.register(
        name.text,
        email.text,
        password.text,
        confirmPassword.text,
        university.text,
      );
    } else {
      await auth.login(email.text, password.text);
    }
    TextInput.finishAutofillContext();
    if (context.mounted && auth.user != null) {
      context.go(_homeForRole(auth.user!.role));
    }
  }

  String _homeForRole(String role) => RoleLanding.initialRouteForRole(role);
}
