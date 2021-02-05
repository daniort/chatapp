import 'package:chatapp/services/services.dart';
import 'package:chatapp/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String groupKey;
  final String para;

  ChatPage({Key key, @required this.para, @required this.groupKey})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController inpuCon = new TextEditingController();
  ScrollController _scroCon = new ScrollController();
    String alias;
  @override
  void initState() {
    super.initState();
    alias = widget.para;
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final alto = MediaQuery.of(context).size.height - kToolbarHeight - 24;
    final _state = Provider.of<AppState>(context, listen: true);
    print(_state.allAlias);
    for( var u in _state.allAlias ){
      if( u['idname'] == widget.para ){
        alias = u['alias'];
      }

    }

    return Scaffold(
        backgroundColor: MyColors.primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(alias),
        ),
        body: Center(
          child: Container(
            width: ancho,
            height: alto,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StreamBuilder(
                  stream: UserServices().getGroupMen(widget.groupKey),
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
                            Map item = {};
                            List _msns = [];
                            bool _existe = false;

                            if (widget.groupKey == null) {
                              dataStream.forEach((index, data) {
                                List _users = List<String>.from(data['users']);
                                if (_users.contains(_state.idname) &&
                                    _users.contains(widget.para)) {
                                  item = ({"key": index, ...data});
                                  _existe = true;
                                }
                              });
                              if (_existe)
                                item['mensajes'].forEach((index, data) {
                                  _msns.add({"key": index, ...data});
                                });
                            } else {
                              Map item = dataStream;
                              item['mensajes'].forEach((index, data) {
                                _msns.add({"key": index, ...data});
                              });
                            }
                            _msns
                                .sort((a, b) => a['fech'].compareTo(b['fech']));
                            if (_msns.isNotEmpty) {
                              if (_state.idname ==
                                      _msns[_msns.length - 1]['paraquien'] &&
                                  _msns[_msns.length - 1]['visto'] == false) {
                                UserServices().envisto(widget.groupKey,
                                    _state.idname, widget.para, _msns);
                              }
                            }

                            return Expanded(
                              child: SingleChildScrollView(
                                controller: _scroCon,
                                physics: BouncingScrollPhysics(),
                                reverse: true,
                                child: Column(
                                  children: [
                                    for (var x in _msns)
                                      Align(
                                        alignment: x['dequien'] == _state.idname
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          padding: EdgeInsets.all(15),
                                          constraints: BoxConstraints(
                                              maxWidth: ancho * 0.8),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: <Color>[
                                                  Colors.pink[700],
                                                  Colors.deepPurple[600]
                                                ],
                                              ),
                                              borderRadius: x['dequien'] ==
                                                      _state.idname
                                                  ? BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                    )
                                                  : BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20),
                                                    )),
                                          child: Text(x['msn'],
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Expanded(child: Container());
                          }
                        } else {
                          return Expanded(child: Container());
                        }
                        break;
                      default:
                        return Center(
                            child: Text('Algo salió mal, intente nuevamente'));
                    }
                  },
                ),
                Container(
                  color: Colors.grey[100],
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: inpuCon,
                          decoration: InputDecoration(
                            hintText: 'Escribe algo bonito',
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      FloatingActionButton(
                        child: Icon(Icons.send),
                        onPressed: () {
                          if (inpuCon.text.isNotEmpty) {
                            UserServices()
                                .newMessage(
                                    user1: _state.idname,
                                    user2: widget.para,
                                    msn: inpuCon.text,
                                    groupKey: widget.groupKey)
                                .then((_) => inpuCon.clear());
                            _scroCon.animateTo(
                                _scroCon.position.minScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn);
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
