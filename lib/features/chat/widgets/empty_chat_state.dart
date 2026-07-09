import '../../../shared.dart';

class EmptyChatState extends StatelessWidget {
  const EmptyChatState({super.key, this.onSuggestion});

  final ValueChanged<String>? onSuggestion;

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      L10nService.strings.chatSuggestionSubmission,
      L10nService.strings.chatSuggestionGithub,
      L10nService.strings.chatSuggestionChecklist,
    ];
    return Column(
      children: [
        EmptyState(
          icon: Icons.chat_bubble_outline,
          message: L10nService.strings.noMessagesYet,
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final suggestion in suggestions)
              ActionChip(
                label: Text(suggestion),
                onPressed: onSuggestion == null
                    ? null
                    : () => onSuggestion!(suggestion),
              ),
          ],
        ),
      ],
    );
  }
}
