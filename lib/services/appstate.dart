import 'dart:math';

import 'package:chatapp/services/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState with ChangeNotifier {
  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final _facebookLogin = FacebookLogin();
  // final _appleLogin = AppleSignIn();
  // FirebaseDatabase realDB = new FirebaseDatabase();
  // FirebaseUser currentUser() => _user;
  // FirebaseUser _user;
  // int indexBottomNavigationBar = 0;
  SharedPreferences _prefs;
  String idname = null;
  // String errorM = "";
  // String busqueda = "";
  // String infoM = "";
  // String isidUser() => _prefs.getString('idUser');
  // bool isError() => _error;
  // bool isMsn() => _mensaje;
  // bool isSplash() => _splash;
  // bool islogin() => _login;
  // bool isloading() => _loading;
  bool login = false;
  // bool _splash = false;
  bool loading = false;
  bool error = false;
  // bool _mensaje = false;
  // Map categoria = null;
  // List namePets;
  // List listaCarrito = [];
  // List dataCollecion = [];
  // List allProducsData = [];
  // List producsBusquedaData = [];
  // List<String> filtrosProductos = [];
  // List<String> listaFiltros() => filtrosProductos;
  // var dataUser;
  // var dataRecor;

  // ignore: non_constant_identifier_names
  LoginState() {
    loginState();
  }

  void loginState() {
    // _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('isLogin')) {
      // _user = await _auth.currentUser();
      // dataUser = await UserServices().datosbyId(_user.uid);
      // cargarDatos(_prefs.getString("idUser"));
      // _login = _user != null;
      // _loading = false;
      // print('antes del notify!!!!');

      // notifyListeners();
      // print('despues del notify!!!!');
      // _cargarAllProducts();
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
    final bool newuser = await UserServices().newUser(username);
    if (newuser) {
      print('holiii!!!');
      // _prefs.setBool('isLogin', true);
      // _prefs.setString('username', username);
      idname = username;
      // _prefs.setString('username', idname);
      login = true;
      loading = false;
      notifyListeners();
    } else {
      login = false;
      loading = false;
      error = true;
      notifyListeners();
    }
  }
}
