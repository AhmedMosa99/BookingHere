import 'dart:convert';
import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:pusher_client/pusher_client.dart';
// import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: use_key_in_widget_constructors
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PusherClient pusher;
  Channel channel;
  int curentIndex = 0;
  List<Widget> widgets = [Home(), Flights(), Hotels(), Cars()];
  initPusher() {
    pusher = PusherClient(
      "48382bce59b893f1efa5",
      PusherOptions(
        cluster: 'mt1',
        encrypted: false,
      ),
      enableLogging: true,
    );
    channel = pusher.subscribe("name_channel");
    pusher.onConnectionStateChange((state) async {
      log("previousState: ${state.previousState}, currentState: ${state.currentState}");
    });
    channel.bind('name_event', (event) async {
      dynamic data = json.decode(event.data);
      String message = data['message'];
      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          print("e");
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      });
      await AwesomeNotifications().createNotification(
        content: NotificationContent(id: 8, channelKey: "key2", body: message),
        schedule: NotificationInterval(
          interval: 2,
          repeats: false,
        ),
      );
    });
  }

  @override
  void initState() {
    initPusher();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widgets[curentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: curentIndex,
          onTap: (index) {
            curentIndex = index;
            setState(() {});
          }, //
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blue.shade800,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(.60),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            const BottomNavigationBarItem(
              label: 'Flights',
              icon: Icon(Icons.flight),
            ),
            const BottomNavigationBarItem(
              label: 'Hotels',
              icon: Icon(Icons.hotel_rounded),
            ),
            const BottomNavigationBarItem(
              label: 'Cars',
              icon: Icon(Icons.car_repair),
            ),
          ],
        ));
  }
}

// ignore: use_key_in_widget_constructors
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: 'https://bookingshere.com/',
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class Flights extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: 'https://bookingshere.com/flights/',
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class Hotels extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: 'https://bookingshere.com/hotels/',
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class Cars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: 'https://bookingshere.com/cars/',
      ),
    );
  }
}
