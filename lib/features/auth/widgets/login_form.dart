import '../../../shared.dart';
import 'confirm_password_input.dart';
import 'email_input.dart';
import 'login_button.dart';
import 'login_title.dart';
import 'otp_input.dart';
import 'password_input.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.otp,
    required this.name,
    required this.university,
    required this.registerMode,
    required this.awaitingVerification,
    required this.pendingVerificationEmail,
    required this.showPassword,
    required this.showConfirmPassword,
    required this.isLoading,
    required this.error,
    required this.infoMessage,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onSubmit,
    required this.onForgotPassword,
    required this.onCancelVerification,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirmPassword;
  final TextEditingController otp;
  final TextEditingController name;
  final TextEditingController university;
  final bool registerMode;
  final bool awaitingVerification;
  final String? pendingVerificationEmail;
  final bool showPassword;
  final bool showConfirmPassword;
  final bool isLoading;
  final String? error;
  final String? infoMessage;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;
  final VoidCallback onCancelVerification;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Form(
          key: formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginTitle(
                  awaitingVerification: awaitingVerification,
                  registerMode: registerMode,
                ),
                const SizedBox(height: AppSizes.paddingMedium),
                if (awaitingVerification) ...[
                  Text(
                    '${AppStrings.emailPrefix} $pendingVerificationEmail',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSizes.paddingCompact),
                  OtpInput(controller: otp),
                ] else ...[
                  if (registerMode) ...[
                    TextFormField(
                      controller: name,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      validator: AppValidators.registerName,
                      decoration: const InputDecoration(
                        labelText: AppStrings.fullNameLabel,
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingCompact),
                    TextFormField(
                      controller: university,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.organizationName],
                      validator: AppValidators.registerUniversity,
                      decoration: const InputDecoration(
                        labelText: AppStrings.universityLabel,
                        prefixIcon: Icon(Icons.school_outlined),
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingCompact),
                  ],
                  EmailInput(controller: email),
                  const SizedBox(height: AppSizes.paddingCompact),
                  PasswordInput(
                    controller: password,
                    showPassword: showPassword,
                    onToggleVisibility: onTogglePassword,
                    textInputAction: registerMode
                        ? TextInputAction.next
                        : TextInputAction.done,
                  ),
                  if (registerMode) ...[
                    const SizedBox(height: AppSizes.paddingCompact),
                    ConfirmPasswordInput(
                      controller: confirmPassword,
                      passwordController: password,
                      showPassword: showConfirmPassword,
                      onToggleVisibility: onToggleConfirmPassword,
                    ),
                    const SizedBox(height: AppSizes.paddingCompact),
                    const Text(
                      AppStrings.registerRoleHint,
                      style: TextStyle(
                        color: SealPalette.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                  ],
                  if (!registerMode) ...[
                    const SizedBox(height: AppSizes.paddingCompact),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            AppStrings.roleManagedHint,
                            style: TextStyle(
                              color: SealPalette.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: isLoading ? null : onForgotPassword,
                          child: const Text(AppStrings.forgotPasswordButton),
                        ),
                      ],
                    ),
                  ],
                ],
                if (error != null) ...[
                  const SizedBox(height: AppSizes.paddingCompact),
                  Text(
                    error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                if (infoMessage != null) ...[
                  const SizedBox(height: AppSizes.paddingCompact),
                  Text(
                    infoMessage!,
                    style: const TextStyle(
                      color: SealPalette.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                LoginButton(
                  awaitingVerification: awaitingVerification,
                  registerMode: registerMode,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : onSubmit,
                ),
                if (awaitingVerification) ...[
                  const SizedBox(height: AppSizes.paddingSmall),
                  TextButton(
                    onPressed: isLoading ? null : onCancelVerification,
                    child: const Text(AppStrings.backToLoginButton),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
