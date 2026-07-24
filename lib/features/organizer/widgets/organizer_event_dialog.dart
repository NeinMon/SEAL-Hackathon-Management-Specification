import '../../../shared.dart';
import 'organizer_event_dialog_form.dart';

class OrganizerEventDialog {
  const OrganizerEventDialog._();

  static Future<HackathonEvent?> show(
    BuildContext context, {
    HackathonEvent? existing,
  }) {
    final compact = MediaQuery.sizeOf(context).width < 640;
    if (compact) {
      return showModalBottomSheet<HackathonEvent>(
        context: context,
        isScrollControlled: true,
        useSafeArea: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        builder: (sheetContext) {
          final height = MediaQuery.sizeOf(sheetContext).height;
          return SizedBox(
            height: height,
            child: OrganizerEventDialogForm(existing: existing, compact: true),
          );
        },
      );
    }
    return showDialog<HackathonEvent>(
      context: context,
      builder: (_) =>
          OrganizerEventDialogForm(existing: existing, compact: false),
    );
  }
}
