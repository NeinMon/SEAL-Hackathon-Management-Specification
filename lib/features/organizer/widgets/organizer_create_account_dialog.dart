import '../../../shared.dart';

class OrganizerCreateAccountDialog {
  const OrganizerCreateAccountDialog._();

  static Future<AppUser?> show(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 640;
    if (compact) {
      return showModalBottomSheet<AppUser>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => const FractionallySizedBox(
          heightFactor: 0.9,
          child: _OrganizerCreateAccountForm(compact: true),
        ),
      );
    }
    return showDialog<AppUser>(
      context: context,
      builder: (_) => const _OrganizerCreateAccountForm(compact: false),
    );
  }
}

class _OrganizerCreateAccountForm extends StatefulWidget {
  const _OrganizerCreateAccountForm({required this.compact});

  final bool compact;

  @override
  State<_OrganizerCreateAccountForm> createState() =>
      _OrganizerCreateAccountFormState();
}

class _OrganizerCreateAccountFormState
    extends State<_OrganizerCreateAccountForm> {
  final formKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController(text: '123456');
  final university = TextEditingController(text: 'SEAL Lab');
  String role = AppRoles.judge;
  String? errorText;
  bool isSaving = false;

  @override
  void dispose() {
    fullName.dispose();
    email.dispose();
    password.dispose();
    university.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.compact) {
      return Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.createStaffAccountTitle),
          leading: IconButton(
            tooltip: context.l10n.cancelButton,
            onPressed: isSaving ? null : () => Navigator.of(context).pop(),
            icon: Icon(Icons.close),
          ),
          actions: [
            TextButton.icon(
              onPressed: isSaving ? null : _submit,
              icon: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.person_add_alt_outlined),
              label: Text(context.l10n.createAccountButton),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: _buildForm(),
          ),
        ),
      );
    }
    return AlertDialog(
      title: Text(context.l10n.createStaffAccountTitle),
      content: SizedBox(width: 420, child: _buildForm()),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancelButton),
        ),
        FilledButton.icon(
          onPressed: isSaving ? null : _submit,
          icon: isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(Icons.person_add_alt_outlined),
          label: Text(context.l10n.createAccountButton),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: fullName,
              decoration: InputDecoration(
                labelText: L10nService.strings.fullNameLabel,
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: AppValidators.registerName,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                labelText: L10nService.strings.emailLabel,
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: AppValidators.loginEmail,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: password,
              decoration: InputDecoration(
                labelText: L10nService.strings.passwordLabel,
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
              validator: AppValidators.loginPassword,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: university,
              decoration: InputDecoration(
                labelText: L10nService.strings.universityLabel,
                prefixIcon: Icon(Icons.school_outlined),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: role,
              decoration: InputDecoration(
                labelText: L10nService.strings.roleLabel,
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              items: [
                DropdownMenuItem(
                  value: AppRoles.judge,
                  child: Text(context.l10n.roleJudge),
                ),
                DropdownMenuItem(
                  value: AppRoles.mentor,
                  child: Text(context.l10n.roleMentor),
                ),
              ],
              onChanged: isSaving
                  ? null
                  : (value) => setState(() => role = value ?? role),
            ),
            if (errorText != null) ...[
              const SizedBox(height: 10),
              Text(
                errorText!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    setState(() {
      isSaving = true;
      errorText = null;
    });
    try {
      final user = await const UserDirectoryService().createStaffAccount(
        fullName: fullName.text,
        email: email.text,
        password: password.text,
        role: role,
        university: university.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop(user);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        errorText = FriendlyErrorMapper.message(error);
        isSaving = false;
      });
    }
  }
}
