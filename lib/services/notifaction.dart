import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:pusher_websocket_flutter/pusher.dart';

class Show {
  Show._();

  static Show show = Show._();
  Channel channel;

  initPusher() async {
    try {
      Pusher.init('48382bce59b893f1efa5', PusherOptions(cluster: 'mt1'));
    } on Exception catch (e) {
      print(e);
    }
    Pusher.connect(onConnectionStateChange: (val) {
      print(val.currentState);
    }, onError: (err) {
      print(err);
    });

    channel = await Pusher.subscribe("send-notification");
    channel.bind("send-notification", (onEvent) async {
      var data = json.decode(onEvent.data);
      var massage = data['message'];

      await AwesomeNotifications().createNotification(
        content: NotificationContent(id: 8, channelKey: "key2", body: massage),
        schedule: NotificationInterval(
          interval: 2,
          repeats: false,
        ),
      );
    });
  }
}
