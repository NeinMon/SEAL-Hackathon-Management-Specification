import '../../../shared.dart';
import 'organizer_dialog_field.dart';

class OrganizerEventInfoFields extends StatelessWidget {
  const OrganizerEventInfoFields({
    super.key,
    required this.title,
    required this.description,
    required this.rules,
    required this.prize,
    required this.maxTeamSize,
  });

  final TextEditingController title;
  final TextEditingController description;
  final TextEditingController rules;
  final TextEditingController prize;
  final TextEditingController maxTeamSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OrganizerDialogField(
          controller: title,
          label: L10nService.strings.eventFieldTitle,
          validator: AppValidators.eventTitle,
        ),
        OrganizerDialogField(
          controller: description,
          label: L10nService.strings.eventFieldDescription,
          lines: 3,
        ),
        OrganizerDialogField(
          controller: rules,
          label: L10nService.strings.eventFieldRules,
          lines: 2,
        ),
        OrganizerDialogField(
          controller: prize,
          label: L10nService.strings.eventFieldPrize,
        ),
        OrganizerDialogField(
          controller: maxTeamSize,
          label: L10nService.strings.eventFieldMaxTeamSize,
          keyboardType: TextInputType.number,
          validator: AppValidators.eventMaxTeamSizeField,
        ),
      ],
    );
  }
}

class OrganizerEventLocationFields extends StatelessWidget {
  const OrganizerEventLocationFields({
    super.key,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.supportHotline,
    required this.openingHours,
    required this.onSelectOnMap,
  });

  final TextEditingController location;
  final TextEditingController latitude;
  final TextEditingController longitude;
  final TextEditingController supportHotline;
  final TextEditingController openingHours;
  final VoidCallback onSelectOnMap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OrganizerDialogField(
          controller: location,
          label: L10nService.strings.eventFieldLocation,
          validator: AppValidators.eventLocation,
        ),
        OrganizerDialogField(
          controller: supportHotline,
          label: L10nService.strings.eventFieldSupportHotline,
          hintText: L10nService.strings.defaultHotline,
        ),
        OrganizerDialogField(
          controller: openingHours,
          label: L10nService.strings.eventFieldOpeningHours,
          lines: 2,
          hintText: L10nService.strings.defaultOpeningHours,
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onSelectOnMap,
            icon: Icon(Icons.map_outlined),
            label: Text(context.l10n.selectOnMapButton),
          ),
        ),
        const SizedBox(height: 8),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text(context.l10n.advancedCoordinatesTitle),
          subtitle: Text(
            L10nService.strings.coordinatesPreview(latitude.text, longitude.text),
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: OrganizerDialogField(
                    controller: latitude,
                    label: L10nService.strings.eventFieldLatitude,
                    keyboardType: TextInputType.number,
                    validator: AppValidators.latitudeField,
                  ),
                ),
                const SizedBox(width: AppSizes.paddingSmall),
                Expanded(
                  child: OrganizerDialogField(
                    controller: longitude,
                    label: L10nService.strings.eventFieldLongitude,
                    keyboardType: TextInputType.number,
                    validator: AppValidators.longitudeField,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class OrganizerEventTimeFields extends StatelessWidget {
  const OrganizerEventTimeFields({
    super.key,
    required this.start,
    required this.end,
    required this.deadline,
    required this.submissionDeadline,
    required this.onPickDateTime,
  });

  final TextEditingController start;
  final TextEditingController end;
  final TextEditingController deadline;
  final TextEditingController submissionDeadline;
  final ValueChanged<TextEditingController> onPickDateTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DatePickerField(
          controller: start,
          label: L10nService.strings.eventFieldStartDate,
          onPickDateTime: onPickDateTime,
        ),
        _DatePickerField(
          controller: end,
          label: L10nService.strings.eventFieldEndDate,
          onPickDateTime: onPickDateTime,
        ),
        _DatePickerField(
          controller: deadline,
          label: L10nService.strings.eventFieldRegistrationDeadline,
          onPickDateTime: onPickDateTime,
        ),
        _DatePickerField(
          controller: submissionDeadline,
          label: L10nService.strings.eventFieldSubmissionDeadline,
          onPickDateTime: onPickDateTime,
        ),
      ],
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.controller,
    required this.label,
    required this.onPickDateTime,
  });

  final TextEditingController controller;
  final String label;
  final ValueChanged<TextEditingController> onPickDateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => onPickDateTime(controller),
        child: IgnorePointer(
          child: OrganizerDialogField(
            controller: controller,
            label: label,
            suffixIcon: Icon(Icons.calendar_today_outlined, size: 20),
            validator: (value) =>
                AppValidators.eventDateTimeField(value, label: label),
          ),
        ),
      ),
    );
  }
}
