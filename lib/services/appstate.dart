import 'dart:math';

import 'package:chatapp/services/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState with ChangeNotifier {
  SharedPreferences _prefs;
  String idname = null;
  bool login = false;
  bool loading = false;
  bool error = false;
  List dataUser = [];
  List allAlias = [];

  AppState() {
    appState();
  }

  Future<void> appState() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('isLogin')) {
      idname = _prefs.getString("idname");
      login = true;
      loading = false;
      notifyListeners();
      getAllAlias();
    } else {
      loading = false;
      notifyListeners();
    }
  }

  int _ram() => Random().nextInt(9999);

  void newUser() async {
    loading = true;
    notifyListeners();
    String username = "user${_ram().toString()}";
    UserServices().newUser(username).then((value) {
      idname = username;
      login = true;
      loading = false;
      notifyListeners();
      getAllAlias();
      UserServices().getDataUSer(value, username).then((value) {
        if (value != null) {
          dataUser = value;
          idname = value[0]['idname'];
          _prefs.setBool('isLogin', true);
          _prefs.setString('idname', username);
        }
      }).catchError((e) {
        print('Error al cargar los datos');
      });
    });
  }

  void signup(String idna) {
    loading = true;
    notifyListeners();
    UserServices().getDataUSer(null, idna).then((value) {
      if (value != null) {
        dataUser = value;
        idname = value[0]['idname'];
        _prefs.setBool('isLogin', true);
        _prefs.setString('idname', idname);
        login = true;
        loading = false;
        notifyListeners();
        getAllAlias();
      } else {
        login = false;
        loading = false;
        notifyListeners();
      }
    });
  }

  void logout() {
    dataUser = null;
    idname = null;

    login = false;
    loading = false;
    _prefs.clear();
    notifyListeners();
  }

  void getAllAlias() {
    UserServices().getAlias().then((value) {
      allAlias = value;
    });
  }

  actualizarDatos(String idname) {
   try {
      UserServices().getDataUSer(dataUser[0]['key'], idname).then((value) {
      if (value != null) {
        dataUser = value;
        idname = value[0]['idname'];
      }
    }).catchError((e) {
      print('Error al cargar los datos');
    });
   } catch (e) {
     print(e);
   }
  }
}
