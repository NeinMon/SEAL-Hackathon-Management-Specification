import '../../../shared.dart';
import '../screens/map_picker_screen.dart';
import 'organizer_event_banner_section.dart';
import 'organizer_event_form_sections.dart';

String organizerEventInputDate(DateTime value) =>
    DateFormat(AppValidators.eventDateTimeFormat).format(value);

class OrganizerEventDialogForm extends StatefulWidget {
  const OrganizerEventDialogForm({
    super.key,
    this.existing,
    required this.compact,
  });

  final HackathonEvent? existing;
  final bool compact;

  @override
  State<OrganizerEventDialogForm> createState() =>
      _OrganizerEventDialogFormState();
}

class _OrganizerEventDialogFormState extends State<OrganizerEventDialogForm> {
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
  late final TextEditingController submissionDeadline;
  late final TextEditingController latitude;
  late final TextEditingController longitude;
  late final TextEditingController supportHotline;
  late final TextEditingController openingHours;
  final formKey = GlobalKey<FormState>();
  String? errorText;
  String? _bannerStatus;
  Uint8List? _pickedBannerBytes;
  bool _isUploading = false;

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
    final defaultStart = existing?.startDate ?? now.add(const Duration(days: 1));
    final defaultEnd = existing?.endDate ?? now.add(const Duration(days: 2));
    start = TextEditingController(
      text: organizerEventInputDate(defaultStart),
    );
    end = TextEditingController(
      text: organizerEventInputDate(defaultEnd),
    );
    deadline = TextEditingController(
      text: organizerEventInputDate(
        existing?.registrationDeadline ?? now,
      ),
    );
    submissionDeadline = TextEditingController(
      text: organizerEventInputDate(
        existing?.submissionDeadline ??
            existing?.effectiveSubmissionDeadline ??
            _defaultSubmissionDeadline(defaultStart, defaultEnd),
      ),
    );
    latitude = TextEditingController(text: '${existing?.latitude ?? 10.7769}');
    longitude = TextEditingController(
      text: '${existing?.longitude ?? 106.7009}',
    );
    supportHotline = TextEditingController(text: existing?.supportHotline ?? '');
    openingHours = TextEditingController(text: existing?.openingHours ?? '');
  }

  static DateTime _defaultSubmissionDeadline(DateTime start, DateTime end) {
    final duration = end.difference(start);
    if (duration.inMilliseconds <= 0) return end;
    return start.add(
      Duration(milliseconds: (duration.inMilliseconds * 0.7).round()),
    );
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
    submissionDeadline.dispose();
    latitude.dispose();
    longitude.dispose();
    supportHotline.dispose();
    openingHours.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleText = widget.existing == null
        ? L10nService.strings.createEventTitle
        : L10nService.strings.editEventTitle;
    if (widget.compact) {
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text(titleText),
            leading: IconButton(
              tooltip: context.l10n.cancelButton,
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
            actions: [
              TextButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save_outlined),
                label: Text(context.l10n.saveButton),
              ),
            ],
            bottom: _tabBar(),
          ),
          body: SafeArea(child: _buildFormBody()),
        ),
      );
    }

    return DefaultTabController(
      length: 4,
      child: AlertDialog(
        title: Text(titleText),
        contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        content: SizedBox(
          width: 560,
          height: 520,
          child: Column(
            children: [
              _tabBar(),
              const SizedBox(height: 12),
              Expanded(child: _buildFormBody()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.cancelButton),
          ),
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.save_outlined),
            label: Text(context.l10n.saveButton),
          ),
        ],
      ),
    );
  }

  TabBar _tabBar() {
    return TabBar(
      isScrollable: true,
      tabs: [
        Tab(
          text: L10nService.strings.eventStepInfo,
          icon: const Icon(Icons.info_outline),
        ),
        Tab(
          text: L10nService.strings.eventStepBanner,
          icon: const Icon(Icons.image_outlined),
        ),
        Tab(
          text: L10nService.strings.eventStepLocation,
          icon: const Icon(Icons.place_outlined),
        ),
        Tab(
          text: L10nService.strings.eventStepTime,
          icon: const Icon(Icons.schedule_outlined),
        ),
      ],
    );
  }

  Widget _buildFormBody() {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Expanded(
            child: TabBarView(
              children: [
                _tabList([_buildInfoFields()]),
                _tabList([_buildBannerSection()]),
                _tabList([_buildLocationFields()]),
                _tabList([_buildTimeFields()]),
              ],
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                errorText!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tabList(List<Widget> children) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: children,
    );
  }

  Widget _buildInfoFields() {
    return OrganizerEventInfoFields(
      title: title,
      description: description,
      rules: rules,
      prize: prize,
      maxTeamSize: maxTeamSize,
    );
  }

  Widget _buildLocationFields() {
    return OrganizerEventLocationFields(
      location: location,
      latitude: latitude,
      longitude: longitude,
      supportHotline: supportHotline,
      openingHours: openingHours,
      onSelectOnMap: _selectOnMap,
    );
  }

  Widget _buildTimeFields() {
    return OrganizerEventTimeFields(
      start: start,
      end: end,
      deadline: deadline,
      submissionDeadline: submissionDeadline,
      onPickDateTime: _pickDateTime,
    );
  }

  Widget _buildBannerSection() {
    return OrganizerEventBannerSection(
      banner: banner,
      previewBytes: _pickedBannerBytes,
      status: _bannerStatus,
      isUploading: _isUploading,
      onPickImage: _pickAndUploadImage,
      onClearBanner: _clearBanner,
    );
  }

  Future<void> _pickDateTime(TextEditingController controller) async {
    final current =
        AppValidators.parseEventDateTime(controller.text) ?? DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (time == null) return;

    final picked = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      controller.text = organizerEventInputDate(picked);
    });
  }

  Future<void> _selectOnMap() async {
    final lat = double.tryParse(latitude.text) ?? 10.7769;
    final lng = double.tryParse(longitude.text) ?? 106.7009;
    final LatLng? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapPickerScreen(initialCenter: LatLng(lat, lng)),
      ),
    );

    if (result != null) {
      setState(() {
        latitude.text = result.latitude.toStringAsFixed(6);
        longitude.text = result.longitude.toStringAsFixed(6);
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image == null) return;
    final bytes = await image.readAsBytes();

    setState(() {
      _isUploading = true;
      _pickedBannerBytes = bytes;
      _bannerStatus = null;
      errorText = null;
    });

    try {
      const storageService = StorageService();
      final url = await storageService.uploadEventBanner(image);
      if (url != null) {
        setState(() {
          banner.text = url;
          _pickedBannerBytes = null;
          _bannerStatus = L10nService.strings.bannerUploadSuccess;
        });
      }
    } catch (_) {
      setState(() {
        errorText = L10nService.strings.uploadBannerFailed;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _clearBanner() {
    setState(() {
      banner.clear();
      _pickedBannerBytes = null;
      _bannerStatus = null;
    });
  }

  void _submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final parsedStart = AppValidators.parseEventDateTime(start.text);
    final parsedEnd = AppValidators.parseEventDateTime(end.text);
    final parsedDeadline = AppValidators.parseEventDateTime(deadline.text);
    final parsedSubmissionDeadline =
        AppValidators.parseEventDateTime(submissionDeadline.text);
    final parsedMaxTeamSize = int.tryParse(maxTeamSize.text.trim());
    final parsedLatitude = double.tryParse(latitude.text.trim());
    final parsedLongitude = double.tryParse(longitude.text.trim());
    final trimmedTitle = title.text.trim();
    final trimmedDescription = description.text.trim();
    final trimmedLocation = location.text.trim();
    final trimmedBanner = banner.text.trim();
    final trimmedRules = rules.text.trim();
    final trimmedPrize = prize.text.trim();
    final trimmedHotline = supportHotline.text.trim();
    final trimmedHours = openingHours.text.trim();

    if (parsedStart == null ||
        parsedEnd == null ||
        parsedDeadline == null ||
        parsedSubmissionDeadline == null ||
        parsedMaxTeamSize == null ||
        parsedLatitude == null ||
        parsedLongitude == null) {
      setState(() => errorText = L10nService.strings.invalidEventDatesSnackBar);
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
      submissionDeadline: parsedSubmissionDeadline,
    );
    if (payloadError != null) {
      setState(() => errorText = payloadError);
      return;
    }

    Navigator.of(context).pop(
      HackathonEvent(
        id:
            widget.existing?.id ??
            'event-${DateTime.now().millisecondsSinceEpoch}',
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
        submissionDeadline: parsedSubmissionDeadline,
        supportHotline: trimmedHotline.isEmpty ? null : trimmedHotline,
        openingHours: trimmedHours.isEmpty ? null : trimmedHours,
      ),
    );
  }
}
