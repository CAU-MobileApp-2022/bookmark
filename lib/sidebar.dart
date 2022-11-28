import 'package:flutter/material.dart';


class DrawerMenuItems extends StatelessWidget {
  const DrawerMenuItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text("홈"),
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushNamed(context, '/', arguments: {});
          },
        ),
        ListTile(
          leading: const Icon(Icons.numbers),
          title: const Text("책 등록"),
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushNamed(context, '/lookup', arguments: {});
          },
        ),
        ListTile(
          leading: const Icon(Icons.numbers),
          title: const Text("북마크 메모"),
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushNamed(context, '/bookmark', arguments: {});
          },
        ),
        ListTile(
          leading: const Icon(Icons.numbers),
          title: const Text("독서 알람"),
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushNamed(context, '/alarm', arguments: {});
          },
        ),
        ListTile(
          leading: const Icon(Icons.numbers),
          title: const Text("책 리뷰"),
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushNamed(context, '/review', arguments: {});
          },
        ),
        ListTile(
          leading: const Icon(Icons.numbers),
          title: const Text("베스트셀러"),
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushNamed(context, '/bestseller', arguments: {});
          },
        ),
      ],
    );
  }
}
