import 'dart:convert';
import 'package:post_comments_with_firebase/blocs/auth/auth_bloc.dart';
import 'package:post_comments_with_firebase/blocs/main/main_bloc.dart';
import 'package:post_comments_with_firebase/blocs/post/post_bloc.dart';
import 'package:post_comments_with_firebase/pages/detail_page.dart';
import 'package:post_comments_with_firebase/pages/post_page.dart';
import 'package:post_comments_with_firebase/pages/sign_in_page.dart';
import 'package:post_comments_with_firebase/services/auth_service.dart';
import 'package:post_comments_with_firebase/services/db_service.dart';
import 'package:post_comments_with_firebase/services/rc_service.dart';
import 'package:post_comments_with_firebase/services/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_comments_with_firebase/views/app_bar.dart';
import 'package:post_comments_with_firebase/views/bottom_navigation_bar.dart';
import 'package:post_comments_with_firebase/views/drawer.dart';
import 'package:post_comments_with_firebase/views/floating_action_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  SearchType type = SearchType.all;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MainBloc>().add(const AllPublicPostEvent());
  }

  void showWarningDialog(BuildContext ctx) {
    final controller = TextEditingController();
    showDialog(
      context: ctx,
      builder: (context) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if(state is DeleteAccountSuccess) {
              Navigator.of(context).pop();
              if(ctx.mounted) {
                Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (context) => SignInPage()));
              }
            }

            if(state is AuthFailure) {
              Navigator.of(context).pop();
              Navigator.of(ctx).pop();
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                AlertDialog(
                  title: const Text(I18N.deleteAccount),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state is DeleteConfirmSuccess
                          ? I18N.requestPassword
                          : I18N.deleteAccountWarning),
                      const SizedBox(
                        height: 10,
                      ),
                      if (state is DeleteConfirmSuccess)
                        TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                              hintText: I18N.password),
                        ),
                    ],
                  ),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  actions: [

                    /// #cancel
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(I18N.cancel),),

                    /// #confirm #delete
                    ElevatedButton(
                      onPressed: () {
                        if(state is DeleteConfirmSuccess) {
                          context.read<AuthBloc>().add(DeleteAccountEvent(controller.text.trim()));
                        } else {
                          context.read<AuthBloc>().add(const DeleteConfirmEvent());
                        }
                      },
                      child: Text(state is DeleteConfirmSuccess
                          ? I18N.delete
                          : I18N.confirm),
                    ),
                  ],
                ),

                if(state is AuthLoading) const Center(
                  child: CircularProgressIndicator(),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String season = RCService.getSeason;
    Map<String, dynamic> language = jsonDecode(RCService.getLanguage);

    return Scaffold(
      onDrawerChanged: (value) {
        if (value) {
          context.read<AuthBloc>().add(const GetUserEvent());
        }
      },
      appBar: AppBar(
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
      // ignore: void_checks
      drawer: MyDrawer(showWarningDialog: showWarningDialog),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }

              if(state is DeleteAccountSuccess && context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }

              if (state is SignOutSuccess) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignInPage()));
              }
            },
          ),

          BlocListener<PostBloc, PostState>(
            listener: (context, state) {
              if(state is DeletePostSuccess || state is IncrementViewCountEvent) {
                if(type == SearchType.all) {
                  context.read<MainBloc>().add(const AllPublicPostEvent());
                } else {
                  context.read<MainBloc>().add(const MyPostEvent());
                }
              }

              if (state is PostFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          )
        ],
        child: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            return Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final post = state.items[index];
                    return GestureDetector(
                      onLongPress: () {
                        context.read<PostBloc>().add(IncrementViewCountEvent(count: post.viewCount, postId: post.id, email: AuthService.user.email!, viewers: post.viewers));
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostPage(post: post)));
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Container(
                              color: Colors.primaries[index % Colors.primaries.length],
                              width: MediaQuery.sizeOf(context).width,
                              height: MediaQuery.sizeOf(context).width - 30,
                              child: Image(
                                image: NetworkImage(post.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            ListTile(
                              title: Text(post.title),
                              subtitle: Text(post.content),
                              trailing: post.isMe ? IconButton(
                                onPressed: () {
                                  context.read<PostBloc>().add(DeletePostEvent(post.id));
                                },
                                icon: const Icon(Icons.delete),
                              ): null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                if(state is MainLoading) const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: const MyFloatingButton(),
      bottomNavigationBar: MyNavigationBar(type: type, language: language),
    );
  }
}