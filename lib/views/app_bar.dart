import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_comments_with_firebase/blocs/auth/auth_bloc.dart';
import 'package:post_comments_with_firebase/blocs/main/main_bloc.dart';
import 'package:post_comments_with_firebase/services/db_service.dart';

class MyAppBar extends StatelessWidget {
  final String season;
  final Map<String, dynamic> language;
  final SearchType type;
  const MyAppBar({super.key, required this.season, required this.language, required this.type});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.zero,
      child: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(const SignOutEvent());
            },
            icon: const Icon(Icons.logout),
          ),
          Text(season),
          const SizedBox(width: 20),
        ],
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 80),
          child:  Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: TextField(
              decoration: InputDecoration(
                  hintText: language["search"],
                  border: const OutlineInputBorder()
              ),
              onChanged: (text) {
                final bloc = context.read<MainBloc>();
                debugPrint(text);
                if(text.isEmpty) {

                  if(type == SearchType.all) {
                    bloc.add(const AllPublicPostEvent());
                  } else {
                    bloc.add(const MyPostEvent());
                  }
                } else {
                  bloc.add(SearchMainEvent(text));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
