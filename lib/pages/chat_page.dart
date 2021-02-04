import 'package:chatapp/services/services.dart';
import 'package:chatapp/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String idnameQuien;
  final Map para;

  ChatPage({Key key, @required this.idnameQuien, @required this.para})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController inpuCon = new TextEditingController();
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
        body: Container(
          width: ancho,
          height: alto,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white,
          ),
          child: Column(
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
                            if (data['dequien'] == widget.idnameQuien &&
                                data['paraquien'] == widget.para['idname'])
                              data['mensajes'].forEach((index, data) {
                                item.add(data);
                              });
                          });
                          return Expanded(
                            child: ListView.builder(
                                padding: EdgeInsets.only(bottom: 5.0),
                                itemCount: item.length,
                                itemBuilder: (context, index) {
                                  // var msn = item[index];
                                  print(item[index]);
                                  // print("==============");
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    padding: EdgeInsets.all(15),
                                    constraints: BoxConstraints(
                                        // maxWidth: ancho * 0.7,
                                        // minWidth: ancho * 0.1,
                                        ),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: <Color>[
                                            Colors.pink[400],
                                            Colors.deepPurple[300]
                                          ],
                                        ),
                                        // color: Colors.pink[200],
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        )),
                                    child: Text(item[index]['msn'],
                                    style: TextStyle(
                                      color: Colors.white
                                    )),
                                  );
                                }),
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
                        if (inpuCon.text.isNotEmpty)
                          UserServices().newMessage(
                              quien: widget.idnameQuien,
                              para: widget.para['idname'],
                              msn: inpuCon.text,
                              groupKey: null);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
