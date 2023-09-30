part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
}

class CreatePostEvent extends PostEvent {
  final String title;
  final String content;
  final File file;
  final bool isPublic;
  final int viewCount;

  const CreatePostEvent({
    required this.title,
    required this.content,
    required this.isPublic,
    required this.file,
    required this.viewCount,
  });

  @override
  List<Object?> get props => [title, content, isPublic, file, viewCount];
}

class PostIsPublicEvent extends PostEvent {
  final bool isPublic;
  const PostIsPublicEvent(this.isPublic);

  @override
  List<Object?> get props => [isPublic];
}

class DeletePostEvent extends PostEvent {
  final String postId;
  const DeletePostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class UpdatePostEvent extends PostEvent {
  final String postId;
  final String title;
  final String content;
  final bool isPublic;

  const UpdatePostEvent({
    required this.title,
    required this.postId,
    required this.content,
    required this.isPublic,
  });

  @override
  List<Object?> get props => [postId, title, content, isPublic];
}


class ViewImagePostEvent extends PostEvent {
  final File file;
  const ViewImagePostEvent(this.file);

  @override
  List<Object?> get props => [file];
}

class WriteCommentPostEvent extends PostEvent {
  final String postId;
  final String message;
  final List<Message> old;
  const WriteCommentPostEvent(this.postId, this.message, this.old);

  @override
  List<Object?> get props => [postId, message, old];
}

class IncrementViewCountEvent extends PostEvent {
  final int count;
  final String postId;
  final String email;
  final List viewers;

  const IncrementViewCountEvent({required this.email, required this.viewers, required this.count, required this.postId});
  @override
  List<Object?> get props => [count, postId, email, viewers];
}
