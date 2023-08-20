import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

void main() {
  runApp(const MyApp());

  // Initialize the FlutterLocalNotificationsPlugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Set up the initialization settings
  const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );

  // Initialize the plugin with the initialization settings
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final channel = WebSocketChannel.connect(
  //   Uri.parse('ws://95.164.44.6:831'),
  // );
  // final channel = IOWebSocketChannel.connect(
  //   'ws://95.164.44.6:831',
  // );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(1),
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  IO.Socket socket = IO
      .io('ws://hci.ezas.org:831',
          OptionBuilder().setTransports(['websocket']).build())
      .connect()
    ..onError((data) => print(data));

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();

    socket.onConnect((_) {
      print('connect');
    });
    socket.on('message', (data) {
      print(data);
      String mdata = data;
      try {
        if (mdata[0] == "0") {
          showNotification();
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MyHomePage(int.parse(mdata[1]))));
        }
      } catch (e) {}
    });

    socket.onDisconnect((_) => print('disconnect'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id', // Change this value for your app
      'channel_name', // Change this value for your app
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await FlutterLocalNotificationsPlugin().show(
      0, // Notification ID
      'Message from Anika', // Notification title
      """Anika: Hey, it's urgent!\nPlease get back to me ASAP.\n We need to discuss something important.\nThanks!""", // Notification body
      platformChannelSpecifics,
      payload: 'payload',
    );
  }
}

//00 01 11 10  0X:old 1X:new X0:facebook X1:whatsapp
class MyHomePage extends StatefulWidget {
  const MyHomePage(this.source, {super.key});
  final int source;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    FlutterRingtonePlayer.playRingtone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.65))),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  widget.source == 0
                      ? "assets/facebook_logo.png"
                      : "assets/whatsapp-logo.png",
                  height: 60,
                  width: 60,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  """Anika: Hey, it's urgent!\nPlease get back to me ASAP.\n We need to discuss something important.\nThanks!""",
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.8,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // channel.sink.add("Test");
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.green[700], // <-- Button color
                  ),
                  child: const Icon(
                    Icons.call,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ),
                      child: const Icon(
                        Icons.message_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Colors.blue[600], // <-- Button color
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        FlutterRingtonePlayer.stop();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ),
                      child: const Icon(
                        Icons.alarm,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              )),
              const Text(
                "Snooze",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.add_circle_outline_outlined,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "5 Minutes",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.remove_circle_outline_outlined,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 64,
              )
            ],
          ),
        )
      ],
    ));
  }
}
