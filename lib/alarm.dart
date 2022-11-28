import 'package:flutter/material.dart';
import 'package:flutter_app/sidebar.dart';

import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}


class _AlarmPageState extends State<AlarmPage> {

  final alarmInfoList = [
    AlarmInfo( "test alarm 1", 12, 30, true),
    AlarmInfo( "test alarm 2", 12, 30, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm'),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Delete Alarm'),
                ),*/
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/alarmSetting', arguments: {});
                    },
                  child: Text('Add new Alarm'),
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
                           // your logic
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Alarm'),
        leading:  IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back)
        ),
      ),
      body: Column(
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
              minutesInterval: 5,
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
                labelText: 'Alarm memo',
                border: OutlineInputBorder()
              ),
              controller: _alarmMemoController,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: (){

            },
            child: Text('Enter')
          ),
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


class AlarmInfo {
  String name;
  int hour;
  int minute;
  bool isActive;

  AlarmInfo (
    this.name,
    this.hour,
    this.minute,
    this.isActive
  );
}