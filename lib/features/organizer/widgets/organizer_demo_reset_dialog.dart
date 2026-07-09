import '../../../shared.dart';

class OrganizerDemoResetDialog {
  const OrganizerDemoResetDialog._();

  static Future<void> show(
    BuildContext context, {
    required Future<void> Function() onResetComplete,
  }) async {
    final controller = TextEditingController();
    var isResetting = false;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: Text(context.l10n.demoResetTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.demoResetDescription),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: L10nService.strings.demoResetConfirmLabel,
                  ),
                  enabled: !isResetting,
                  onChanged: (_) => setDialogState(() {}),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isResetting
                    ? null
                    : () => Navigator.of(dialogContext).pop(),
                child: Text(context.l10n.cancelButton),
              ),
              FilledButton(
                onPressed: isResetting || controller.text.trim() != 'RESET'
                    ? null
                    : () async {
                        setDialogState(() => isResetting = true);
                        try {
                          await const DemoResetService().resetDemoData();
                          if (!dialogContext.mounted) return;
                          Navigator.of(dialogContext).pop();
                          await onResetComplete();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.l10n.demoResetSuccess),
                            ),
                          );
                        } catch (exception) {
                          if (!dialogContext.mounted) return;
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(
                              content: Text(
                                FriendlyErrorMapper.message(exception),
                              ),
                            ),
                          );
                          setDialogState(() => isResetting = false);
                        }
                      },
                child: isResetting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(context.l10n.resetButton),
              ),
            ],
          );
        },
      ),
    );
    controller.dispose();
  }
}
