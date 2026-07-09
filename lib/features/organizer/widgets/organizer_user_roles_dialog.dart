import '../../../shared.dart';
import 'organizer_create_account_dialog.dart';

class OrganizerUserRolesDialog {
  const OrganizerUserRolesDialog._();

  static Future<void> show(
    BuildContext context, {
    List<AppUser>? initialUsers,
  }) async {
    final users =
        initialUsers ?? await const UserDirectoryService().fetchUsers();
    if (!context.mounted) return;
    final currentUserId = context.read<AuthProvider>().user?.id;
    final search = TextEditingController();
    var roleFilter = 'all';
    var savingUserId = '';
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final keyword = search.text.trim().toLowerCase();
          final visibleUsers = users.where((user) {
            final matchesRole = roleFilter == 'all' || user.role == roleFilter;
            final matchesSearch =
                keyword.isEmpty ||
                user.fullName.toLowerCase().contains(keyword) ||
                user.email.toLowerCase().contains(keyword);
            return matchesRole && matchesSearch;
          }).toList();
          return AlertDialog(
            title: Text(context.l10n.manageUserRolesTitle),
            content: SizedBox(
              width: 420,
              child: users.isEmpty
                  ? EmptyState(message: context.l10n.noUsersYet)
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: search,
                          decoration: InputDecoration(
                            labelText: L10nService.strings.userSearchLabel,
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: search.text.trim().isEmpty
                                ? null
                                : IconButton(
                                    tooltip: context.l10n.clearSearchAction,
                                    onPressed: () {
                                      search.clear();
                                      setDialogState(() {});
                                    },
                                    icon: Icon(Icons.close),
                                  ),
                          ),
                          onChanged: (_) => setDialogState(() {}),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          initialValue: roleFilter,
                          decoration: InputDecoration(
                            labelText: L10nService.strings.roleFilterLabel,
                            prefixIcon: Icon(Icons.filter_list_outlined),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'all',
                              child: Text(context.l10n.allFilter),
                            ),
                            DropdownMenuItem(
                              value: AppRoles.participant,
                              child: Text(context.l10n.roleParticipant),
                            ),
                            DropdownMenuItem(
                              value: AppRoles.judge,
                              child: Text(context.l10n.roleJudge),
                            ),
                            DropdownMenuItem(
                              value: AppRoles.mentor,
                              child: Text(context.l10n.roleMentor),
                            ),
                            DropdownMenuItem(
                              value: AppRoles.organizer,
                              child: Text(context.l10n.roleOrganizer),
                            ),
                          ],
                          onChanged: (value) =>
                              setDialogState(() => roleFilter = value ?? 'all'),
                        ),
                        const SizedBox(height: 10),
                        if (visibleUsers.isEmpty)
                          EmptyState(
                            message: L10nService.strings.noMatchingUsers,
                            actionLabel: L10nService.strings.clearSearchAction,
                            onAction: () {
                              search.clear();
                              setDialogState(() => roleFilter = 'all');
                            },
                          )
                        else
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: visibleUsers.length,
                              itemBuilder: (context, index) {
                                final user = visibleUsers[index];
                                final isSelf = user.id == currentUserId;
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(Icons.person_outline),
                                  title: Text(user.fullName),
                                  subtitle: Text(
                                    isSelf
                                        ? L10nService.strings.cannotChangeOwnRoleSubtitle(
                                            user.email,
                                          )
                                        : user.email,
                                  ),
                                  trailing: SizedBox(
                                    width: 148,
                                    child: DropdownButtonFormField<String>(
                                      key: ValueKey('${user.id}-${user.role}'),
                                      initialValue: user.role,
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 8,
                                        ),
                                      ),
                                      items: [
                                        DropdownMenuItem(
                                          value: AppRoles.participant,
                                          child: Text(
                                            L10nService.strings.roleParticipant,
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: AppRoles.judge,
                                          child: Text(context.l10n.roleJudge),
                                        ),
                                        DropdownMenuItem(
                                          value: AppRoles.mentor,
                                          child: Text(context.l10n.roleMentor),
                                        ),
                                        DropdownMenuItem(
                                          value: AppRoles.organizer,
                                          child: Text(context.l10n.roleOrganizer),
                                        ),
                                      ],
                                      onChanged:
                                          isSelf || savingUserId.isNotEmpty
                                          ? null
                                          : (value) async {
                                              if (value == null ||
                                                  value == user.role) {
                                                return;
                                              }
                                              final confirmed = await showDialog<bool>(
                                                context: dialogContext,
                                                builder: (confirmContext) =>
                                                    AlertDialog(
                                                      title: Text(
                                                        confirmContext.l10n.changeRoleDialogTitle,
                                                      ),
                                                      content: Text(
                                                        L10nService.strings.changeRoleDialogBody(
                                                          user.fullName,
                                                          AppRoles.label(value),
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                confirmContext,
                                                              ).pop(false),
                                                          child: Text(
                                                            confirmContext.l10n.cancelButton,
                                                          ),
                                                        ),
                                                        FilledButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                confirmContext,
                                                              ).pop(true),
                                                          child: Text(
                                                            confirmContext.l10n.saveButton,
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
                                                final userIndex = users
                                                    .indexWhere(
                                                      (item) =>
                                                          item.id == updated.id,
                                                    );
                                                if (userIndex != -1) {
                                                  users[userIndex] = updated;
                                                }
                                                if (dialogContext.mounted) {
                                                  ScaffoldMessenger.of(
                                                    dialogContext,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        L10nService.strings.roleUpdatedSuccess(
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
                      ],
                    ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () async {
                  final created = await OrganizerCreateAccountDialog.show(
                    dialogContext,
                  );
                  if (created == null || !dialogContext.mounted) return;
                  setDialogState(() => users.add(created));
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        L10nService.strings.staffAccountCreatedSuccess(created.fullName),
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.person_add_alt_outlined),
                label: Text(context.l10n.createStaffAccountButton),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(context.l10n.doneButton),
              ),
            ],
          );
        },
      ),
    );
    search.dispose();
  }
}
