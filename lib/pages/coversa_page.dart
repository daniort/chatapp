import 'package:chatapp/pages/pages.dart';
import 'package:chatapp/services/services.dart';
import 'package:flutter/material.dart';
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
      body: Center(
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
                            child: Text('Algo salió mal, intente nuevamente'));
                        break;
                      case ConnectionState.active:
                        Map dataStream = snap.data.snapshot.value;
                        if (snap.hasData != null && dataStream != null) {
                          if (dataStream.isNotEmpty) {
                            List items = [];
                            dataStream.forEach((index, data) {
                              List _users = data['users'];
                              if (_users.contains(_state.idname)) {
                                items.add({"key": index, ...data});
                              }
                            });
                            items
                                .sort((a, b) => b['fech'].compareTo(a['fech']));
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
                                  _msns.sort(
                                      (a, b) => b['fech'].compareTo(a['fech']));
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: EdgeInsets.all(10),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => ChatPage(
                                                    para: _el,
                                                    groupKey: x['key'],
                                                  )),
                                        );
                                      },
                                      child: ListTile(
                                        leading: CircleAvatar(),
                                        title: Text(_el),
                                        subtitle: Text(_msns[0]['msn']),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('9:32am'),
                                            Icon(Icons.check_circle)
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }
                        } else {
                          return Container(
                              child: Center(
                                  child: Text('No tienes ningún mensaje')));
                        }
                        break;
                      default:
                        return Center(
                            child: Text('Algo salió mal, intente nuevamente'));
                    }
                  },
                ),
              ),
            ),
          ],
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
}
