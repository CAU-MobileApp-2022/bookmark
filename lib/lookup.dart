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
    final bookLookupInfoList = [
      BookLookupInfo( 1, "The Selfish Gene", "Richard Dawkins"),
      BookLookupInfo( 2, "Design Patterns","Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides"),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lookup'),
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
                  child: Text('Delete Book'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/lookupSelection', arguments: {});
                    },
                  child: Text('Add new Book'),
                ),
              ],
        ),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true ,
            itemCount: bookLookupInfoList.length,
            itemBuilder: (context, index){
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${bookLookupInfoList[index].title}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(bookLookupInfoList[index].author),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {
                          setState(() {
                          });
                        },
                      )
                    ],
                  ),
                ),
              );
            },
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

class LookupSelectionPage extends StatelessWidget {
  const LookupSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lookup'),
        leading:  IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back)
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('barcode')
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('search')
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('ISBN')
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('e-book')
            ),
            SizedBox(height: 20),
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

class BookLookupInfo {
  int id;
  String title;
  String author;

  BookLookupInfo (
      this.id,
      this.title,
      this.author,
  );
}