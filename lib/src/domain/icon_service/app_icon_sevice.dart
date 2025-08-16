import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class AppIconService {
  Future<ImageProvider?> getAppIcon(String? packageName) async {
    if (packageName == null) return null;
    // Get icon from app on device
    final app = await DeviceApps.getApp(packageName, true);
    if (app is ApplicationWithIcon) {
      final icon = MemoryImage(app.icon);
      return icon;
    }

    return null;
  }
}
