import '../../../shared.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
    required this.controller,
    required this.showPassword,
    required this.onToggleVisibility,
    this.textInputAction = TextInputAction.done,
    this.validator,
  });

  final TextEditingController controller;
  final bool showPassword;
  final VoidCallback onToggleVisibility;
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !showPassword,
      textInputAction: textInputAction,
      autofillHints: const [AutofillHints.password],
      validator: validator ?? AppValidators.loginPassword,
      decoration: InputDecoration(
        labelText: AppStrings.passwordLabel,
        prefixIcon: const Icon(Icons.lock_outline),
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
