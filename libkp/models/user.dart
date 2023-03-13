import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ifdconnect/models/role.dart';
import 'package:ifdconnect/user/formations.dart';

/*
var stars = [0, 0, 2, 3, 5],
    count = 0,
    sum = 0;

stars.forEach(function(value, index){
  count += value;
  sum += value * (index + 1);
});

console.log(sum / count);
 */

class User {
  /*** Campus**/
  int token_user;
  int user_id;
  int student_id;
  String user_filliere;
  var employee_id;
  var notif_allow;
  String identifiant;

  String actual_address;
  String permanent_address;
  String address;
  String birthday;
  String secteur;
  String domain;
  String email_pro;
  List<Formation> formations = [];
  var type_req;
  var id_publication;
  var message;

  User(
      {this.fullname,
        this.id,
        this.struct,
        this.notif_allow,
        this.online1,
        this.birthday,
        this.nbr_c,
        this.password,
        this.piece,
        this.actual_address,
        this.formations,
        this.address,
        this.image,
        this.updatedAt,
        this.role,
        this.permanent_address,
        this.bio,
        this.token_cit,
        this.employee_id,
        this.identifiant,
        this.user_id,
        this.student_id,
        this.role_admin,
        this.timestamp,
        this.phone,
        this.prenom,
        this.type_profil,
        this.firstname,
        this.verify,
        this.item,
        this.disponible,
        this.titre,
        this.discussion,
        this.organisme,
        this.sexe,
        this.age,
        this.objectif,
        this.cmpetences,
        this.block_list,
        this.connect_list,
        this.tpe,
        this.auth_id,
        this.lat,
        this.token,
        this.createdAt,
        this.not_id,
        this.lng,
        this.raja,
        this.email_public,
        this.email,
        this.site_web,
        this.tel_public,
        this.online,
        this.location,
        this.community,
        this.last_active,
        this.linkedin_link,
        this.communitykey,
        this.instargram_link,
        this.fullname1,
        this.twitter_link,
        this.active_loc,
        this.received_list,
        this.active,
        this.anne_exp,
        this.adr,
        this.niveau,
        this.speciality,
        this.subspec,
        this.domain,
        this.secteur,
        this.email_pro});

  var discussion = 0;

  String id = "";
  String niveau;
  String phone = "";
  String password = "";
  String piece;
  var verify;
  var active_loc;
  var nbr_c;
  var email_public;
  var site_web;
  String prenom = "";
  String fullname = "";
  String email = "";
  String image = "";
  var fullname1;
  var online1;

  var role_admin;
  Role role;
  var raja;
  String bio = "";
  String firstname;
  String linkedin_link;
  String instargram_link;
  String twitter_link;
  bool read;
  var not_id;
  var notif_time;
  var createdAt;
  var updatedAt;

  var adr;
  String notif_id;
  bool accept;
  var type_profil;
  var token = "";
  var confirm;
  var mm = false;

  var struct;
  var tel_public;
  var item;
  String titre = "";
  String organisme = "";
  String sexe;
  var age;
  String anne_exp;
  int ind = 0;
  var cmpetences;
  var objectif;
  String community;
  List<String> list = new List<String>();
  List<String> list_obj = new List<String>();
  var location;
  var lat;
  var online = false;
  var lng;
  String offline = "";
  var last_active;
  String dis;
  var disponible;

  var tt = "";
  var active;
  var auth_id;
  bool show = true;
  var token_cit = "";
  bool block = true;
  var block_list;
  var connect_list;
  var received_list;
  var communitykey;
  String id_other;
  bool activate = true;
  dynamic tpe;

  var subspec;
  var speciality;

  bool wait = false;
  bool begin = true;
  var cnt = "";
  int not_msg = 0;
  int not = 0;

  var medz;
  var timestamp;

  static Map<dynamic, dynamic> toMap(User user) => {
    "id1": user.auth_id,
    "token": user.token,
    "objectId": user.id,
    "createdAt": user.createdAt,
    'anne_exp': user.anne_exp,
    "last_active": user.last_active,
    "communityName": user.community,
    "communityKey": user.communitykey,
    'titre': user.titre,
    "lat": double.parse(user.lat),
    "lng": double.parse(user.lng),
    "phone": user.phone,
    "active": int.parse(user.active),
    "location": user.location,
    "linkedin_link": user.linkedin_link,
    "instagram_link": user.instargram_link,
    "twitter_link": user.twitter_link,
    "organisme": user.organisme,
    "familyname": user.fullname,
    "objectif": user.objectif,
    "firstname": user.firstname,
    "age": user.age,
    "email": user.email,
    'sexe': user.sexe,
    "competences": user.cmpetences,
    "bio": user.bio,
    "photoUrl": user.image
  };

  factory User.fromMap(var document) {



    return new User(
      auth_id: document["id1"],
      notif_allow: document["notif_allow"],
      online1: document["token"].toString() == "null"
          ? false
          : document["token"].toString(),
      token: document["token"].toString() == "null" ? '' : document["token"],
      id: document["objectId"],
      password: document["password"],
      identifiant: document["identifiant"],
      struct: document["structure"],
      permanent_address: document["permanent_address"],
      actual_address: document["actual_address"],
      address: document["address"],
      formations: document["user_formations"] == null
          ? List<Formation>.from([])
          : List<Formation>.from(document["user_formations"]
          .map((e) => Formation.fromMap(e))
          .toList()),
      birthday: document["birthday"],
      secteur: document["secteur"],
      domain: document["domain"],
      email_pro: document["email_pro"],
      employee_id: document["employee_id"],
      user_id: document["user_id"],
      student_id: document["student_id"],
      role: document["role_user"] == null
          ? Role()
          : Role.fromMap(document["role_user"]),
      tel_public: document["tel_public"],
      adr: document["adr"],
      nbr_c: document["nbrDisc"],
      token_cit: document["token_cit"],
      role_admin: document["role_admin"],
      active_loc: document["active_loc"],
      type_profil: document["type_profil"],
      speciality: document["speciality"],
      subspec: document["subsubs"],
      raja: document["raja"],
      piece: document["piece"],
      verify: document["verify"],
      email: document["email"],
      createdAt: document["createdAt"],
      updatedAt: document["updatedAt"],
      not_id: document["not_id"],
      anne_exp: document['anne_exp'],
      tpe: document["tprofile"],
      discussion: document["discussion"].toString() == "null"
          ? 0
          : document["discussion"],
      niveau: document["niveau"],
      email_public: document["email_public"],
      site_web: document["site_web"],
      community:
      document["communityName"] == null ? "" : document["communityName"],
      communitykey:
      document["communityKey"] == null ? "" : document["communityKey"],
      titre: document['titre'].toString() == "null" ? "" : document['titre'],
      lat: document["lat"].toString() == "null"
          ? ""
          : document["lat"].toString(),
      lng: document["lng"].toString() == "null"
          ? ""
          : document["lng"].toString(),
      phone: document['phone'].toString() == "null" ? "" : document['phone'],
      active: document["active"] == null ? 0 : document["active"],
      location:
      document["location"].toString() == "null" ? "" : document["location"],
      linkedin_link:
      document['linkedin_link'] == "null" ? "" : document['linkedin_link'],
      instargram_link: document['instagram_link'] == "null"
          ? ""
          : document['instagram_link'],
      twitter_link:
      document['twitter_link'] == "null" ? "" : document['twitter_link'],
      organisme: document['organisme'].toString() == "null"
          ? ""
          : document['organisme'],
      fullname: document['familyname'],
      fullname1: document['fullname'],
      disponible:
      document['disponible'] == null ? false : document['disponible'],
      firstname: document['firstname'],
      objectif:
      document["objectif"].toString() == "null" ? "" : document["objectif"],
      age: document["age"].toString() == "null"
          ? ""
          : document["age"].toString(),
      sexe: document['sexe'].toString() == "null" ? "" : document['sexe'],
      online: document["online"],
      last_active: document["last_active"],
      cmpetences: document["competences"].toString() == "null"
          ? []
          : document["competences"],
      bio: document['bio'],
      image:
      document['photoUrl'].toString() == "null" ? "" : document['photoUrl'],
    );
  }
}
