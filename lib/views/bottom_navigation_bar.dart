import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_comments_with_firebase/blocs/main/main_bloc.dart';
import 'package:post_comments_with_firebase/services/db_service.dart';

// ignore: must_be_immutable
class MyNavigationBar extends StatelessWidget {
  SearchType type;
  final Map<String, dynamic> language;
  MyNavigationBar({super.key, required this.type, required this.language});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        if(index == 0) {
          type = SearchType.all;
          context.read<MainBloc>().add(const AllPublicPostEvent());
        } else {
          type = SearchType.me;
          context.read<MainBloc>().add(const MyPostEvent());
        }
      },
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.public), label: language["all"]),
        BottomNavigationBarItem(icon: const Icon(Icons.person), label: language["me"]),
      ],
    );
  }
}
