import 'package:chatapp/pages/pages.dart';
import 'package:chatapp/services/services.dart';
import 'package:chatapp/values/values.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ConverPage extends StatefulWidget {
  @override
  _ConverPageState createState() => _ConverPageState();
}

class _ConverPageState extends State<ConverPage> {
  ScrollController _scroCon = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final alto = MediaQuery.of(context).size.height - kToolbarHeight - 24;
    final _state = Provider.of<AppState>(context, listen: true);

    return Scaffold(
      backgroundColor: MyColors.primaryBackground,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
          ),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  width: ancho,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: StreamBuilder(
                    stream: UserServices().getAllGroups(),
                    builder: (BuildContext context, AsyncSnapshot snap) {
                      switch (snap.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                          break;
                        case ConnectionState.none:
                          return Center(
                              child:
                                  Text('Algo salió mal, intente nuevamente'));
                          break;
                        case ConnectionState.active:
                          Map dataStream = snap.data.snapshot.value;
                          if (snap.hasData != null && dataStream != null) {
                            if (dataStream.isNotEmpty) {
                              List items = [];
                              dataStream.forEach((index, data) {
                                List _users = data['users'];
                                if (_users.contains(_state.idname))
                                  items.add({"key": index, ...data});
                              });
                              items.sort(
                                  (a, b) => b['fech'].compareTo(a['fech']));

                              return ListView.builder(
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    Map x = items[index];
                                    List _users = List<String>.from(x['users']);
                                    _users.remove(_state.idname);
                                    _users.join(', ');
                                    String _el = _users[0];
                                    List _msns = [];
                                    x['mensajes'].forEach((index, data) {
                                      _msns.add({"key": index, ...data});
                                    });
                                    _msns.sort((a, b) =>
                                        b['fech'].compareTo(a['fech']));

                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ChatPage(
                                                para: _el,
                                                groupKey: x['key'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: ListTile(
                                          leading: CircleAvatar(),
                                          title: _tituloAlias(_el, context ), //Text(_el),
                                          subtitle: _subtitulo(
                                              _state.idname, _msns[0]),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(_msns[0]['hora']),
                                              _state.idname ==
                                                      _msns[0]['dequien']
                                                  ? Icon(
                                                      FontAwesomeIcons.check,
                                                      size: 10,
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              return Container(
                                  child: Center(
                                      child: Text('No tienes ningún mensaje')));
                            }
                          } else {
                            return Container(
                                child: Center(
                                    child: Text('No tienes ningún mensaje')));
                          }
                          break;
                        default:
                          return Center(
                              child:
                                  Text('Algo salió mal, intente nuevamente'));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lastMsn(Map x) {
    List _mens = [];
    x.forEach((key, value) {
      _mens.add(value);
    });
    _mens.sort((a, b) => b['fech'].compareTo(a['fech']));
    return Text(_mens[0]['msn']);
  }

  Widget _subtitulo(String name, msn) {
    return Text(
      msn['msn'],
      style: (name == msn['paraquien'] && msn['visto'] == false)
          ? TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[900])
          : TextStyle(fontWeight: FontWeight.normal),
    );
  }

  Widget _tituloAlias(String el, BuildContex) {
    print(el);
    final _state = Provider.of<AppState>(context, listen: false);
    String _alias;
    for( var u in _state.allAlias ){
      if( u['idname'] == el ){
        _alias = u['alias'];
      }
    }
    return Text(_alias);
  }
}
