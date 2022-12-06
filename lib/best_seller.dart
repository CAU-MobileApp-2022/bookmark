import 'package:flutter/material.dart';
import 'package:flutter_app/sidebar.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:xml/xml.dart' as xml;
import 'package:url_launcher/url_launcher.dart';

class BestSellerPage extends StatefulWidget {
  const BestSellerPage({Key? key}) : super(key: key);

  @override
  State<BestSellerPage> createState() => _BestSellerPageState();
}

class _BestSellerPageState extends State<BestSellerPage>{
  List best = [];
  var uri = Uri.parse('https://book.interpark.com/api/bestSeller.api?'
      'key=B51F80AD1A064461111845D45A0EB772E92054CA6F17F5B1A259D06D393E01A5&categoryId=100');

  // This function will be triggered when the app starts
  void _loadData() async {

    final temporaryList = [];
    final bookXml = await http.get(uri);
    //log(bookXml.body.toString());
    // in real life, this is usually fetched from an API or from an XML file
    // In this example, we use this XML document to simulate the API response

    final bookDocument = xml.XmlDocument.parse(bookXml.body);
    final bookNode = bookDocument.findElements('channel').first;
    final books = bookNode.findElements('item');

    // loop through the document and extract values
    // for (final employee in employees) {
    //   final name = employee.findElements('name').first.text;
    //   final salary = employee.findElements('salary').first.text;
    //   temporaryList.add({'name': name, 'salary': salary});
    // }
    for (final book in books) {
      final title = book.findElements('title').first.text;
      //log(title);
      final description = book.findElements('description').first.text;
      //log(description);
      final priceStandard = book.findElements('priceStandard').first.text;
      //log(priceStandard);
      final priceSales = book.findElements('priceSales').first.text;
      //log(priceSales);
      final image = book.findElements('coverSmallUrl').first.text;
      // log(image);
      final mobileLink = book.findElements('link').first.text;
      // log(mobileLink);
      final author = book.findElements('author').first.text;
      // log(author);
      final publisher = book.findElements('publisher').first.text;
      //  log(publisher);
      temporaryList.add({
        'title': title,
        'description': description,
        'priceStandard': priceStandard,
        'priceSales' : priceSales,
        'image' : image,
        'mobileLink' : mobileLink,
        'author' : author,
        'publisher' : publisher,
      });
    }
    // Update the UI
    setState(() {
      best = temporaryList;
    });
  }

  // Call the _loadData() function when the app starts
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('베스트 셀러')),
      body: ListView.separated(
        itemCount: best.length,
        separatorBuilder: (ctx, index) => Divider(
          indent: 8,
          endIndent: 8,
        ),
        itemBuilder: (ctx, index) => ListTile(
          onTap: () async => {
            log(best[index]['mobileLink'].toString()),
            await launchUrl(Uri.parse(best[index]['mobileLink'].toString())),

            //  await launchUrl(Uri.parse(best[index]['mobileLink'])),
          },
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          strutStyle: StrutStyle(fontSize: 16.0),
                          text: TextSpan(
                              text: best[index]['title'],
                              style: TextStyle(
                                  color: Colors.black,
                                  height: 1.4,
                                  fontSize: 20.0,
                                  fontFamily: 'Jua-Regular',
                                  )),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(best[index]['image']),
                    Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            strutStyle: StrutStyle(fontSize: 16.0),
                            text: TextSpan(
                                text: best[index]['description'],
                                style: TextStyle(
                                    color: Colors.brown,
                                    height: 1.4,
                                    fontSize: 14.0,
                                    fontFamily: 'Jua-Regular',)),
                          ),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            strutStyle: StrutStyle(fontSize: 16.0),
                            text: TextSpan(
                                text: '저자: ${best[index]['author']}',
                                style: TextStyle(
                                    color: Colors.amber,
                                    height: 1.4,
                                    fontSize: 16.0,
                                    fontFamily: 'Jua-Regular',)),
                          )),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      child: Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            strutStyle: StrutStyle(fontSize: 16.0),
                            text: TextSpan(
                                text: '출판사: ${best[index]['publisher']}',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    height: 1.4,
                                    fontSize: 16.0,
                                    fontFamily: 'Jua-Regular')),
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('정가: ${best[index]['priceStandard']}원',
                      style: const TextStyle(
                          color: Colors.black,
                      ),
                    ),
                    Text('  할인가: ${best[index]['priceSales']}원',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              // Container(
              //   width: 300,
              //   height: 50,
              //   padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              //   child: Text(
              //     best[index]['description'],
              //     overflow: TextOverflow.ellipsis,
              //     style: const TextStyle(color: Colors.black),
              //   ),
              // ),
              // const SizedBox(height: 4),
              // Text(
              //   best[index]['publisher'],
              //   style: const TextStyle(color: Colors.black),
              // ),
              // const SizedBox(height: 4),
              // Text(
              //   best[index]['priceStandard'],
              //   style: const TextStyle(color: Colors.black),
              // ),
            ],
          ),
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
