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
        useSafeArea: true,
        builder: (_) => FractionallySizedBox(
          heightFactor: 0.95,
          child: OrganizerEventDialogForm(existing: existing, compact: true),
        ),
      );
    }
    return showDialog<HackathonEvent>(
      context: context,
      builder: (_) =>
          OrganizerEventDialogForm(existing: existing, compact: false),
    );
  }
}
