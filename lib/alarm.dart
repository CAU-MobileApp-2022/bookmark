import 'package:flutter/material.dart';
import 'package:flutter_app/sidebar.dart';

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
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Delete Alarm'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/lookupSelection', arguments: {});
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
                      IconButton(
                        icon: alarmInfoList[index].isActive
                            ? Icon(Icons.alarm, color: Colors.deepOrange)
                            : Icon(Icons.alarm_off),
                        onPressed: () {
                          setState(() {
                            alarmInfoList[index].isActive = !alarmInfoList[index].isActive;
                          });
                        },
                      )
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