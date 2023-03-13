import 'package:equatable/equatable.dart';
import 'package:ifdconnect/models/user_response.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FilterUsersState extends Equatable {
  FilterUsersState([List props = const <dynamic>[]]) : super();
}

class InitialFilterUsersState extends FilterUsersState {
  @override
  List<Object> get props => [];
}

class FilterUsersLoadInProgress extends FilterUsersState {
  @override
  List<Object> get props => [];
}

class FilterUsersLoadSuccess extends FilterUsersState {
  final UserResponse calResponse;
  FilterUsersLoadSuccess({@required this.calResponse});

  @override
  List<Object> get props => [calResponse];
}

class FilterUsersLoadFailure extends FilterUsersState {
  final UserResponse calResponse;

  FilterUsersLoadFailure({@required this.calResponse});

  @override
  List<Object> get props => [calResponse];
}

