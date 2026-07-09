import '../../../shared.dart';

class OtpInput extends StatelessWidget {
  const OtpInput({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          key: const Key('signup_otp_field'),
          controller: controller,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          maxLength: 6,
          validator: AppValidators.signupOtp,
          decoration: InputDecoration(
            labelText: L10nService.strings.otpLabel,
            prefixIcon: Icon(Icons.pin_outlined),
            counterText: '',
          ),
        ),
        const SizedBox(height: AppSizes.paddingSmall),
        Text(
          L10nService.strings.otpHelpText,
          style: TextStyle(
            color: context.sealTheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
