import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ifdconnect/app/users_filter_repository.dart';
import 'package:ifdconnect/models/user_response.dart';
import 'package:meta/meta.dart';
import 'package:ifdconnect/app/filters_users_bloc/filter_event.dart';
import 'package:ifdconnect/app/filters_users_bloc/filter_state.dart';


class FilterUsersBloc extends Bloc<FilterUsersEvent, FilterUsersState> {
  final FilterUsersRepository filterRepository;

  FilterUsersBloc({@required this.filterRepository}) : super(null);

  @override
  Stream<FilterUsersState> mapEventToState(FilterUsersEvent event) async* {
    if (event is FilterUsersquested) {
      yield FilterUsersLoadInProgress();

      UserResponse calResponse;

     /* if (event.type == "search")
        calResponse =
            await filterRepository.get_search_result(event.text, event.user);
      else*/ if (event.type == "service")
        calResponse = await filterRepository
            .filterr_users(event.type, event.user);
      else if (event.type == "title")
        calResponse = await filterRepository
            .filterr_users(event.type, event.user, title: event.title);
      else
        calResponse =
            await filterRepository.filterr_users(event.type, event.user);
      if (calResponse != null /*&& feedResponse.responseCode == 1*/) {
        yield FilterUsersLoadSuccess(calResponse: calResponse);
      } else {
        yield FilterUsersLoadFailure(calResponse: calResponse);
      }
    }
  }
}
