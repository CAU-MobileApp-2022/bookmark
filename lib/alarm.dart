import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:flutter_app/sidebar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

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
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: alarmInfoList.length,
            itemBuilder: (context,index){
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: alarmInfoList[index].isActive
                            ? Icon(Icons.alarm, color: Colors.deepOrange)
                            : Icon(Icons.alarm_off),
                        onPressed: () {
                          setState(() {
                            alarmInfoList[index].isActive = !alarmInfoList[index].isActive;
                            if (alarmInfoList[index].isActive){
                              alarmInfoList[index].activateAlarm();
                            }
                            else {
                              alarmInfoList[index].dismissAlarm();
                            }
                          });
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(alarmInfoList[index].name),
                          Text(
                            '${alarmInfoList[index].hour.toString()}:${alarmInfoList[index].minute.toString()}',
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
                           setState((){
                             alarmInfoList[value].dismissAlarm();
                             alarmInfoList.removeAt(value);
                           });
                        },
                        itemBuilder: (BuildContext bc) {
                          return [
                            PopupMenuItem(
                              child: Text("Delete"),
                              value: index,
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
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


  Future<AlarmInfo> _navigateAndDisplaySelection(BuildContext context, String name) async {
    return await Navigator.pushNamed(
        context, '/$name', arguments: {}) as AlarmInfo;
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
                alarmInfoList.add(new AlarmInfo(_alarmMemoController.text, _dateTime!.hour, _dateTime!.minute, false));
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

class AlarmInfo {
  static int global_alarm_id = 0;
  int id = 0;
  String name;
  int hour;
  int minute;
  bool isActive;

  AlarmInfo (
    this.name,
    this.hour,
    this.minute,
    this.isActive,
  ){
    id  = AlarmInfo.global_alarm_id;
    AlarmInfo.global_alarm_id += 1;
  }

  static Future<void> alarmCallback() async{
    print('test');
  }

  void activateAlarm() {
    print("Alarm set: $name $id");
    DateTime now = DateTime.now();
    //DateTime targetTime = DateTime(now.year, now.month,now.day, hour, minute);
    DateTime targetTime = now.add(Duration(seconds: 1));
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
    print("Alarm dismissed: $name");
    AndroidAlarmManager.cancel(id);
  }
}