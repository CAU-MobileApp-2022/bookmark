import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/sidebar.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/lookup.dart';
import 'dart:convert';



class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _scanBarcode = 'Unknown';
  String _BookTitle = 'Unknown';
  String _BookUrl = 'Unknown';
  String _BookAuthor = 'Unknown';
  String _BookIsbn = 'Unknown';
  final search_field = TextEditingController();
  List bookLookupInfoList = [];
  BookLookupInfo book = BookLookupInfo(id: -1, title: "", author: "", url: "");

  Future<void> bookSearch(String barcodeScanRes) async {
    print('https://openapi.naver.com/v1/search/book.json?query=${barcodeScanRes}&display=10&start=1');
    http.Response response = await http.get(
      Uri.parse('https://openapi.naver.com/v1/search/book.json?query=${barcodeScanRes}&display=10&start=1'),
      headers: {"X-Naver-Client-Id": "Ji7OCLtvdcG6Gs2f2Scn",
        "X-Naver-Client-Secret": "ymDKMriT5Q"},
    );
    //print(response.body);
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      bookLookupInfoList.clear();
      data['items'].forEach((item) {
        _BookIsbn = item['isbn'];
        _BookTitle = item['title'];
        _BookAuthor = item['author'];
        _BookUrl = item['image'];
        print(_BookTitle);
        bookLookupInfoList.add(BookLookupInfo(id:int.parse(_BookIsbn), title:_BookTitle, author: _BookAuthor, url:_BookUrl));
      });
    });
  }
  Widget Image_search(String url){
    if (url=="Unknown") return Icon(Icons.search, size:100.0);
    else return Image.network(
        _BookUrl,
        width: 200,
        fit: BoxFit.fill
    );
  }

  _onSelected(dynamic val) {
    Navigator.pop(context, BookLookupInfo.clone(bookLookupInfoList[val]));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Barcode Scanner Demo'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.cyan,
        ),
        body:ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SizedBox(
                width: 200,
                height: 30,
                child: TextField(
                    decoration: InputDecoration( // 디자인 관련
                      border: OutlineInputBorder(), //테두리
                      labelText: 'search', //제목짓기
                    ),
                    controller: search_field, //변수 값 넣기
                  )
                ),
                  SizedBox(width: 20),
                  ElevatedButton (
                    onPressed: () async {
                      await bookSearch(search_field.text);
                    },
                    child: Text('Search'),
                  ),
                ],
              ),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: bookLookupInfoList!.length,
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
                                  '${bookLookupInfoList[index].title}',
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
                                child: Text("Select"),
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