import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/sidebar.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
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
    /*final bookReviewList = [
      BookReview( id: 1, title: "The Selfish Gene", author: "Richard Dawkins",review: "리뷰",rating: 1.5),
      BookReview( id: 2, title: "Design Patterns", author: "Erich Gamma, Richard Helm, Ralph Johnson" , review: "메모",rating: 4.0),
    ];*/
    _onSelected(dynamic val) {
      //setState(() => bookReviewList.removeAt(val));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('책 리뷰'),
      ),
      body: ListView(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('books').orderBy('timestamp').snapshots(),
            builder: (context, snapshot) {
              final docs = snapshot.data!.docs.where((element) => element.get('uid') == _authentication.currentUser!.uid).toList();
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true ,
                itemCount: docs.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: () {
                      final bookreview = BookReview( title: docs[index]['title'], author: docs[index]['author'],review: docs[index]['review'], rating: 5);
                      Navigator.pushNamed(context, '/book-reviewDetail', arguments: bookreview);
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
                            PopupMenuButton(
                              onSelected: _onSelected,
                              icon: const Icon(Icons.more_vert),
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

class BookReviewDetailPage extends StatefulWidget {
  const BookReviewDetailPage({Key? key}) : super(key: key);

  @override
  State<BookReviewDetailPage> createState() => _BookReviewDetailPageState();
}

class _BookReviewDetailPageState extends State<BookReviewDetailPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as BookReview;
    var rating = args.rating;

    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰 [ ${args.title} ]'),
        leading:  IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const SizedBox(height: 60, width: 100,),
                  Text('${args.title}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 2, width: 100,),
                  SmoothStarRating(rating: rating,size: 45,starCount: 5,allowHalfRating: false,),
                  const SizedBox(height: 45, width: 100,),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Text('${args.review}',
                      style: const TextStyle(
                        height: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 50, 50),
        child: FloatingActionButton(
          onPressed: (){},
          child: const Text('edit'),
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

class BookReview {
  int? id;
  String? title;
  String? author;
  String? review;
  double rating;

  BookReview (
      {
        this.id,
        required this.title,
        required this.author,
        required this.review,
        required this.rating,}
      );
}
