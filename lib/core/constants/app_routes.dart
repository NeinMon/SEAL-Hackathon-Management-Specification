class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String events = '/events';
  static const String teams = '/teams';
  static const String submit = '/submit';
  static const String judge = '/judge';
  static const String notifications = '/notifications';
  static const String chat = '/chat';
  static const String map = '/map';
  static const String profile = '/profile';
  static const String organizer = '/organizer';

  static String eventOverview(String eventId) => '/events/$eventId/overview';
  static String eventTeam(String eventId) => '/events/$eventId/team';
  static String eventSubmit(String eventId) => '/events/$eventId/submit';
  static String eventChat(String eventId) => '/events/$eventId/chat';
  static String eventMap(String eventId) => '/events/$eventId/map';
  static String eventJudge(String eventId) => '/events/$eventId/judge';
}
