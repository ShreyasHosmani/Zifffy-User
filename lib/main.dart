import 'package:dabbawala/UI/home_page.dart';
import 'package:dabbawala/UI/splash_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UI/Widgets/bottom_nav_bar.dart';
import 'package:dabbawala/UI/data/home_data.dart' as home;

var storedUserId;
bool _serviceEnabled;
PermissionStatus _permissionGranted;

final FirebaseMessaging _messaging = FirebaseMessaging();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
final FirebaseMessaging _fcm = FirebaseMessaging();
var userToken;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  home.userIdResponse = prefs.getString('userId');
  storedUserId = home.userIdResponse.toString();
  print(storedUserId);

//    _serviceEnabled = await location.serviceEnabled();
//    if (!_serviceEnabled) {
//      _serviceEnabled = await location.requestService();
//      if (!_serviceEnabled) {
//        runApp(MaterialApp(
//            debugShowCheckedModeBanner: false,
//            home: storedUserId == null || storedUserId == "null" ? SplashPage() : BottomNavBar()));
//      }else{
//        runApp(MaterialApp(
//            debugShowCheckedModeBanner: false,
//            home: SplashPage()));
//      }
//    }else{
//      runApp(MaterialApp(
//          debugShowCheckedModeBanner: false,
//          home: SplashPage()));
//    }
//
//
//    _permissionGranted = await location.hasPermission();
//    if (_permissionGranted == PermissionStatus.denied) {
//      _permissionGranted = await location.requestPermission();
//      if (_permissionGranted != PermissionStatus.granted) {
//        runApp(MaterialApp(
//            debugShowCheckedModeBanner: false,
//            home: storedUserId == null || storedUserId == "null" ? SplashPage() : BottomNavBar()));
//      }else{
//        runApp(MaterialApp(
//            debugShowCheckedModeBanner: false,
//            home: SplashPage()));
//      }
//    }else{
//      runApp(MaterialApp(
//          debugShowCheckedModeBanner: false,
//          home: SplashPage()));
//    }

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: storedUserId == null || storedUserId == "null" ? SplashPage() : BottomNavBar()));
  initFCM();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashPage()
    );
  }
}

initFCM() async {

  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  var android = new AndroidInitializationSettings('app_icon');
  var iOS = new IOSInitializationSettings();

  var initSettings = new InitializationSettings(android, iOS);

  flutterLocalNotificationsPlugin.initialize(initSettings,
      onSelectNotification: onSelectNotification);

  userToken = await _messaging.getToken();
  print(userToken.toString());

  _fcm.configure(
    onMessage: (Map<String, dynamic> message) async {

      print("onMessage.....: $message");
      showOnMessageNotification(message);

    },
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
      showOnMessageNotification(message);
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
      showOnMessageNotification(message);
    },
  );
  _fcm.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        alert: true,
        badge: true,
      )
  );
  _fcm.onIosSettingsRegistered.listen((IosNotificationSettings setting){
    print("ios settings registered");
  });
}

showOnMessageNotification(var message) async {

  var android = new AndroidNotificationDetails(
      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.High,importance: Importance.Max
  );
  var iOS = new IOSNotificationDetails();
  var platform = new NotificationDetails(android, iOS);
  await flutterLocalNotificationsPlugin.show(
      1, message['notification']['title'].toString(), message['notification']['body'].toString(), platform,
      payload: '');

}

Future onSelectNotification(String payload) {

//  Navigator.push(
//    contextNew,
//    MaterialPageRoute(
//        builder: (context) => Notifications()),
//  );

}
