import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:san/UI/homescreen.dart';
import 'package:san/UI/login.dart';
import 'package:san/splash.dart';
import 'homepage.dart';
import 'sosmessage.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification);
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String? payload = notificationAppLaunchDetails!.payload;

  bool hasPermissions = await FlutterBackground.hasPermissions;
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "Sanchari",
    notificationText: "Sanchari is running in the background",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(
        name: 'background_icon',
        defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );
  bool success =
      await FlutterBackground.initialize(androidConfig: androidConfig);
  bool running = await FlutterBackground.enableBackgroundExecution();

  print("+++++++++++++++ $success");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sanchari',
          navigatorKey: navigatorKey,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MYHomePage(),
        ),
      );
}

class MYHomePage extends StatefulWidget {
  const MYHomePage({Key? key}) : super(key: key);

  @override
  _MYHomePageState createState() => _MYHomePageState();
}

class _MYHomePageState extends State<MYHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("error"),
                );
              } else if (snapshot.hasData) {
                check();
                return Ss();
              } else {
                return Signup();
              }
            }),
      );
}

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
    FirebaseFirestore.instance
        .collection('USERS')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .collection('FRIENDS')
        .doc('NO_OF_FRIENDS')
        .set({'no': 0});
    FirebaseFirestore.instance
        .collection('USERS')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .set({
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'email': FirebaseAuth.instance.currentUser!.email,
      'location': "null",
      'timestamp_of_reg': DateTime.now().toString(),
      'timestamp_of_loc': 'null',
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'completedReg': 'false',
      'address': 'null',
      'phone_no': 'null',
      'sos': "false",
    });
  }

  Future loggedout() async {
    try {
      await googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}

void check() {
  CollectionReference reference = FirebaseFirestore.instance
      .collection('USERS')
      .doc('${FirebaseAuth.instance.currentUser!.uid}')
      .collection('SOS');
  reference.snapshots().listen((querySnapshot) {
    querySnapshot.docChanges.forEach((change) async {
      String name = change.doc['name'];
      String location = change.doc['approx_loc'];

      print("HIIIIIIIIIIIIIIIIIIIIIIIIIIII");
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          '1', 'Basic ', 'Test',
          icon: "@mipmap/ic_launcher",
          importance: Importance.low,
          styleInformation: BigTextStyleInformation(
              '$name is in danger at $location!',
              htmlFormatBigText: true,
              contentTitle: 'SOS',
              htmlFormatContent: true,
              summaryText: 'Emergency!',
              htmlFormatSummaryText: true));

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          1, 'plain title', 'plain body', platformChannelSpecifics,
          payload: 'item x');
    });
  });
}

Future<dynamic> onSelectNotification(payload) async {
  Navigator.push(
    MyApp().navigatorKey.currentState!.context,
    MaterialPageRoute(
      builder: (context) => SosMessage(),
    ),
  );
}
