import 'package:firebase_auth/firebase_auth.dart';
import 'package:post_comments_with_firebase/blocs/auth/auth_bloc.dart';
import 'package:post_comments_with_firebase/blocs/main/main_bloc.dart';
import 'package:post_comments_with_firebase/blocs/post/post_bloc.dart';
import 'package:post_comments_with_firebase/pages/home_page.dart';
import 'package:post_comments_with_firebase/pages/sign_in_page.dart';
import 'package:post_comments_with_firebase/pages/sign_up_page.dart';
import 'package:post_comments_with_firebase/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_comments_with_firebase/services/rc_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<PostBloc>(create: (_) => PostBloc()),
        BlocProvider<MainBloc>(create: (_) => MainBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: RCService.mode ? ThemeMode.dark : ThemeMode.light,
        darkTheme: ThemeData.dark(useMaterial3: true),
        theme: ThemeData.light(useMaterial3: true),
        home: StreamBuilder<User?>(
          initialData: null,
          stream: AuthService.auth.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.data != null) {
              return const HomePage();
            } else {
              return SignInPage();
            }
          },
        ),
      ),
    );
  }
}