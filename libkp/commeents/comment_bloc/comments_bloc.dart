import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ifdconnect/commeents/comment_bloc/comments_event.dart';
import 'package:ifdconnect/commeents/comment_bloc/comments_state.dart';
import 'package:ifdconnect/commeents/comment_repository.dart';


class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final CommentsRepository commentsRepository;

  CommentsBloc({@required this.commentsRepository}) : super(null);

  @override
  Stream<CommentsState> mapEventToState(
    CommentsEvent event,
  ) async* {
    if (event is CommentsRequested) {
      yield CommentsLoadInProgress();

      final commentsResponse =
          await commentsRepository.get(event.postId);
      if (commentsResponse != null) {
        yield CommentsLoadSuccess(commentsResponse: commentsResponse);
      } else {
        yield CommentsLoadFailure(commentsResponse: commentsResponse);
      }
    }
  }
}
