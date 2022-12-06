import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/lookup.dart';
import 'dart:convert';



class BarcodePage extends StatefulWidget {
  const BarcodePage({Key? key}) : super(key: key);

  @override
  State<BarcodePage> createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
  String _scanBarcode = 'Unknown';
  String _BookTitle = 'Unknown';
  String _BookUrl = 'Unknown';
  String _BookAuthor = 'Unknown';
  String _BookIsbn = 'Unknown';
  BookLookupInfo book = BookLookupInfo(id: -1, title: "", author: "", url: "");
  /// For Continuous scan
  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }
  Future<void> barcodeScan() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    http.Response response = await http.get(
      Uri.parse('https://openapi.naver.com/v1/search/book_adv.json?d_isbn=$barcodeScanRes&display=10&start=1'),
      headers: {"X-Naver-Client-Id": "Ji7OCLtvdcG6Gs2f2Scn",
        "X-Naver-Client-Secret": "ymDKMriT5Q"},
    );
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      print("###");
      print(data['items'][0]['isbn']);
      print(data['items'][0]['title']);
      print(data['items'][0]['author']);
      print(data['items'][0]['image']);
      _BookIsbn = data['items'][0]['isbn'];
      _BookTitle = data['items'][0]['title'];
      _BookAuthor = data['items'][0]['author'];
      _BookUrl = data['items'][0]['image'];
      book.id=0;
      book.title=_BookTitle;
      book.author=_BookAuthor;
      book.url=_BookUrl;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Barcode Scanner Demo'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.cyan,
        ),
        body: Builder(builder: (BuildContext context) {
          return Container(
              alignment: Alignment.center,
              child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image_search(_BookUrl),
                    const SizedBox(
                      height: 50,
                    ),
                    Text('Scan result : $_BookTitle\nAuthor: $_BookAuthor',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 45,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.cyan,
                          ),
                          onPressed: () => barcodeScan(),
                          child: const Text('Barcode Scan',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 45,
                        child: ElevatedButton(
                          onPressed: (){
                            print(book.id);
                            print(book.author);
                            print(book.title);
                            Navigator.pop(context, BookLookupInfo.clone(book));},
                          child: const Text("Use book")
                        ),
                    )
                  ]));
        }));
  }
}