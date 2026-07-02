import '../../../shared.dart';
import 'organizer_dialog_field.dart';

class OrganizerEventDialog {
  const OrganizerEventDialog._();

  static Future<HackathonEvent?> show(
    BuildContext context, {
    HackathonEvent? existing,
  }) {
    return showDialog<HackathonEvent>(
      context: context,
      builder: (dialogContext) => _OrganizerEventDialogForm(existing: existing),
    );
  }

  static String _inputDate(DateTime value) =>
      DateFormat(AppValidators.eventDateTimeFormat).format(value);
}

class _OrganizerEventDialogForm extends StatefulWidget {
  const _OrganizerEventDialogForm({this.existing});

  final HackathonEvent? existing;

  @override
  State<_OrganizerEventDialogForm> createState() =>
      _OrganizerEventDialogFormState();
}

class _OrganizerEventDialogFormState extends State<_OrganizerEventDialogForm> {
  late final TextEditingController title;
  late final TextEditingController description;
  late final TextEditingController location;
  late final TextEditingController banner;
  late final TextEditingController rules;
  late final TextEditingController prize;
  late final TextEditingController maxTeamSize;
  late final TextEditingController start;
  late final TextEditingController end;
  late final TextEditingController deadline;
  late final TextEditingController latitude;
  late final TextEditingController longitude;
  final formKey = GlobalKey<FormState>();
  String? errorText;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final existing = widget.existing;
    title = TextEditingController(text: existing?.title ?? '');
    description = TextEditingController(text: existing?.description ?? '');
    location = TextEditingController(text: existing?.location ?? '');
    banner = TextEditingController(
      text: existing?.bannerUrl ?? AppAssets.defaultEventBanner,
    );
    rules = TextEditingController(text: existing?.rules ?? '');
    prize = TextEditingController(text: existing?.prize ?? '');
    maxTeamSize = TextEditingController(text: '${existing?.maxTeamSize ?? 4}');
    start = TextEditingController(
      text: OrganizerEventDialog._inputDate(
        existing?.startDate ?? now.add(const Duration(days: 1)),
      ),
    );
    end = TextEditingController(
      text: OrganizerEventDialog._inputDate(
        existing?.endDate ?? now.add(const Duration(days: 2)),
      ),
    );
    deadline = TextEditingController(
      text: OrganizerEventDialog._inputDate(existing?.registrationDeadline ?? now),
    );
    latitude = TextEditingController(text: '${existing?.latitude ?? 10.7769}');
    longitude = TextEditingController(text: '${existing?.longitude ?? 106.7009}');
  }

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    location.dispose();
    banner.dispose();
    rules.dispose();
    prize.dispose();
    maxTeamSize.dispose();
    start.dispose();
    end.dispose();
    deadline.dispose();
    latitude.dispose();
    longitude.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final existing = widget.existing;
    return AlertDialog(
      title: Text(
        existing == null ? AppStrings.createEventTitle : AppStrings.editEventTitle,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OrganizerDialogField(
                controller: title,
                label: AppStrings.eventFieldTitle,
                validator: AppValidators.eventTitle,
              ),
              OrganizerDialogField(
                controller: description,
                label: AppStrings.eventFieldDescription,
                lines: 3,
              ),
              OrganizerDialogField(
                controller: location,
                label: AppStrings.eventFieldLocation,
                validator: AppValidators.eventLocation,
              ),
              OrganizerDialogField(
                controller: banner,
                label: AppStrings.eventFieldBannerUrl,
                validator: (value) => AppValidators.optionalWebUrl(
                  value,
                  label: AppStrings.validationBannerUrlLabel,
                ),
              ),
              OrganizerDialogField(
                controller: start,
                label: AppStrings.eventFieldStartDate,
                hintText: AppValidators.eventDateTimeFormat,
                validator: (value) => AppValidators.eventDateTimeField(
                  value,
                  label: AppStrings.eventFieldStartDate,
                ),
              ),
              OrganizerDialogField(
                controller: end,
                label: AppStrings.eventFieldEndDate,
                hintText: AppValidators.eventDateTimeFormat,
                validator: (value) => AppValidators.eventDateTimeField(
                  value,
                  label: AppStrings.eventFieldEndDate,
                ),
              ),
              OrganizerDialogField(
                controller: deadline,
                label: AppStrings.eventFieldRegistrationDeadline,
                hintText: AppValidators.eventDateTimeFormat,
                validator: (value) => AppValidators.eventDateTimeField(
                  value,
                  label: AppStrings.eventFieldRegistrationDeadline,
                ),
              ),
              OrganizerDialogField(
                controller: maxTeamSize,
                label: AppStrings.eventFieldMaxTeamSize,
                keyboardType: TextInputType.number,
                validator: AppValidators.eventMaxTeamSizeField,
              ),
              OrganizerDialogField(
                controller: rules,
                label: AppStrings.eventFieldRules,
                lines: 2,
              ),
              OrganizerDialogField(
                controller: prize,
                label: AppStrings.eventFieldPrize,
              ),
              Row(
                children: [
                  Expanded(
                    child: OrganizerDialogField(
                      controller: latitude,
                      label: AppStrings.eventFieldLatitude,
                      keyboardType: TextInputType.number,
                      validator: AppValidators.latitudeField,
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingSmall),
                  Expanded(
                    child: OrganizerDialogField(
                      controller: longitude,
                      label: AppStrings.eventFieldLongitude,
                      keyboardType: TextInputType.number,
                      validator: AppValidators.longitudeField,
                    ),
                  ),
                ],
              ),
              if (errorText != null) ...[
                const SizedBox(height: AppSizes.paddingCompact),
                Text(
                  errorText!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppStrings.cancelButton),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.save_outlined),
          label: const Text(AppStrings.saveButton),
        ),
      ],
    );
  }

  void _submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final parsedStart = AppValidators.parseEventDateTime(start.text);
    final parsedEnd = AppValidators.parseEventDateTime(end.text);
    final parsedDeadline = AppValidators.parseEventDateTime(deadline.text);
    final parsedMaxTeamSize = int.tryParse(maxTeamSize.text.trim());
    final parsedLatitude = double.tryParse(latitude.text.trim());
    final parsedLongitude = double.tryParse(longitude.text.trim());
    final trimmedTitle = title.text.trim();
    final trimmedDescription = description.text.trim();
    final trimmedLocation = location.text.trim();
    final trimmedBanner = banner.text.trim();
    final trimmedRules = rules.text.trim();
    final trimmedPrize = prize.text.trim();

    if (parsedStart == null ||
        parsedEnd == null ||
        parsedDeadline == null ||
        parsedMaxTeamSize == null ||
        parsedLatitude == null ||
        parsedLongitude == null) {
      setState(() => errorText = AppStrings.invalidEventDatesSnackBar);
      return;
    }

    final payloadError = AppValidators.eventPayload(
      title: trimmedTitle,
      location: trimmedLocation,
      bannerUrl: trimmedBanner,
      startDate: parsedStart,
      endDate: parsedEnd,
      registrationDeadline: parsedDeadline,
      maxTeamSize: parsedMaxTeamSize,
      latitude: parsedLatitude,
      longitude: parsedLongitude,
    );
    if (payloadError != null) {
      setState(() => errorText = payloadError);
      return;
    }

    Navigator.of(context).pop(
      HackathonEvent(
        id: widget.existing?.id ?? 'event-${DateTime.now().millisecondsSinceEpoch}',
        title: trimmedTitle,
        description: trimmedDescription,
        startDate: parsedStart,
        endDate: parsedEnd,
        location: trimmedLocation,
        bannerUrl: trimmedBanner,
        registrationDeadline: parsedDeadline,
        maxTeamSize: parsedMaxTeamSize,
        rules: trimmedRules,
        prize: trimmedPrize,
        latitude: parsedLatitude,
        longitude: parsedLongitude,
      ),
    );
  }
}
