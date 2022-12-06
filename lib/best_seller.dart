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
      appBar: AppBar(title: const Text('Best Seller')),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: best.length,

        itemBuilder: (ctx, index) => ListTile(
          onTap: () async => {
            log(best[index]['mobileLink'].toString()),
            await launchUrl(Uri.parse(best[index]['mobileLink'].toString())),

            //  await launchUrl(Uri.parse(best[index]['mobileLink'])),
          },
          title: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.network(
                    best[index]['image']!,
                    width: 100,
                    fit: BoxFit.fill
                ),
                Container(
                    width: 250,
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${best[index]['title']}",
                          style: const TextStyle(
                            //overflow: TextOverflow.ellipsis,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              child:
                              Text('저자: ${best[index]['author']}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Container(
                              width: 100,
                              child:
                              Text('출판사 : ${best[index]['publisher']}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 250,
                              child:
                              Text('[정가: ${best[index]['priceStandard']}원] / [할인가 : ${best[index]['priceSales']}원]',
                                overflow: TextOverflow.fade,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 300,
                          height: 50,
                          child:
                          Text('${best[index]['description']}',
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                ),
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