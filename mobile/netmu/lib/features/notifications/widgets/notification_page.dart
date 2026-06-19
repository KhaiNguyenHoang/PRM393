import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/notifications/models/notification_dto.dart';
import 'package:netmu/features/notifications/services/notification_service.dart';
import 'package:netmu/features/notifications/widgets/empty.dart';
import 'package:netmu/features/notifications/widgets/notification_tile.dart';
import 'package:netmu/l10n/app_localizations.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late final NotificationService _service;

  List<NotificationDto> _notifications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = NotificationService(
      onUnauthenticated: () => Navigator.pushNamedAndRemoveUntil(
        context, "/", (route) => false,
      ),
    );
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final (notifications, success) = await _service.getNotifications();

      if (!mounted) return;

      setState(() {
        if (!success) {
          _error = AppLocalizations.of(context)?.failedLoadNotifications ?? "Failed to load notifications";
        } else {
          _notifications = notifications;
        }
        _isLoading = false;
      });
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: ColorTheme.background,
      appBar: AppBar(
        backgroundColor: ColorTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ColorTheme.textPrimary),
        title: Text(
          l10n.notificationsTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: ColorTheme.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      final l10n = AppLocalizations.of(context)!;

      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loadNotifications,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return const EmptyState();
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: _notifications.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, index) =>
          NotificationTile(notification: _notifications[index]),
    );
  }
}
