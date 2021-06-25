import 'package:flutter/material.dart';
import 'package:flutter_fcm_01/model/message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingWidget extends StatefulWidget {
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  final List<Message> messages = [];
  @override
  void initState() {
    super.initState();
    firebaseMessagingHandler();
  }

  Future<void> firebaseMessagingHandler() async {
    FirebaseMessaging.instance.getToken().then((token) {
      print(token);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage event");
      RemoteNotification? notification = message.notification;
      setState(() {
        messages.add(Message(
          title: notification!.title!,
          body: notification.body!,
        ));
      });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp event');
      print(message.data);
      final data = message.data;
      print('length: ' + data.length.toString());
      if (data.length > 0) {
        print('message.data');
        setState(() {
          messages.add(Message(
            title: '${data['title']}',
            body: '${data['body']}',
          ));
        });
      } else {
        print('message.notification');
        RemoteNotification? notification = message.notification;
        setState(() {
          messages.add(Message(
            title: notification!.title!,
            body: notification.body!,
          ));
        });
      }
    });
    FirebaseMessaging.instance.requestPermission();
  }

  @override
  Widget build(BuildContext context) => ListView(
        children: messages.map(buildMessage).toList(),
      );

  Widget buildMessage(Message message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );
}
