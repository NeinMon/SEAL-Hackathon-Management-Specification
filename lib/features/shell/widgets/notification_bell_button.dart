import '../../../shared.dart';

class NotificationBellButton extends StatefulWidget {
  const NotificationBellButton({
    super.key,
    required this.unreadCount,
    required this.highlight,
    required this.onPressed,
  });

  final int unreadCount;
  final bool highlight;
  final VoidCallback onPressed;

  @override
  State<NotificationBellButton> createState() => _NotificationBellButtonState();
}

class _NotificationBellButtonState extends State<NotificationBellButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _syncAnimation();
  }

  @override
  void didUpdateWidget(NotificationBellButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.highlight != widget.highlight) {
      _syncAnimation();
    }
  }

  void _syncAnimation() {
    if (widget.highlight) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseIconColor = Theme.of(context).colorScheme.onSurface;
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulse = widget.highlight ? _pulseController.value : 0.0;
        final iconColor = widget.highlight
            ? Color.lerp(
                baseIconColor,
                context.sealSecondary,
                0.35 + pulse * 0.65,
              )!
            : baseIconColor;
        final scale = 1.0 + (pulse * 0.14);
        return Transform.scale(
          scale: scale,
          child: Badge(
            isLabelVisible: widget.unreadCount > 0,
            label: Text('${widget.unreadCount}'),
            child: IconButton(
              tooltip: context.l10n.notificationsNavLabel,
              onPressed: widget.onPressed,
              icon: Icon(Icons.notifications_outlined, color: iconColor),
            ),
          ),
        );
      },
    );
  }
}
