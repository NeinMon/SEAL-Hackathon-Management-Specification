import '../../../shared.dart';

class OrganizerUserRolesDialog {
  const OrganizerUserRolesDialog._();

  static Future<void> show(BuildContext context) async {
    final users = await const UserDirectoryService().fetchUsers();
    if (!context.mounted) return;
    final currentUserId = context.read<AuthProvider>().user?.id;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          var savingUserId = '';
          return AlertDialog(
            title: const Text(AppStrings.manageUserRolesTitle),
            content: SizedBox(
              width: 420,
              child: users.isEmpty
                  ? const EmptyState(message: AppStrings.noUsersYet)
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final isSelf = user.id == currentUserId;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.person_outline),
                          title: Text(user.fullName),
                          subtitle: Text(
                            isSelf
                                ? AppStrings.cannotChangeOwnRoleSubtitle(
                                    user.email,
                                  )
                                : user.email,
                          ),
                          trailing: SizedBox(
                            width: 148,
                            child: DropdownButtonFormField<String>(
                              key: ValueKey('${user.id}-${user.role}'),
                              initialValue: user.role,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: AppRoles.participant,
                                  child: Text(AppStrings.roleParticipant),
                                ),
                                DropdownMenuItem(
                                  value: AppRoles.judge,
                                  child: Text(AppStrings.roleJudge),
                                ),
                                DropdownMenuItem(
                                  value: AppRoles.mentor,
                                  child: Text(AppStrings.roleMentor),
                                ),
                                DropdownMenuItem(
                                  value: AppRoles.organizer,
                                  child: Text(AppStrings.roleOrganizer),
                                ),
                              ],
                              onChanged: isSelf || savingUserId.isNotEmpty
                                  ? null
                                  : (value) async {
                                      if (value == null || value == user.role) {
                                        return;
                                      }
                                      final confirmed = await showDialog<bool>(
                                        context: dialogContext,
                                        builder: (confirmContext) =>
                                            AlertDialog(
                                              title: const Text(
                                                AppStrings
                                                    .changeRoleDialogTitle,
                                              ),
                                              content: Text(
                                                AppStrings.changeRoleDialogBody(
                                                  user.fullName,
                                                  AppRoles.label(value),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    confirmContext,
                                                  ).pop(false),
                                                  child: const Text(
                                                    AppStrings.cancelButton,
                                                  ),
                                                ),
                                                FilledButton(
                                                  onPressed: () => Navigator.of(
                                                    confirmContext,
                                                  ).pop(true),
                                                  child: const Text(
                                                    AppStrings.saveButton,
                                                  ),
                                                ),
                                              ],
                                            ),
                                      );
                                      if (confirmed != true ||
                                          !dialogContext.mounted) {
                                        return;
                                      }
                                      setDialogState(
                                        () => savingUserId = user.id,
                                      );
                                      try {
                                        final updated =
                                            await const UserDirectoryService()
                                                .updateUserRole(
                                                  userId: user.id,
                                                  role: value,
                                                );
                                        users[index] = updated;
                                        if (dialogContext.mounted) {
                                          ScaffoldMessenger.of(
                                            dialogContext,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                AppStrings.roleUpdatedSuccess(
                                                  updated.fullName,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      } catch (error) {
                                        if (dialogContext.mounted) {
                                          ScaffoldMessenger.of(
                                            dialogContext,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                FriendlyErrorMapper.message(
                                                  error,
                                                ),
                                              ),
                                              backgroundColor: Theme.of(
                                                dialogContext,
                                              ).colorScheme.error,
                                            ),
                                          );
                                        }
                                      } finally {
                                        if (dialogContext.mounted) {
                                          setDialogState(
                                            () => savingUserId = '',
                                          );
                                        }
                                      }
                                    },
                            ),
                          ),
                        );
                      },
                    ),
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text(AppStrings.doneButton),
              ),
            ],
          );
        },
      ),
    );
  }
}
