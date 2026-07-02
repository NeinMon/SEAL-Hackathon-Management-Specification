import '../../../shared.dart';
import 'organizer_dialog_field.dart';

class OrganizerEventDialog {
  const OrganizerEventDialog._();

  static Future<void> show(
    BuildContext context, {
    HackathonEvent? existing,
  }) async {
    final now = DateTime.now();
    final title = TextEditingController(text: existing?.title ?? '');
    final description = TextEditingController(
      text: existing?.description ?? '',
    );
    final location = TextEditingController(text: existing?.location ?? '');
    final banner = TextEditingController(
      text: existing?.bannerUrl ?? AppAssets.defaultEventBanner,
    );
    final rules = TextEditingController(text: existing?.rules ?? '');
    final prize = TextEditingController(text: existing?.prize ?? '');
    final maxTeamSize = TextEditingController(
      text: '${existing?.maxTeamSize ?? 4}',
    );
    final start = TextEditingController(
      text: _inputDate(existing?.startDate ?? now.add(const Duration(days: 1))),
    );
    final end = TextEditingController(
      text: _inputDate(existing?.endDate ?? now.add(const Duration(days: 2))),
    );
    final deadline = TextEditingController(
      text: _inputDate(existing?.registrationDeadline ?? now),
    );
    final latitude = TextEditingController(
      text: '${existing?.latitude ?? 10.7769}',
    );
    final longitude = TextEditingController(
      text: '${existing?.longitude ?? 106.7009}',
    );

    final formKey = GlobalKey<FormState>();
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          existing == null
              ? AppStrings.createEventTitle
              : AppStrings.editEventTitle,
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
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.cancelButton),
          ),
          FilledButton.icon(
            onPressed: () {
              if (!(formKey.currentState?.validate() ?? false)) return;
              Navigator.of(dialogContext).pop(true);
            },
            icon: const Icon(Icons.save_outlined),
            label: const Text(AppStrings.saveButton),
          ),
        ],
      ),
    );

    if (shouldSave != true || !context.mounted) {
      _disposeControllers(
        title,
        description,
        location,
        banner,
        rules,
        prize,
        maxTeamSize,
        start,
        end,
        deadline,
        latitude,
        longitude,
      );
      return;
    }

    final parsedStart = AppValidators.parseEventDateTime(start.text);
    final parsedEnd = AppValidators.parseEventDateTime(end.text);
    final parsedDeadline = AppValidators.parseEventDateTime(deadline.text);
    final parsedMaxTeamSize = int.parse(maxTeamSize.text.trim());
    final parsedLatitude = double.parse(latitude.text.trim());
    final parsedLongitude = double.parse(longitude.text.trim());
    final trimmedTitle = title.text.trim();
    final trimmedDescription = description.text.trim();
    final trimmedLocation = location.text.trim();
    final trimmedBanner = banner.text.trim();
    final trimmedRules = rules.text.trim();
    final trimmedPrize = prize.text.trim();

    _disposeControllers(
      title,
      description,
      location,
      banner,
      rules,
      prize,
      maxTeamSize,
      start,
      end,
      deadline,
      latitude,
      longitude,
    );

    if (parsedStart == null || parsedEnd == null || parsedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.invalidEventDatesSnackBar)),
      );
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(payloadError)));
      return;
    }

    final eventProvider = context.read<EventProvider>();
    await eventProvider.saveEvent(
      HackathonEvent(
        id: existing?.id ?? 'event-${DateTime.now().millisecondsSinceEpoch}',
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
      existingEventId: existing?.id,
    );
    if (!context.mounted) return;
    if (eventProvider.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(eventProvider.error!)));
    }
  }

  static String _inputDate(DateTime value) =>
      DateFormat(AppValidators.eventDateTimeFormat).format(value);

  static void _disposeControllers(
    TextEditingController title,
    TextEditingController description,
    TextEditingController location,
    TextEditingController banner,
    TextEditingController rules,
    TextEditingController prize,
    TextEditingController maxTeamSize,
    TextEditingController start,
    TextEditingController end,
    TextEditingController deadline,
    TextEditingController latitude,
    TextEditingController longitude,
  ) {
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
  }
}
