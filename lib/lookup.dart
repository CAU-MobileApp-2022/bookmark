import 'package:flutter/material.dart';
import 'package:flutter_app/sidebar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'barcode.dart';

class LookUpPage extends StatefulWidget {
  const LookUpPage({Key? key}) : super(key: key);

  @override
  State<LookUpPage> createState() => _LookUpPageState();
}

class _LookUpPageState extends State<LookUpPage> {
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


  Future<BookLookupInfo> _navigateAndDisplaySelection(BuildContext context, String name) async {
    return await Navigator.pushNamed(
        context, '/$name', arguments: {}) as BookLookupInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('책 목록'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                ElevatedButton (
                  onPressed: () async {
                    BookLookupInfo result = await _navigateAndDisplaySelection(context, 'lookupSelection');
                    print(result.id);
                    print(result.author);
                    print(result.title);

                    final currentUser = FirebaseAuth.instance.currentUser;
                    final currentUserName = await FirebaseFirestore.instance
                        .collection('user')
                        .doc(currentUser!.uid)
                        .get();
                    FirebaseFirestore.instance.collection("books").add({
                      'userName': currentUserName.data()!['userName'],
                      'timestamp': Timestamp.now(),
                      'uid': currentUser.uid,
                      'title': result.title,
                      'author': result.author,
                      'isbn': result.id,
                      'imageUrl': result.url,
                      'bookmark': "",
                      'review': "",
                    });
                    },
                  child: Text('등록하기'),
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
                              child: Text("삭제하기"),
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
          )),
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

class BookElement extends StatelessWidget {
  const BookElement({Key? key, this.isMe, this.userName, this.title,
    this.author, this.imageUrl, this.bookmark, this.review, this.docId})
      : super(key: key);
  final String? isMe;
  final String? userName;
  final String? title;
  final String? author;
  final String? imageUrl;
  final String? bookmark;
  final String? review;
  final String? docId;

  _onSelected(dynamic val) {
    FirebaseFirestore.instance.collection("books").doc(isMe).collection(isMe!).doc(docId!).delete();
  }
  @override
  Widget build(BuildContext context) {
    print(isMe);
    print(userName);
    print(title);
    print(author);
    print(imageUrl);
    print(bookmark);
    print(review);
    print(docId);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.network(
                imageUrl!,
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
                      title!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 300,
                      child:
                      Text(author!,
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
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: docId,
                    child: const Text("Delete"),
                  ),
                ];
              },
            ),
          ],
        ),
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