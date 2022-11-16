import 'package:flutter/material.dart';
import 'package:flutter_app/sidebar.dart';

class LookUpPage extends StatefulWidget {
  const LookUpPage({Key? key}) : super(key: key);

  @override
  State<LookUpPage> createState() => _LookUpPageState();
}

class _LookUpPageState extends State<LookUpPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lookup'),
      ),
      body: Container(
        child: const Text('Lookup'),
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
    );
  }
}
