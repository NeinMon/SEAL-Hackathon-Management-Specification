typedef NotificationNavigate = void Function(String route);

class NotificationDeepLink {
  const NotificationDeepLink._();

  static NotificationNavigate? _navigate;

  static void bind(NotificationNavigate navigate) {
    _navigate = navigate;
  }

  static void unbind() {
    _navigate = null;
  }

  static void open(String? route) {
    if (route == null || route.isEmpty) return;
    _navigate?.call(route);
  }
}
