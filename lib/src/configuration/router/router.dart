import 'package:flutter/material.dart';
import 'package:notification_handler/src/presentation/home_page/home_page.dart';

final GlobalKey<NavigatorState> routerKey = GlobalKey<NavigatorState>();

final routes = {'/': (_) => HomePage()};
