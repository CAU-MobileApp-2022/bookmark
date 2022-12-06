import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/sidebar.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  void getCurrentUser(){
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
      }
    } catch (e){
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('북마크'),
      ),
      body: ListView(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('books').orderBy('timestamp').snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data!.docs.where((element) => element.get('uid') == _authentication.currentUser!.uid).toList();
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true ,
                itemCount: docs.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: () {
                      final bookmark = Bookmark(title: docs[index]['title'], author: docs[index]['author'],memo: docs[index]['bookmark']);
                      Navigator.pushNamed(context, '/bookmarkDetail', arguments: bookmark);
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 300,
                                  child: Text(
                                    '${docs[index]['title']}',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.fade,
                                    ),
                                    maxLines:1,
                                    softWrap: false,
                                  ),
                                ),
                                Container(
                                  width: 300,
                                  child: Text(docs[index]['author']!,
                                    maxLines:1,
                                    softWrap: false,
                                  ),
                                ),
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
                    ),
                  );
                },
              );
            }
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


class BookmarkDetailPage extends StatelessWidget {
  const BookmarkDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Bookmark;

    return Scaffold(
      appBar: AppBar(
        title: Text('북마크 [ ${args.title} ]'),
        leading:  IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back)
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/note_background_1.jpg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 58, width: 100,),
                    Text('${args.title}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 38, width: 100,),
                    Container(
                      constraints: BoxConstraints(maxWidth: 500),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20.0,8,20,8),
                        child: Text('${args.memo}',
                          style: TextStyle(
                            height: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 50, 50),
        child: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, '/bookmarkEdit', arguments: args);
          },
          child: Text('edit'),
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


class BookmarkEditPage extends StatelessWidget {
  const BookmarkEditPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Bookmark;

    return Scaffold(
      appBar: AppBar(
        title: Text('북마크 [ ${args.title} ]'),
        leading:  IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back)
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/note_background_1.jpg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 58, width: 100,),
                    Text('${args.title}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 38, width: 100,),
                    Container(
                      constraints: BoxConstraints(maxWidth: 500),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20.0,8,20,8),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          initialValue:'${args.memo}',
                          maxLines: 8,
                          style: TextStyle(
                            height: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 50, 50),
        child: FloatingActionButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          child: Text('save'),
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


class Bookmark {
  int? id;
  String? title;
  String? author;
  String? memo;

  Bookmark (
    {
    this.id,
    required this.title,
    required this.author,
    required this.memo,}
  );
}