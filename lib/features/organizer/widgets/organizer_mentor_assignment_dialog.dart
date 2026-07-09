import '../../../shared.dart';

class OrganizerMentorAssignmentDialog {
  const OrganizerMentorAssignmentDialog._();

  static Future<void> show(
    BuildContext context, {
    required List<HackathonEvent> events,
    HackathonEvent? focusEvent,
  }) async {
    if (events.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.noEventsForMentorAssignment)),
      );
      return;
    }
    final users = await const UserDirectoryService().fetchUsers();
    if (!context.mounted) return;
    final mentors = users
        .where((user) => user.role == AppRoles.mentor)
        .toList()
      ..sort((a, b) => a.fullName.compareTo(b.fullName));
    if (mentors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.noMentorsAvailableMessage)),
      );
      return;
    }

    var selectedEvent = focusEvent ?? events.first;
    final service = const EventMentorService();
    final selectedMentorIds = <String>{};
    try {
      selectedMentorIds.addAll(
        await service.fetchMentorIdsForEvent(selectedEvent.id),
      );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.mentorAssignmentLoadFailed)),
        );
      }
      return;
    }

    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          Future<void> changeEvent(String eventId) async {
            setDialogState(() {});
            selectedEvent = events.firstWhere((event) => event.id == eventId);
            try {
              final ids = await service.fetchMentorIdsForEvent(selectedEvent.id);
              selectedMentorIds
                ..clear()
                ..addAll(ids);
            } catch (_) {
              if (dialogContext.mounted) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.mentorAssignmentLoadFailed),
                  ),
                );
              }
            }
            if (dialogContext.mounted) setDialogState(() {});
          }

          return AlertDialog(
            title: Text(context.l10n.manageEventMentorsTitle),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedEvent.id,
                    decoration: InputDecoration(
                      labelText: L10nService.strings.eventLabel,
                      prefixIcon: Icon(Icons.event_outlined),
                    ),
                    items: [
                      for (final event in events)
                        DropdownMenuItem(
                          value: event.id,
                          child: Text(
                            event.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (eventId) {
                      if (eventId == null) return;
                      changeEvent(eventId);
                    },
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 320),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: mentors.length,
                      itemBuilder: (context, index) {
                        final mentor = mentors[index];
                        final selected = selectedMentorIds.contains(mentor.id);
                        return CheckboxListTile(
                          value: selected,
                          onChanged: (value) {
                            setDialogState(() {
                              if (value == true) {
                                selectedMentorIds.add(mentor.id);
                              } else {
                                selectedMentorIds.remove(mentor.id);
                              }
                            });
                          },
                          title: Text(mentor.fullName),
                          subtitle: Text(mentor.email),
                          secondary: Icon(Icons.school_outlined),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(context.l10n.cancelButton),
              ),
              FilledButton(
                onPressed: () async {
                  try {
                    await service.saveMentorsForEvent(
                      eventId: selectedEvent.id,
                      mentorIds: selectedMentorIds.toList(),
                    );
                    if (!dialogContext.mounted) return;
                    Navigator.of(dialogContext).pop();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          L10nService.strings.mentorAssignmentSavedSuccess(
                            selectedMentorIds.length,
                          ),
                        ),
                      ),
                    );
                  } catch (exception) {
                    if (!dialogContext.mounted) return;
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(
                        content: Text(FriendlyErrorMapper.message(exception)),
                      ),
                    );
                  }
                },
                child: Text(context.l10n.saveButton),
              ),
            ],
          );
        },
      ),
    );
  }
}
