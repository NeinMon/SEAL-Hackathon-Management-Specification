import '../../../shared.dart';

class OrganizerDialogField extends StatelessWidget {
  const OrganizerDialogField({
    super.key,
    required this.controller,
    required this.label,
    this.lines = 1,
    this.keyboardType,
    this.hintText,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final int lines;
  final TextInputType? keyboardType;
  final String? hintText;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        minLines: lines,
        maxLines: lines == 1 ? 1 : lines + 1,
        validator: validator,
        decoration: InputDecoration(labelText: label, hintText: hintText),
      ),
    );
  }
}
