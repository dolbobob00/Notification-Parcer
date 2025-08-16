import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_handler/src/configuration/dependency_inj/service_locator.dart';
import 'package:notification_handler/src/domain/notification_listener/bloc/notf_handler_bloc.dart';
import 'package:notification_handler/src/presentation/widgets/bottom_sheet.dart';
import 'package:notification_handler/src/presentation/widgets/notf_widget.dart';
import 'package:talker_flutter/talker_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = getIt.get<NotfHandlerBloc>();
    final talker = getIt.get<Talker>();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return MyBottomSheet(bloc: bloc, talker: talker);
            },
          );
        },
        label: const Text('Menu'),
        icon: const Icon(Icons.notifications_active),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () {
          Completer completer = Completer();
          bloc.add(NotfLoadHistory(completer: completer));
          return completer.future;
        },
        child: BlocBuilder<NotfHandlerBloc, NotfHandlerState>(
          builder: (context, state) {
            if (state is NotfLoaded) {
              final notifications = state.notifications;
        
              if (notifications.isEmpty) {
                return const Center(child: Text('Waiting for notifications'));
              }
        
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return NotificationWidget(
                    notification: item,
                    key: ValueKey(notifications[index].key),
                  );
                },
              );
              
            } else if (state is NotfError) {
              return Center(child: Text(state.error));
            } else if (state is NotfLoading) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [CircularProgressIndicator(), Text('Loading...')],
                ),
              );
            }
            return const Center(
              child: Text(
                'Unexcepted error. \n Retry or check your wifi-connection or permissions.',
              ),
            );
          },
        ),
      ),
    );
  }
}
