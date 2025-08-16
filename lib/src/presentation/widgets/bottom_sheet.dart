import 'package:flutter/material.dart';
import 'package:notification_handler/src/configuration/router/router.dart';
import 'package:notification_handler/src/domain/notification_listener/bloc/notf_handler_bloc.dart';
import 'package:notification_handler/src/presentation/widgets/confirmation_dialogue.dart';
import 'package:notification_handler/src/presentation/widgets/my_list_tile.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MyBottomSheet extends StatelessWidget {
  const MyBottomSheet({super.key, required this.bloc, required this.talker});

  final NotfHandlerBloc bloc;
  final Talker talker;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      showDragHandle: true,
      onClosing: () {},
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Service started: '),
                  FutureBuilder(
                    future: bloc.notificationsListener.isStarted(),
                    builder: (context, asyncSnapshot) {
                      return Switch.adaptive(
                        value: asyncSnapshot.data ?? false,
                        onChanged: (value) {
                          try {
                            bloc.add(NotfChangeStarted(shouldStart: value));
                            routerKey.currentState?.pop();
                          } catch (e, st) {
                            talker.handle(e, st);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
              Divider(endIndent: 25, indent: 25,color: Colors.black,),
              MyListTile(
                title: Text('Update history of notification\'s'),
                onTap: () => bloc.add(NotfLoadHistory()),
              ),
              MyListTile(
                title: Text('Fully erase history of notification\'s'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ConfirmationDialogue(
                      message: Text('Are you sure you want to destroy all history?'),
                      cancelText: 'Cancel',
                      confirmText: 'Confirm',
                      onCancel: () => routerKey.currentState?.pop(),
                      onConfirm: () {
                        try {
                          bloc.add(NotfClearHistory());
                          routerKey.currentState?.pop();
                        } catch (e) {
                          talker.handle(e);
                        }
                      },
                      titleWidget: Text(
                        'Are you sure?',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  );
                },
              ),
              MyListTile(
                onTap: () => routerKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (context) => TalkerScreen(talker: talker),
                  ),
                ),
                title: Text("Log's screen"),
              ),
              MyListTile(
                onTap: () => routerKey.currentState?.pop(),
                title: Text('Close bottom sheet'),
              ),
            ],
          ),
        );
      },
    );
  }
}
