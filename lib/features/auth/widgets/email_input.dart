import '../../../shared.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      validator: AppValidators.loginEmail,
      decoration: const InputDecoration(
        labelText: AppStrings.emailLabel,
        prefixIcon: Icon(Icons.alternate_email),
      ),
    );
  }
}
