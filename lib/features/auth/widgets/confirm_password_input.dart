import '../../../shared.dart';

class ConfirmPasswordInput extends StatelessWidget {
  const ConfirmPasswordInput({
    super.key,
    required this.controller,
    required this.passwordController,
    required this.showPassword,
    required this.onToggleVisibility,
  });

  final TextEditingController controller;
  final TextEditingController passwordController;
  final bool showPassword;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key('register_confirm_password'),
      controller: controller,
      obscureText: !showPassword,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      validator: (value) =>
          AppValidators.confirmPassword(passwordController.text, value),
      decoration: InputDecoration(
        labelText: AppStrings.confirmPasswordLabel,
        prefixIcon: const Icon(Icons.lock_reset_outlined),
        suffixIcon: IconButton(
          tooltip: showPassword
              ? AppStrings.hidePasswordTooltip
              : AppStrings.showPasswordTooltip,
          onPressed: onToggleVisibility,
          icon: Icon(
            showPassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
      ),
    );
  }
}
