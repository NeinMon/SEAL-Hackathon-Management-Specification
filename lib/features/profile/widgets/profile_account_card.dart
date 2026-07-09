import '../../../shared.dart';

class ProfileAccountCard extends StatelessWidget {
  const ProfileAccountCard({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.alternate_email),
              title: Text(context.l10n.emailLabel),
              subtitle: Text(user.email),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.verified_user_outlined),
              title: Text(context.l10n.roleLabel),
              subtitle: Text(AppRoles.label(user.role)),
            ),
          ],
        ),
      ),
    );
  }
}
