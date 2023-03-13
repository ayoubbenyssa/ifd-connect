import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageServices {
  SharedPreferences prefs;


  getprefs() async{
    prefs = await SharedPreferences.getInstance();

  }

  // save date to shared preferences
  Future<void> saveDataToSharedPrefrences({@required String table, @required String data}) async {
    try {
      prefs = await SharedPreferences.getInstance();

      await prefs.setString(table, data);
    } catch (e) {
      debugPrint("---> Error saving data to shared preferences : $e");
    }
  }
  Future<void> saveListStringDataToSharedPrefrences({@required String table, @required List<String> data}) async {
    try {
      prefs = await SharedPreferences.getInstance();

      await prefs.setStringList(table, data);
    } catch (e) {
      debugPrint("---> Error saving data to shared preferences : $e");
    }
  }
  Future<void> saveBooleanDataToSharedPrefrences({@required String table, @required bool data}) async {
    try {
      prefs = await SharedPreferences.getInstance();

      await prefs.setBool(table, data);
    } catch (e) {
      debugPrint("---> Error saving data to shared preferences : $e");
    }
  }

  // get data from shared preferences
  Future<String> getDataFromSharedPreferences({@required String table}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      print("***************** getDataFromSharedPreferences ${table}");
      print(prefs.getString(table));
      print("***************** getDataFromSharedPreferences ${table}");

      return prefs.getString(table);
    } catch (e) {
      debugPrint("---> Error getting data from shared preferences : $e");
      return null;
    }
  }
  Future<List<String>> getListStringDataFromSharedPreferences({@required String table}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(table);
    } catch (e) {
      debugPrint("---> Error getting data from shared preferences : $e");
      return null;
    }
  }
  Future<bool> getBooleanDataFromSharedPreferences({@required String table}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      return prefs.getBool(table);
    } catch (e) {
      debugPrint("---> Error getting data from shared preferences : $e");
      return null;
    }
  }

}


/**
 *
    // fetch services from sqlite
    Future<String?> _fetchServicesFromSharedPreferences() async {
    return await _sql.getDataFromSharedPreferences(table: _table);
    }

 */