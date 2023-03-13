import 'package:equatable/equatable.dart';
import 'package:ifdconnect/models/role.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:meta/meta.dart';


@immutable
abstract class FilterUsersEvent extends Equatable {
  FilterUsersEvent([List props = const <dynamic>[]]) : super();
}
class FilterUsersquested extends FilterUsersEvent {

  String type;
  User user;
  String text;
  Role title;

  FilterUsersquested({@required this.type,this.user, this.text , this.title});

  @override
  List<Object> get props => [type, user, text,title];
}
