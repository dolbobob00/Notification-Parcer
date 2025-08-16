import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_handler/src/configuration/dependency_inj/service_locator.dart';
import 'package:notification_handler/src/configuration/router/router.dart';
import 'package:notification_handler/src/presentation/home_page/home_page.dart';
import 'domain/notification_listener/bloc/notf_handler_bloc.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<NotfHandlerBloc>()..add(NotfStart()),
      child: MaterialApp(
        navigatorKey: routerKey,
        initialRoute: '/',
        home: HomePage(),
      ),
    );
  }
}
