import 'package:flutter/material.dart';
import 'package:flutter_app/alarm.dart';
import 'package:flutter_app/best_seller.dart';
import 'package:flutter_app/bookmark.dart';
import 'package:flutter_app/lookup.dart';
import 'package:flutter_app/review.dart';
import 'package:flutter_app/sidebar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/lookup': (context) => const LookUpPage(),
        '/lookupSelection': (context) => const LookupSelectionPage(),
        '/bookmark': (context) => const BookmarkPage(),
        '/alarm': (context) => const AlarmPage(),
        '/review': (context) => const ReviewPage(),
        '/bestseller': (context) => const BestSellerPage(),
      },
      // home: const MyHomePage(),
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
          title: const Text('Bookmark App'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: (){},
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