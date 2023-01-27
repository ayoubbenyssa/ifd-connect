import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ifdconnect/commeents/comment_repository.dart';

abstract class CommentsState extends Equatable {
  const CommentsState();
}

class InitialCommentsState extends CommentsState {
  @override
  List<Object> get props => [];
}

class CommentsLoadInProgress extends CommentsState {
  @override
  List<Object> get props => [];
}

class CommentsLoadSuccess extends CommentsState {
  final CommentsResponse commentsResponse;

  CommentsLoadSuccess({@required this.commentsResponse});

  @override
  List<Object> get props => [commentsResponse];
}

class CommentsLoadFailure extends CommentsState {
  final CommentsResponse commentsResponse;

  CommentsLoadFailure({@required this.commentsResponse});

  @override
  List<Object> get props => [commentsResponse];
}
