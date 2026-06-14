import '../../../shared.dart';

class ChatComposer extends StatelessWidget {
  const ChatComposer({
    super.key,
    required this.controller,
    required this.error,
    required this.isSending,
    required this.canSend,
    required this.onSend,
  });

  final TextEditingController controller;
  final String? error;
  final bool isSending;
  final bool canSend;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingCompact,
        AppSizes.paddingSmall,
        AppSizes.paddingCompact,
        AppSizes.paddingCompact,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingSmall),
        decoration: BoxDecoration(
          color: SealPalette.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: SealPalette.outlineVariant),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 3,
                maxLength: AppValidators.maxChatMessageLength,
                decoration: InputDecoration(
                  hintText: AppStrings.chatInputHint,
                  prefixIcon: const Icon(Icons.chat_bubble_outline),
                  errorText: error,
                  counterText: '',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.paddingSmall),
            IconButton.filled(
              tooltip: AppStrings.sendMessageTooltip,
              onPressed: !canSend || isSending ? null : onSend,
              icon: isSending
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
