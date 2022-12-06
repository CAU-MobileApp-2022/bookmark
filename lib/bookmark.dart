import 'package:flutter/material.dart';
import 'package:flutter_app/sidebar.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {

    final bookmarkList = [
      Bookmark( id: 1, title: "The Selfish Gene", author: "Richard Dawkins",memo: "매모메모메모메모"),
      Bookmark( id: 2, title: "Design Patterns", author: "Erich Gamma, Richard Helm, Ralph Johnso" , memo: "메모 123412341231231231sadfasdfasfasdfasdaasdfsdfasdfasdfasdfasdfsdfasdfasdffasdfasdfasdf23123123"),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('북마크'),
      ),
      body: ListView(
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true ,
            itemCount: bookmarkList.length,
            itemBuilder: (context, index){
              return GestureDetector(
                onTap: () {
                  final bookmark = bookmarkList[index];
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
                            Text(
                              '${bookmarkList[index].title}',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines:3,
                            ),
                            Text(bookmarkList[index].author!,
                              maxLines:3,
                              overflow: TextOverflow.ellipsis,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  SizedBox(height: 58, width: 100,),
                  Text('${args.title}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(height: 38, width: 100,),
                  Container(
                    constraints: BoxConstraints(maxWidth: 500),
                    child: Text('${args.memo}',
                      style: TextStyle(
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
        padding: EdgeInsets.fromLTRB(0, 0, 50, 50),
        child: FloatingActionButton(
          onPressed: (){},
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