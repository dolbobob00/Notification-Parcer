import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_handler/src/configuration/dependency_inj/service_locator.dart';
import 'package:notification_handler/src/configuration/router/router.dart';
import 'package:notification_handler/src/domain/notification_listener/bloc/notf_handler_bloc.dart';
import 'package:notification_handler/src/presentation/widgets/notf_widget.dart';
import 'package:notification_handler/src/repository/db.dart';
import 'package:talker_flutter/talker_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = getIt.get<NotfHandlerBloc>();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return BottomSheet(
                showDragHandle: true,
                onClosing: () {},
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('     Service started: '),
                            FutureBuilder(
                              future: bloc.notificationsListener.isStarted(),
                              builder: (context, asyncSnapshot) {
                                return Switch.adaptive(
                                  value: asyncSnapshot.data ?? false,
                                  onChanged: (value) {
                                    bloc.add(
                                      NotfChangeStarted(shouldStart: value),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        ListTile(
                          title: Text('Update history of notification\'s'),
                          onTap: () => bloc.add(NotfLoadHistory()),
                        ),
                        ListTile(
                          title: Text('Fully erase history of notification\'s'),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Are you sure?',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            routerKey.currentState?.pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            bloc.add(NotfClearHistory());
                                            routerKey.currentState?.pop();
                                          },
                                          child: Text('Confirm'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text("Log's screen"),
                          onTap: () => routerKey.currentState?.push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  TalkerScreen(talker: getIt.get<Talker>()),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Close bottom sheet'),
                          onTap: () => routerKey.currentState?.pop(),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
        label: const Text('Menu'),
        icon: const Icon(Icons.notifications_active),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.document_scanner),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => TalkerScreen(talker: getIt.get<Talker>()),
              ),
            ),
          ),
        ],
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
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
