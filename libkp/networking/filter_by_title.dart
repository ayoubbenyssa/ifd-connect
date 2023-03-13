import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ifdconnect/app/filters_users_bloc/filter_bloc.dart';
import 'package:ifdconnect/app/filters_users_bloc/filter_event.dart';
import 'package:ifdconnect/app/filters_users_bloc/filter_state.dart';

import 'package:ifdconnect/models/role.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/networking/user_item.dart';
import 'package:ifdconnect/services/Fonts.dart';

class FilterByTitle extends StatefulWidget {
  FilterByTitle(this.title,this.user);

  Role title;
  User user;

  @override
  _FilterByNewUsersState createState() => _FilterByNewUsersState();
}

class _FilterByNewUsersState extends State<FilterByTitle> {
  FilterUsersBloc _filteBloc;

  @override
  void initState() {
    super.initState();


    _filteBloc = BlocProvider.of<FilterUsersBloc>(context);
    _filteBloc.add(
        FilterUsersquested(type: "title", user: widget.user, title: widget.title));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Fonts.col_cl,
      body: BlocBuilder<FilterUsersBloc, FilterUsersState>(
          builder: (context, homeState) {
        if (homeState is FilterUsersLoadInProgress) {
          return Center(
            child: Padding(
                padding: EdgeInsets.only(top: 64),
                child: CupertinoActivityIndicator()),
          );
        } else if (homeState is FilterUsersLoadSuccess) {
          final users = homeState.calResponse.user;

          print(users);
          return (users.isEmpty)
              ? Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: 64),
                      child: Text("Aucun utilisateur trouvé !")),
                )
              : ListView(
                  children: users.map((e) => UserItem(e,widget.user, "title")).toList());
        } else {
          return Container();
        }
      }),
      appBar: new AppBar(
        title: new Text(
          widget.title.name,
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ),
    );
  }
}
