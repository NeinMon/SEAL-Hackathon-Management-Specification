import '../../../shared.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({
    super.key,
    required this.formKey,
    required this.fullName,
    required this.university,
    required this.isLoading,
    required this.isDirty,
    required this.error,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullName;
  final TextEditingController university;
  final bool isLoading;
  final bool isDirty;
  final String? error;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              L10nService.strings.accountInfoTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSizes.paddingCompact),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Semantics(
                    label: L10nService.strings.profileFullNameFieldSemantic,
                    child: TextFormField(
                      controller: fullName,
                      validator: AppValidators.registerName,
                      decoration: InputDecoration(
                        labelText: L10nService.strings.fullNameLabel,
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingCompact),
                  Semantics(
                    label: L10nService.strings.profileUniversityFieldSemantic,
                    child: TextFormField(
                      controller: university,
                      validator: AppValidators.registerUniversity,
                      decoration: InputDecoration(
                        labelText: L10nService.strings.universityLabel,
                        prefixIcon: Icon(Icons.school_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (error != null) ...[
              const SizedBox(height: AppSizes.paddingCompact),
              StatusBanner(message: error!, isError: true),
            ],
            const SizedBox(height: AppSizes.paddingMedium),
            FilledButton.icon(
              onPressed: isLoading || !isDirty ? null : onSave,
              icon: isLoading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.save_outlined),
              label: Text(context.l10n.saveProfileButton),
            ),
          ],
        ),
      ),
    );
  }
}
