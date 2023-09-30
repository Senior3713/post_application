import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_comments_with_firebase/blocs/main/main_bloc.dart';
import 'package:post_comments_with_firebase/blocs/post/post_bloc.dart';
import 'package:post_comments_with_firebase/models/post_model.dart';
import 'package:post_comments_with_firebase/services/rc_service.dart';
import 'package:post_comments_with_firebase/views/custom_text_field_view.dart';

class DetailPage extends StatefulWidget {
  final Post? post;

  const DetailPage({this.post, Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late bool isPublic;
  final ImagePicker picker = ImagePicker();
  File? file;

  @override
  void initState() {
    super.initState();
    setup();
  }

  void setup() {
    if (widget.post != null) {
      isPublic = widget.post!.isPublic;
      context.read<PostBloc>().add(PostIsPublicEvent(isPublic));
      titleController = TextEditingController(text: widget.post!.title);
      contentController = TextEditingController(text: widget.post!.content);
    } else {
      isPublic = false;
      titleController = TextEditingController();
      contentController = TextEditingController();
    }
  }

  void getImage() async {
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    file = xFile != null ? File(xFile.path) : null;
    if (file != null && mounted) {
      context.read<PostBloc>().add(ViewImagePostEvent(file!));
    }
  }

  Map<String, dynamic> language = jsonDecode(RCService.getLanguage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language["detail"]),
      ),
      body: SingleChildScrollView(
        child: BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            if (state is PostFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }

            if (state is CreatePostSuccess || state is UpdatePostSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(language["success"])));
              context.read<MainBloc>().add(const AllPublicPostEvent());
              Navigator.of(context).pop();
            }

            if (state is PostIsPublicState) {
              isPublic = state.isPublic;
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: getImage,
                  child: BlocBuilder<PostBloc, PostState>(
                    buildWhen: (previous, current) =>
                        current is ViewImagePostSuccess,
                    builder: (context, state) {
                      return Card(
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).width - 40,
                          width: MediaQuery.sizeOf(context).width,
                          child: file == null
                              ? const Icon(
                                  Icons.add,
                                  size: 175,
                                )
                              : Image.file(
                                  file!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(controller: titleController, title: language["title"]),
                CustomTextField(controller: contentController, title: language["content"]),
                Row(
                  children: [
                    BlocSelector<PostBloc, PostState, bool>(
                      selector: (state) {
                        if (state is PostIsPublicState) return state.isPublic;

                        return isPublic;
                      },
                      builder: (context, value) {
                        return Checkbox(
                            value: value,
                            onChanged: (value) {
                              context
                                  .read<PostBloc>()
                                  .add(PostIsPublicEvent(value!));
                            });
                      },
                    ),
                    Expanded(
                      child: Text(
                        language["checkText"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.post == null) {
            context.read<PostBloc>().add(
                  CreatePostEvent(
                    file: file!,
                    title: titleController.text,
                    content: contentController.text,
                    isPublic: isPublic,
                    viewCount: 0,
                  ),
                );
          } else {
            context.read<PostBloc>().add(
                  UpdatePostEvent(
                    postId: widget.post!.id,
                    title: titleController.text,
                    content: contentController.text,
                    isPublic: isPublic,
                  ),
                );
          }
        },
        child: const Icon(Icons.cloud_upload_rounded),
      ),
    );
  }
}
