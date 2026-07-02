class NotificationLink {
  const NotificationLink._();

  static final _eventPattern = RegExp(r'^\[\[event:([^\]]+)\]\]\s*');

  static String encodeEvent({
    required String eventId,
    required String content,
  }) {
    return '[[event:$eventId]] $content';
  }

  static String? eventId(String content) {
    final match = _eventPattern.firstMatch(content.trim());
    return match?.group(1);
  }

  static String displayContent(String content) {
    return content.trim().replaceFirst(_eventPattern, '').trim();
  }
}
