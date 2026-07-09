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
      autofillHints: [AutofillHints.email],
      validator: AppValidators.loginEmail,
      decoration: InputDecoration(
        labelText: L10nService.strings.emailLabel,
        prefixIcon: Icon(Icons.alternate_email),
      ),
    );
  }
}
