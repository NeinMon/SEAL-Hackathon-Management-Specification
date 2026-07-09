import '../../../shared.dart';

class SubmissionLinkField extends StatelessWidget {
  const SubmissionLinkField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.next,
      validator: (value) => AppValidators.webUrl(value, label: label),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: readOnly
            ? null
            : IconButton(
                tooltip: context.l10n.openLinkTooltip,
                onPressed: () => _openCheckedLink(context),
                icon: Icon(Icons.open_in_new_outlined),
              ),
      ),
    );
  }

  Future<void> _openCheckedLink(BuildContext context) async {
    final value = controller.text.trim();
    final error = AppValidators.webUrl(value, label: label);
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    final opened = await ExternalLauncher.openUrl(value);
    if (!context.mounted) return;
    if (!opened) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.openLinkFailed)));
    }
  }
}
