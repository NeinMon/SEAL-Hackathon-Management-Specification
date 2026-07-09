import '../../../shared.dart';
import '../widgets/chat_screen_body.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final scrollController = ScrollController();
  String? composerError;

  @override
  void initState() {
    super.initState();
    controller.addListener(_refreshComposer);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadContacts());
  }

  Future<void> _loadContacts() async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    var eventId = RouteQuery.eventIdFrom(context);
    eventId ??= context.read<ActiveEventProvider>().selectedEventId;
    final chat = context.read<ChatProvider>();
    await chat.loadContacts(user, eventId: eventId);
    if (!mounted) return;
    final contact = chat.selectedContact;
    if (contact != null) {
      chat.watchConversation(user.id, contact.id);
    }
  }

  @override
  void dispose() {
    controller
      ..removeListener(_refreshComposer)
      ..dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _refreshComposer() {
    if (!mounted) return;
    final validationError = AppValidators.chatMessage(controller.text);
    setState(() {
      if (controller.text.trim().isEmpty) {
        composerError = null;
      } else if (validationError != null) {
        composerError = validationError;
      } else {
        composerError = null;
      }
    });
  }

  Future<void> _sendMessage() async {
    final user = context.read<AuthProvider>().user;
    final chat = context.read<ChatProvider>();
    final validationError = AppValidators.chatMessage(controller.text);
    if (validationError != null) {
      setState(() => composerError = validationError);
      return;
    }
    if (user == null || chat.selectedContact == null) {
      setState(
        () => composerError = L10nService.strings.selectConversationBeforeSend,
      );
      return;
    }
    setState(() => composerError = null);
    await chat.send(
      user.fullName,
      controller.text,
      senderId: user.id,
      receiverId: chat.selectedContact!.id,
    );
    controller.clear();
    _scrollToLatest();
  }

  void _onContactSelected(AppUser contact) {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    final chat = context.read<ChatProvider>();
    chat.selectContact(contact);
    chat.watchConversation(user.id, contact.id);
  }

  void _refreshConversation() {
    final user = context.read<AuthProvider>().user;
    final chat = context.read<ChatProvider>();
    if (user == null || chat.selectedContact == null) return;
    chat.watchConversation(user.id, chat.selectedContact!.id);
  }

  void _scrollToLatest() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final user = context.watch<AuthProvider>().user;
    final eventId = RouteQuery.eventIdFrom(context);
    final eventTitle = eventId == null
        ? null
        : context.watch<EventProvider>().byIdOrNull(eventId)?.title;
    final messages = [...chat.messages]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return RoleGate(
      allowedRoles: const {AppRoles.participant, AppRoles.mentor},
      message: L10nService.strings.chatRoleGateMessage,
      child: ChatScreenBody(
        chat: chat,
        user: user,
        eventTitle: eventTitle,
        messages: messages,
        controller: controller,
        scrollController: scrollController,
        composerError: composerError,
        onContactSelected: _onContactSelected,
        onRefreshConversation: _refreshConversation,
        onCopyMentorTemplate: () => ChatMentorRequestActions.copyTemplate(context),
        onSendMentorRequest: user == null
            ? () {}
            : () => ChatMentorRequestActions.sendRequest(context, user),
        onSendMessage: _sendMessage,
        onScrollToLatest: _scrollToLatest,
        onSuggestion: user == null || chat.selectedContact == null
            ? null
            : (text) => controller
              ..text = text
              ..selection = TextSelection.collapsed(offset: text.length),
      ),
    );
  }
}
