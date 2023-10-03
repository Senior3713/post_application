import 'package:flutter/material.dart';
import 'package:post_comments_with_firebase/pages/detail_page.dart';

class MyFloatingButton extends StatelessWidget {
  const MyFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DetailPage()));
      },
      child: const Icon(Icons.create_outlined),
    );
  }
}
