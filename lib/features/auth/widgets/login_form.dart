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
    required this.passwordRecoveryMode,
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
  final bool passwordRecoveryMode;
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginTitle(
                  awaitingVerification: awaitingVerification,
                  registerMode: registerMode,
                ),
                const SizedBox(height: AppSizes.paddingMedium),
                if (passwordRecoveryMode) ...[
                  Text(
                    'Nhập mật khẩu mới cho tài khoản của bạn.',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSizes.paddingCompact),
                  PasswordInput(
                    controller: password,
                    showPassword: showPassword,
                    onToggleVisibility: onTogglePassword,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSizes.paddingCompact),
                  ConfirmPasswordInput(
                    controller: confirmPassword,
                    passwordController: password,
                    showPassword: showConfirmPassword,
                    onToggleVisibility: onToggleConfirmPassword,
                  ),
                ] else if (awaitingVerification) ...[
                  Text(
                    '${L10nService.strings.emailPrefix} $pendingVerificationEmail',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSizes.paddingCompact),
                  OtpInput(controller: otp),
                ] else ...[
                  if (registerMode) ...[
                    TextFormField(
                      controller: name,
                      textInputAction: TextInputAction.next,
                      autofillHints: [AutofillHints.name],
                      validator: AppValidators.registerName,
                      decoration: InputDecoration(
                        labelText: L10nService.strings.fullNameLabel,
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingCompact),
                    TextFormField(
                      controller: university,
                      textInputAction: TextInputAction.next,
                      autofillHints: [AutofillHints.organizationName],
                      validator: AppValidators.registerUniversity,
                      decoration: InputDecoration(
                        labelText: L10nService.strings.universityLabel,
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
                    Text(
                      L10nService.strings.registerRoleHint,
                      style: TextStyle(
                        color: context.sealTheme.onSurfaceVariant,
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
                        Expanded(
                          child: Text(
                            L10nService.strings.roleManagedHint,
                            style: TextStyle(
                              color: context.sealTheme.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: isLoading ? null : onForgotPassword,
                          child: Text(context.l10n.forgotPasswordButton),
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
                    style: TextStyle(
                      color: context.sealSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                LoginButton(
                  awaitingVerification: awaitingVerification,
                  registerMode: registerMode,
                  passwordRecoveryMode: passwordRecoveryMode,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : onSubmit,
                ),
                if (awaitingVerification || passwordRecoveryMode) ...[
                  const SizedBox(height: AppSizes.paddingSmall),
                  TextButton(
                    onPressed: isLoading ? null : onCancelVerification,
                    child: Text(context.l10n.backToLoginButton),
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
