import 'package:chatapp/pages/pages.dart';
import 'package:chatapp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
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
                  stream: UserServices().getAllGroups(dequien: _state.idname),
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
                        print(dataStream);

                        if (snap.hasData != null && dataStream != null) {
                          if (dataStream.isNotEmpty) {
                            List item = [];
                            dataStream.forEach((index, data) {
                              if (data['dequien'] == _state.idname)
                                item.add(data);
                            });
                            item.sort((a, b) => b['fech'].compareTo(a['fech']));

                            return Expanded(
                              child: SingleChildScrollView(
                                controller: _scroCon,
                                physics: BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    for (var x in item)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        margin: EdgeInsets.all(10),
                                        child: InkWell(
                                          onTap: () {
                                            print(x);
                                            // Navigator.of(context).push(
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             ChatPage(
                                            //               para: x,
                                            //               idnameQuien:
                                            //                   _state.idname,
                                            //               groupKey: null,
                                            //             )));
                                          },
                                          child: ListTile(
                                            leading: CircleAvatar(),
                                            title: Text(x['paraquien']),
                                            subtitle: _lastMsn(x[
                                                'mensajes']), //Text(x['mensajes'][0]['msn']),
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('9:32am'),
                                                Icon(Icons.check_circle)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }
                        } else {
                          return Expanded(
                              child: Container(child: Text('hola')));
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
