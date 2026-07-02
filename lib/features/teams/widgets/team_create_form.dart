import '../../../shared.dart';

class TeamCreateForm extends StatelessWidget {
  const TeamCreateForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.events,
    required this.selectedEvent,
    required this.loading,
    required this.canCreateTeam,
    required this.showCancel,
    required this.user,
    required this.onEventChanged,
    required this.onCancel,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final List<HackathonEvent> events;
  final HackathonEvent? selectedEvent;
  final bool loading;
  final bool canCreateTeam;
  final bool showCancel;
  final AppUser? user;
  final ValueChanged<String?> onEventChanged;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.createTeamTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: AppSizes.paddingCompact),
              DropdownButtonFormField<String>(
                key: ValueKey(
                  'team-event-${selectedEvent?.id}-${events.length}',
                ),
                initialValue: selectedEvent?.id,
                decoration: const InputDecoration(
                  labelText: AppStrings.eventLabel,
                  prefixIcon: Icon(Icons.event_outlined),
                ),
                items: [
                  for (final event in events)
                    DropdownMenuItem(value: event.id, child: Text(event.title)),
                ],
                onChanged: events.isEmpty ? null : onEventChanged,
              ),
              const SizedBox(height: AppSizes.paddingCompact),
              TextFormField(
                controller: nameController,
                textInputAction: TextInputAction.done,
                validator: AppValidators.teamName,
                decoration: const InputDecoration(
                  labelText: AppStrings.teamNameLabel,
                  prefixIcon: Icon(Icons.groups_outlined),
                ),
              ),
              const SizedBox(height: AppSizes.paddingCompact),
              Row(
                children: [
                  if (showCancel) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: loading ? null : onCancel,
                        icon: const Icon(Icons.close),
                        label: const Text(AppStrings.cancelButton),
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingSmall + 2),
                  ],
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: !canCreateTeam || loading ? null : onSubmit,
                      icon: loading
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.add),
                      label: const Text(AppStrings.createTeamButton),
                    ),
                  ),
                ],
              ),
              if (selectedEvent != null &&
                  !selectedEvent!.registrationOpen()) ...[
                const SizedBox(height: 10),
                Text(
                  selectedEvent!.registrationBlockReason() ??
                      AppStrings.registrationClosedPill,
                  style: const TextStyle(color: SealPalette.error),
                ),
              ],
              if (events.isEmpty) ...[
                const SizedBox(height: 10),
                const Text(
                  AppStrings.loadEventsBeforeCreateTeam,
                  style: TextStyle(color: SealPalette.error),
                ),
              ],
              if (user != null &&
                  !AppRoles.participantCreators.contains(user!.role)) ...[
                const SizedBox(height: 10),
                const Text(
                  AppStrings.roleViewOnlyTeams,
                  style: TextStyle(color: SealPalette.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
