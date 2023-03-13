import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();
}

class CommentsRequested extends CommentsEvent {
  final String postId;
  String type;

  CommentsRequested({@required this.postId, this.type});

  @override
  List<Object> get props => [postId, type];
}
