import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/io.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final channel = IOWebSocketChannel.connect('ws://echo.websocket.org');
    final controller = TextEditingController();
    final List<String> messages = [];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('AppBar'),
        ),
        body: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              messages.add(snapshot.data as String);
            }

            return ListView.separated(
              itemCount: messages.length + 1,
              itemBuilder: (context, index) {
                print(
                  '****** index=$index, messages.length=${messages.length}, ${index == messages.length + 1}',
                );
                if (index == messages.length)
                  return Row(
                    children: <Widget>[
                      Expanded(child: TextField(controller: controller)),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          channel.sink.add(controller.text);
                        },
                      )
                    ],
                  );

                // TODO send the notification

                return Text(messages[index]);
              },
              separatorBuilder: (ctx, index) {
                return Divider();
              },
            );
          },
        ),
      ),
    );
  }
}
