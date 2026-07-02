import '../../../shared.dart';

class MemberAvatarStack extends StatelessWidget {
  const MemberAvatarStack({super.key, required this.members});

  final List<AppUser> members;

  @override
  Widget build(BuildContext context) {
    final visible = members.take(3).toList();
    return SizedBox(
      width: 58,
      height: 42,
      child: Stack(
        children: [
          if (visible.isEmpty)
            const MemberAvatar(label: '?')
          else
            for (var index = 0; index < visible.length; index++)
              Positioned(
                left: index * 16,
                child: MemberAvatar(label: _initials(visible[index].fullName)),
              ),
        ],
      ),
    );
  }

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first.substring(0, 1);
    final last = parts.length > 1 && parts.last.isNotEmpty
        ? parts.last.substring(0, 1)
        : '';
    return (first + last).toUpperCase();
  }
}

class MemberAvatar extends StatelessWidget {
  const MemberAvatar({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 19,
      backgroundColor: SealPalette.primaryContainer,
      foregroundColor: Colors.white,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
    );
  }
}
