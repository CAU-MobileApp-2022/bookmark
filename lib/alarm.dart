import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:flutter_app/sidebar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

final alarmInfoList = [
/*  AlarmInfo( "test alarm 1", 12, 30, true),
  AlarmInfo( "test alarm 2", 12, 30, false),*/
];


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


class _AlarmPageState extends State<AlarmPage> {

  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
      }
    } catch (e) {}
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('알람'),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/alarmSetting', arguments: {});
                    },
                  child: Text('알람 +'),
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('alarms').orderBy('timestamp').snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data!.docs.where((element) => element.get('uid') == _authentication.currentUser!.uid).toList();
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: docs.length,
                itemBuilder: (context,index){
                  return AlarmElement(
                    name : docs[index]['name'],
                    hour : docs[index]['hour'],
                    minute : docs[index]['minute'],
                    isActive : docs[index]['isActive'],
                    docId: docs[index].id,
                  );
                },
              );
            }
          )
        ],
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

class AlarmSettingPage extends StatefulWidget {
  const AlarmSettingPage({Key? key}) : super(key: key);

  @override
  State<AlarmSettingPage> createState() => _AlarmSettingPageState();
}

class _AlarmSettingPageState extends State<AlarmSettingPage> {
  DateTime? _dateTime;
  final _alarmMemoController = TextEditingController();


  Future _navigateAndDisplaySelection(BuildContext context, String name) async {
    return await Navigator.pushNamed(
        context, '/$name', arguments: {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알람 설정'),
        leading:  IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back)
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(30.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.black, width: 1)
              ),
              child: TimePickerSpinner(
                is24HourMode: true,
                minutesInterval: 1,
                normalTextStyle: TextStyle(
                  fontSize: 24,
                ),
                highlightedTextStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
                spacing: 100,
                itemHeight: 80,
                isForce2Digits: false,
                onTimeChange: (time) {
                  setState(() {
                    _dateTime = time;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: '알람 이름',
                  border: OutlineInputBorder()
                ),
                controller: _alarmMemoController,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                //alarmInfoList.add(new AlarmInfo(_alarmMemoController.text, _dateTime!.hour, _dateTime!.minute, false));
                final currentUser = FirebaseAuth.instance.currentUser;
                    final currentUserName = await FirebaseFirestore.instance
                        .collection('user')
                        .doc(currentUser!.uid)
                        .get();
                    FirebaseFirestore.instance.collection("alarms").add({
                      'userName': currentUserName.data()!['userName'],
                      'uid': currentUser.uid,
                      'timestamp' : Timestamp.fromDate(_dateTime!),
                      'name': _alarmMemoController.text,
                      'isActive' : false,
                      'hour' : _dateTime!.hour,
                      'minute' : _dateTime!.minute,
                    });
                final result = await _navigateAndDisplaySelection(context, 'alarm');
              },
              child: Text('저장하기')
            ),
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
    );
  }
}

class AlarmElement extends StatelessWidget {
  final String? docId;
  final String? name;
  final int? hour;
  final int? minute;
  bool? isActive;
  final id = 0;

  AlarmElement({
    Key? key,
    this.docId,
    this.name,
    this.hour,
    this.minute,
    this.isActive,
  }) : super(key: key){

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: isActive!
                  ? Icon(Icons.alarm, color: Colors.deepOrange)
                  : Icon(Icons.alarm_off),
              onPressed: () {
                isActive = isActive == true ? false : true;
                if (isActive!){
                  setAlarm(true);
                }
                else {
                  setAlarm(false);
                }
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(name!),
                Text(
                  '${hour.toString()} : ${minute.toString()} : ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (value) {
              },
              itemBuilder: (BuildContext bc) {
                return [
                  PopupMenuItem(
                    child: Text("Delete"),
                    onTap: (){
                      dismissAlarm();
                    },
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> alarmCallback() async{
    print('test');
  }

  void setAlarm(bool active) {
    FirebaseFirestore.instance.collection("alarms").doc(docId!).update({
      'isActive': active,
    }
    );
    DateTime now = DateTime.now();
    DateTime targetTime = DateTime(now.year, now.month,now.day, hour!, minute!);
    //DateTime targetTime = now.add(Duration(seconds: 1));
    AndroidAlarmManager.oneShotAt(
      targetTime,
      id,
      alarmCallback,
      alarmClock: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  void dismissAlarm() {
    FirebaseFirestore.instance.collection("alarms").doc(docId!.toString()).delete();
    print("Alarm dismissed: $name");
    AndroidAlarmManager.cancel(id);
  }
}

