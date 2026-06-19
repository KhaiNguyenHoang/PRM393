import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/notifications/widgets/notification_badge.dart';
import 'package:netmu/features/notifications/widgets/notification_page.dart';
import 'package:netmu/l10n/app_localizations.dart';

class Appbar extends StatefulWidget implements PreferredSizeWidget {
  const Appbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  @override
  void initState() {
    super.initState();
    NotificationBadgeNotifier.instance.addListener(_onBadgeChanged);
  }

  @override
  void dispose() {
    NotificationBadgeNotifier.instance.removeListener(_onBadgeChanged);
    super.dispose();
  }

  void _onBadgeChanged() {
    setState(() {});
  }

  void _onNotificationTap() {
    NotificationBadgeNotifier.instance.reset();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasNew = NotificationBadgeNotifier.instance.hasNew;

    return AppBar(
      backgroundColor: ColorTheme.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text(
        AppLocalizations.of(context)!.appTitle,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: ColorTheme.textPrimary,
        ),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: _onNotificationTap,
              icon: Icon(
                hasNew
                    ? Icons.notifications_active_rounded
                    : Icons.notifications_outlined,
                color: hasNew ? ColorTheme.accent : ColorTheme.textPrimary,
                size: 26,
              ),
            ),
            if (hasNew)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: ColorTheme.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
