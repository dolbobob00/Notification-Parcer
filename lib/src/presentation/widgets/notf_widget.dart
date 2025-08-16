import 'package:flutter/material.dart';
import 'package:notification_handler/src/configuration/dependency_inj/service_locator.dart';
import 'package:notification_handler/src/domain/entities/notification.dart';
import 'package:notification_handler/src/domain/icon_service/app_icon_sevice.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key, required this.notification});

  final NotificationEntity notification;

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  static final Map<String, ImageProvider?> _iconCache = {};
  ImageProvider? _icon;

  @override
  void initState() {
    super.initState();
    if (widget.notification.icon == null || widget.notification.icon!.isEmpty) {
      _loadIcon();
    } else {
      _icon = MemoryImage(widget.notification.icon!);
    }
  }

  Future<void> _loadIcon() async {
    final pkg = widget.notification.packageName ?? '';
    if (_iconCache.containsKey(pkg)) {
      setState(() => _icon = _iconCache[pkg]);
    } else {
      final icon = await getIt.get<AppIconService>().getAppIcon(pkg);
      _iconCache[pkg] = icon;
      if (mounted) setState(() => _icon = icon);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: _icon,
        child: _icon == null ? const Icon(Icons.notifications, size: 20) : null,
      ),
      title: Text(widget.notification.title ?? 'No title provided'),
      subtitle: Text(widget.notification.text ?? 'No text provided'),
      trailing: Text(
        widget.notification.createAt?.toString().substring(0, 16) ?? '',
        style: const TextStyle(fontSize: 8),
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.notification.packageName ?? 'No package name!',
            ),
          ),
        );
      },
    );
  }
}
