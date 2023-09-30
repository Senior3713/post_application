import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:post_comments_with_firebase/blocs/post/post_bloc.dart';
import 'package:post_comments_with_firebase/models/post_model.dart';
import 'package:post_comments_with_firebase/services/auth_service.dart';
import 'package:post_comments_with_firebase/services/db_service.dart';

class PostPage extends StatelessWidget {
  final Post post;

  const PostPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${post.title.substring(0, 1).toUpperCase()}${post.title.substring(1)}",
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.blue.shade900,
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 11),
                  child: Text(
                    post.username,
                    style: GoogleFonts.anekGurmukhi(
                        fontSize: 16, color: Colors.lightBlueAccent.shade100),
                  ),
                ),
                Image(image: NetworkImage(post.imageUrl)),
                const SizedBox(height: 13),
                Padding(
                  padding: const EdgeInsets.only(left: 11),
                  child: Text(
                    "${post.content.substring(0, 1).toUpperCase()}${post.content.substring(1)}",
                    style: GoogleFonts.sahitya(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.remove_red_eye,
                      color: Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      post.viewCount.toString(),
                      style: GoogleFonts.gabriela(color: Colors.white70),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${post.createdAt.hour.toString().padLeft(2, '0')}:${post.createdAt.minute.toString().padLeft(2, '0')}",
                      style: GoogleFonts.gabriela(color: Colors.white70),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
                const SizedBox(height: 7),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: DBService.db.ref(Folder.post).child(post.id).onValue,
            builder: (context, snapshot) {
              Post current = snapshot.hasData
                  ? Post.fromJson(
                      jsonDecode(jsonEncode(snapshot.data!.snapshot.value))
                          as Map<String, Object?>,
                      isMe: AuthService.user.uid == post.userId)
                  : post;

              post.comments = current.comments;
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: current.comments.length,
                itemBuilder: (context, index) {
                  final msg = current.comments[index];

                  if (AuthService.user.uid == msg.userId) {
                    return Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: SizedBox.shrink(),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      msg.message,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${msg.writtenAt.hour.toString().padLeft(2, "0")}:${msg.writtenAt.minute.toString().padLeft(2, "0")}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              msg.username,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                            ),
                                            const SizedBox(width: 10),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.blue.shade900,
                                child: Text(
                                  msg.username.substring(0, 1),
                                  style: GoogleFonts.abrilFatface(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg.message,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.lightBlueAccent,
                                        child: Text(
                                          msg.username.substring(0, 1),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        msg.username,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      )
                                    ],
                                  ),
                                  Text(
                                    "${msg.writtenAt.hour.toString().padLeft(2, "0")}:${msg.writtenAt.minute.toString().padLeft(2, "0")}",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: SizedBox.shrink(),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Write a comment...",
            suffixIcon: GestureDetector(
                onTap: () {
                  if (controller.text.isNotEmpty) {
                    context.read<PostBloc>().add(WriteCommentPostEvent(
                        post.id, controller.text, post.comments));
                    controller.text = '';
                  }
                },
                child: const Icon(
                  Icons.send,
                  size: 23,
                )),
          ),
        ),
      ),
    );
  }
}
