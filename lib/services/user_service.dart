import 'dart:io';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserServices {
  final FirebaseDatabase realDB = new FirebaseDatabase();

  Future<void> newMessage(
      {String user1, String user2, String msn, String groupKey}) async {
    DateTime hoy = DateTime.now();
    String _hora = "${hoy.hour}:${hoy.minute}";
    int fech = fechData(hoy);
    try {
      if (groupKey == null) {
        var grupo = await realDB.reference().child('groupMenssage').once();
        if (grupo == null || grupo.value == null) {
          String _keygrup = _crearGrupo(user1, user2, fech);
          _guardarMen(_keygrup, msn, user1, user2, fech, _hora);
        } else {
          bool existe = false;
          String key;
          Map item = {};
          grupo.value.forEach((index, data) {
            List _users = data['users'];
            if (_users.contains(user1) && _users.contains(user2)) {
              item = ({"key": index, ...data});
              existe = true;
            }
          });
          if (existe) {
            print('Si ESTABA, YA LO ACTUALIZÉ');
            _guardarMen(item['key'], msn, user1, user2, fech, _hora);
            _updateGrupo(key, fech);
          } else {
            print('NO EXISTE, lo Creé.');
            String _keygu = await _crearGrupo(user1, user2, fech);
            _guardarMen(_keygu, msn, user1, user2, fech, _hora);
          }
        }
      } else {
        print('ME PASASTE LA KEY DEL GRUPO');
        _guardarMen(groupKey, msn, user1, user2, fech, _hora);
        _updateGrupo(groupKey, fech);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> newUser(String username) async {
    try {
      DatabaseReference databaseReference =
          realDB.reference().child("users").push();
      databaseReference.set({
        "idname": username,
        "alias": username,
      });
      return databaseReference.key;
    } catch (e) {
      print(e);
    }
  }

  Future<List> getContacts(String idname) async {
    print(idname);
    try {
      var users = await realDB.reference().child('users').once();
      List item = [];
      users.value.forEach((index, data) {
        if (idname != data['idname']) item.add({"key": index, ...data});
      });
      return item;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Stream getGroupMen(String grupokey) {
    try {
      if (grupokey == null)
        return realDB.reference().child('groupMenssage').onValue;
      else
        return realDB
            .reference()
            .child('groupMenssage')
            .child(grupokey)
            .onValue;
    } catch (e) {
      print(e);
    }
  }

  int fechData(hoy) => hoy.millisecondsSinceEpoch;

  String _crearGrupo(String quien, String para, int fech) {
    DatabaseReference databaseReference =
        realDB.reference().child("groupMenssage").push();
    databaseReference.set({
      "users": [quien, para],
      'fech': fech,
    });
    return databaseReference.key;
  }

  Stream getAllGroups({String dequien}) {
    try {
      return realDB.reference().child('groupMenssage').onValue;
    } catch (e) {
      print(e);
    }
  }

  Future getAliasbyID(String para) async {
    try {
      return await realDB
          .reference()
          .child('users')
          .orderByChild('idname')
          .equalTo(para)
          .once();
    } catch (e) {
      print(e);
    }
  }

  Future<List> getDataUSer(String key, String idname) async {
    try {
      var info = await realDB
          .reference()
          .child('users')
          .orderByChild('idname')
          .equalTo(idname)
          .once();
      List item = [];
      info.value.forEach((index, data) => item.add({"key": index, ...data}));
      return item;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _guardarMen(
      String key, String msn, String de, String para, int fech, String hora) {

var string = 'dartlang es una abuena app no?';
String letra = string.substring(0,1).toUpperCase(); 
String elresto = string.substring(1, string.length ); // 'art'

  print(letra + elresto);
    realDB
        .reference()
        .child('groupMenssage')
        .child(key)
        .child('mensajes')
        .push()
        .set({
      'msn': "${msn.substring(0,1).toUpperCase()}${msn.substring(1, msn.length)}",
      'hora': hora,
      'visto': false,
      'fech': fech,
      "dequien": de, //esta es mi id
      "paraquien": para,
    });
  }

  void _updateGrupo(String groupKey, int fech) {
    realDB
        .reference()
        .child('groupMenssage')
        .child(groupKey)
        .update({'fech': fech});
  }

  void changeAlias(String text, String keyUser) {
    realDB.reference().child('users').child(keyUser).update({'alias': text});
  }

  void envisto(String keygrupo, String miId, String para, List keymsn) {
    print(keygrupo);
    print(miId);
    print(para);
    print(keymsn);
    try {
      if (keygrupo != null) {
        for (var ms in keymsn) {
          realDB
              .reference()
              .child('groupMenssage')
              .child(keygrupo)
              .child('mensajes')
              .child(ms['key'])
              .update({'visto': true});
        }
      } else {
        String _key;
        realDB.reference().child('groupMenssage').once().then((value) {
          value.value.forEach((index, data) {
            List _users = data['users'];
            if (_users.contains(miId) && _users.contains(para)) {
              _key = data['key'];
            }
          });
        });
        for (var ms in keymsn) {
          realDB
              .reference()
              .child('groupMenssage')
              .child(_key)
              .child('mensajes')
              .child(ms['key'])
              .update({'visto': true});
        }
      }
    } catch (e) {
      print(e);
      print('ERROR');
    }
  }

  Future<List> getAlias() async {
    try {
      var info = await realDB
          .reference()
          .child('users')
          .once();
      List item = [];
      info.value.forEach((index, data) => item.add({"key": index, ...data}));
      return item;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
