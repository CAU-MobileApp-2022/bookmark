import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/alarm.dart';
import 'package:flutter_app/best_seller.dart';
import 'package:flutter_app/bookmark.dart';

import 'package:flutter_app/lookup.dart';
import 'package:flutter_app/review.dart';
import 'package:flutter_app/sidebar.dart';
import 'package:flutter_app/barcode.dart';
import 'package:flutter_app/search.dart';
import 'package:provider/provider.dart';
import 'LoginPage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AndroidAlarmManager.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        fontFamily: 'Jua-Regular',
        primarySwatch: Colors.amber,
      ),
      routes: {
        '/home': (context) => const MyHomePage(),
        '/lookup': (context) => const LookUpPage(),
        '/lookupSelection': (context) => const LookupSelectionPage(),
        '/bookmark': (context) => const BookmarkPage(),
        '/bookmarkDetail': (context) => const BookmarkDetailPage(),
        '/alarm': (context) => const AlarmPage(),
        '/alarmSetting': (context) => const AlarmSettingPage(),
        '/review': (context) => const ReviewPage(),
        '/book-reviewDetail': (context) => const BookReviewDetailPage(),
        '/bestseller': (context) => const BestSellerPage(),
        '/barcode': (context) => const BarcodePage(),
        '/search': (context) => const SearchPage(),
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return const MyHomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
      //home: const MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/cover.jpg')
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('북마크 앱'),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.logout)
            ),
          ],
        ),
        body: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
            ],
          ),
        ),
        drawer: Drawer(
          child:SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const <Widget>[
                DrawerMenuItems(),
              ],
            ),
          )
        ),
      ),
    );
  }
}