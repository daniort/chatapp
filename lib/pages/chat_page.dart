import 'package:chatapp/services/services.dart';
import 'package:chatapp/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String idnameQuien;
  final String groupKey;
  final Map para;

  ChatPage(
      {Key key,
      @required this.idnameQuien,
      @required this.para,
      @required this.groupKey})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController inpuCon = new TextEditingController();
  ScrollController _scroCon = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final alto = MediaQuery.of(context).size.height - kToolbarHeight - 24;
    final _state = Provider.of<AppState>(context, listen: true);

    return Scaffold(
        backgroundColor: MyColors.primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(widget.para['alias']),
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
                  stream: UserServices().getGroupMen(
                      dequien: widget.idnameQuien,
                      paraquien: widget.para['idname']),
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
                            List item = [];
                            dataStream.forEach((index, data) {
                              if ((data['dequien'] == widget.idnameQuien &&
                                      data['paraquien'] ==
                                          widget.para['idname']) ||
                                  (data['dequien'] == widget.para['idname'] &&
                                      data['paraquien'] == widget.idnameQuien))
                                data['mensajes'].forEach((index, data) {
                                  item.add(data);
                                });
                            });
                            item.sort((a, b) {
                              //return a['fech'].compareTo(b['fech']);
                              return a['fech'].compareTo(b['fech']);
                            });

                            return Expanded(
                              child: SingleChildScrollView(
                                controller: _scroCon,
                                physics: BouncingScrollPhysics(),
                                reverse: true,
                                child: Column(
                                  children: [
                                    for (var x in item)
                                      Align(
                                        alignment: Alignment.centerRight,
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
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
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
                                    quien: widget.idnameQuien,
                                    para: widget.para['idname'],
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
