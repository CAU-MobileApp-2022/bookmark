import 'package:flutter/material.dart';
import 'package:flutter_app/sidebar.dart';
import 'barcode.dart';

class LookUpPage extends StatefulWidget {
  const LookUpPage({Key? key}) : super(key: key);

  @override
  State<LookUpPage> createState() => _LookUpPageState();
}

class _LookUpPageState extends State<LookUpPage> {

  Future<BookLookupInfo> _navigateAndDisplaySelection(BuildContext context, String name) async {
    return await Navigator.pushNamed(
        context, '/$name', arguments: {}) as BookLookupInfo;
  }

  int _counter=0;
  List bookLookupInfoList = [
    BookLookupInfo( id: 1, title: "The Selfish Gene", author: "Richard Dawkins", url: "https://shopping-phinf.pstatic.net/main_3247666/32476662559.20220520101441.jpg",),
    BookLookupInfo( id: 2, title: "Design Patterns", author: "Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides", url: "https://shopping-phinf.pstatic.net/main_3244388/32443882215.20220518201208.jpg"),
  ];
  _onSelected(dynamic val) {
    setState(() => bookLookupInfoList.removeAt(val));
  }
  @override
  Widget build(BuildContext context) {
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
                /*
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Delete Book'),
                ),*/
                SizedBox(width: 20),
                ElevatedButton (
                  onPressed: () async {
                    BookLookupInfo result = await _navigateAndDisplaySelection(context, 'lookupSelection');
                    print(result.id);
                    print(result.author);
                    print(result.title);

                    if (result != null && result.id!=-1){
                      print(bookLookupInfoList.length);
                      setState((){
                        print("not null");
                        print(_counter);
                        _counter++;
                        print(_counter);
                        result.id = bookLookupInfoList.length+1;
                        bookLookupInfoList.add(result);
                      });
                      print(bookLookupInfoList.length);
                    }

                    },
                  child: Text('Add new Book'),
                ),
              ],
        ),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: bookLookupInfoList.length,
            itemBuilder: (context, index){
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.network(
                          bookLookupInfoList[index].url!,
                          width: 50,
                          fit: BoxFit.fill
                      ),
                  Container(
                    width: 250,
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${bookLookupInfoList[index].title} ${_counter}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: 300,
                            child:
                            Text(bookLookupInfoList[index].author!,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                              fontSize: 10,
                            ),
                            ),
                            )
                        ],
                      )
                  ),
                      PopupMenuButton(
                        onSelected: _onSelected,
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) {
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

  Future<BookLookupInfo> _navigateAndDisplaySelection(BuildContext context, String name) async {
    final result = await Navigator.pushNamed(
        context, '/$name', arguments: {}) as BookLookupInfo;
    print("goog");
    return result;
  }
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
              onPressed: () async {
                final result = await _navigateAndDisplaySelection(context, 'barcode');

                if (result != null && result.id!=-1) Navigator.pop(context, result);
              },
              child: Text('barcode')
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  final result = await _navigateAndDisplaySelection(context, 'search');

                  if (result != null && result.id!=-1) Navigator.pop(context, result);
                },
              child: Text('search')
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

class BookLookupInfo {
  int? id;
  String? title;
  String? author;
  String? url;

  BookLookupInfo ({
    this.id,
    this.title,
    this.author,
    this.url
  });
  BookLookupInfo.clone(BookLookupInfo classA) : this(
      id: classA.id, title:classA.title,
      author:classA.author, url:classA.url );

}