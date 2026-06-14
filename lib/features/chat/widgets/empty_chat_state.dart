import '../../../shared.dart';

class EmptyChatState extends StatelessWidget {
  const EmptyChatState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const EmptyState(
          icon: Icons.chat_bubble_outline,
          message: AppStrings.noMessagesYet,
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: const [
            StatusPill(label: AppStrings.chatSuggestionSubmission),
            StatusPill(label: AppStrings.chatSuggestionGithub),
            StatusPill(label: AppStrings.chatSuggestionChecklist),
          ],
        ),
      ],
    );
  }
}
