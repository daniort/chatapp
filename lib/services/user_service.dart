import 'dart:io';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserServices {
  final FirebaseDatabase realDB = new FirebaseDatabase();

  // final FirebaseStorage _sto =
  //     FirebaseStorage(storageBucket: 'gs://xoloapp-9c3d2.appspot.com');

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
      Map data = users.value;
      List item = [];
      data.forEach((index, data) {
        if (idname != data['idname']) item.add({"key": index, ...data});
      });
      return item;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Stream getGroupMen({String dequien, String paraquien}) {
    try {
      return realDB
          .reference()
          .child('groupMenssage')
          // .orderByChild('dequien')
          // .equalTo(dequien)
          // .orderByChild('paraquien')
          // .equalTo(paraquien)
          .onValue;
          
    } catch (e) {
      print(e);
    }
  }

  int fechData(DateTime selectedDate, TimeOfDay timeOfDay) {
    return (selectedDate.year * 100000000) +
        (selectedDate.month * 1000000) +
        (selectedDate.day * 10000) +
        (timeOfDay.hour * 100) +
        timeOfDay.minute;
  }

  Future<void> newMessage(
      {String quien, String para, String msn, String groupKey}) async {
    DateTime hoy = DateTime.now();
    TimeOfDay ahora = TimeOfDay.now();
    int fech = fechData(hoy, ahora);

    try {
      if (groupKey == null) {
        var grupo = await realDB.reference().child('groupMenssage').once();
        if (grupo == null || grupo.value == null) {
          //aun no existen registros(crea el primero)
          String _keyGrupoCreado = _crearGrupo(quien, para, fech);
          realDB
              .reference()
              .child('groupMenssage')
              .child(_keyGrupoCreado)
              .child('mensajes')
              .push()
              .set({
            'msn': msn,
            'fech': fech,
            "dequien": quien,
            "paraquien": para,
          });
        } else {
          Map data = grupo.value;
          bool existe = false;
          String key;
          List item = [];
          data.forEach((index, data) => item.add({"key": index, ...data}));
          for (var i in item) {
            if (i['dequien'] == quien && i['paraquien'] == para) {
              existe = true;
              key = i['key'];
            }
          }
          if (existe) {
            print('EXISTEEEEE');
            print(key);
            realDB
                .reference()
                .child('groupMenssage')
                .child(key)
                .child('mensajes')
                .push()
                .set({
              'msn': msn,
              'fech': fech,
              "dequien": quien,
              "paraquien": para,
            });
            realDB
                .reference()
                .child('groupMenssage')
                .child(key)
                .update({'fech': fech});
          } else {
            print('NOEXISTE');
            String _keyGrupoCreado = await _crearGrupo(quien, para, fech);
            realDB
                .reference()
                .child('groupMenssage')
                .child(_keyGrupoCreado)
                .child('mensajes')
                .push()
                .set({
              'msn': msn,
              'fech': fech,
              "dequien": quien,
              "paraquien": para,
            });
          }
        }
      } else {
        print('ME PASASTE LA KEY DEL GRUPO');
        realDB
            .reference()
            .child('groupMenssage')
            .child(groupKey)
            .child('mensajes')
            .push()
            .set({
          'msn': msn,
          'fech': fech,
          "dequien": quien,
          "paraquien": para,
        });
        realDB
            .reference()
            .child('groupMenssage')
            .child(groupKey)
            .update({'fech': fech});
      }
    } catch (e) {
      print(e);
    }
  }

  String _crearGrupo(String quien, String para, int fech) {
    DatabaseReference databaseReference =
        realDB.reference().child("groupMenssage").push();
    databaseReference.set({
      "dequien": quien,
      "paraquien": para,
      'fech': fech,
    });
    return databaseReference.key;
  }
}
