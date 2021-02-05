import 'dart:io';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserServices {
  final FirebaseDatabase realDB = new FirebaseDatabase();


   Future<void> newMessage(
      {String user1, String user2, String msn, String groupKey}) async {


        print(user1);
        print(user2);
        print(msn);
        print(groupKey);

    DateTime hoy = DateTime.now();
    TimeOfDay ahora = TimeOfDay.now();
    int fech = fechData(hoy, ahora);

    try {
      if (groupKey == null) {
        var grupo = await realDB
            .reference()
            .child('groupMenssage')
            .once(); 
        if (grupo == null || grupo.value == null) {
          String _keygrup = _crearGrupo(user1, user2, fech);
          _guardarMen(_keygrup, msn, user1, user2, fech);
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
            _guardarMen(item['key'], msn, user1, user2, fech);
            _updateGrupo(key, fech);
          } else {
            print('NO EXISTE, lo Creé.');
            String _keygu = await _crearGrupo(user1, user2, fech);
            _guardarMen(_keygu, msn, user1, user2, fech);
          }
        }
      } else {
        print('ME PASASTE LA KEY DEL GRUPO');
        _guardarMen(groupKey, msn, user1, user2, fech);
        _updateGrupo(groupKey, fech);
      }
    } catch (e) {
      print(e);
    }
  }



  Future<bool> newUser(String username) async {
    try {
      realDB.reference().child('users').push().set({
        "idname": username,
        "alias": username,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
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

  int fechData(DateTime selectedDate, TimeOfDay timeOfDay) =>
      selectedDate.millisecondsSinceEpoch;

 
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

  Future<List> getDataUSer(String text) async {
    try {
      var info = await realDB
          .reference()
          .child('users')
          .orderByChild('idname')
          .equalTo(text)
          .once();
      Map data = info.value;
      List item = [];
      data.forEach((index, data) => item.add({"key": index, ...data}));
      return item;
    } catch (e) {
      print(e);
    }
  }

  void _guardarMen(String key, String msn, String de, String para, int fech) {
    realDB
        .reference()
        .child('groupMenssage')
        .child(key)
        .child('mensajes')
        .push()
        .set({
      'msn': msn,
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

}
