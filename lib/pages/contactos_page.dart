import 'package:chatapp/pages/pages.dart';
import 'package:chatapp/services/services.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  final String idname;

  ContactsPage({Key key, @required this.idname}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: UserServices().getContacts(widget.idname),
      builder: (context, snap) {
        switch (snap.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
            break;
          case ConnectionState.none:
            return Center(child: Text('Algo salió mal, intente nuevamente'));
            break;
          case ConnectionState.none:
            return Center(child: Text('Algo salió mal, intente nuevamente'));
            break;
          case ConnectionState.done:
            List _lista = snap.data;
            if (_lista.isNotEmpty)
              return ListView.builder(
                itemCount: snap.data.length,
                itemBuilder: (context, index) {
                  Map user = snap.data[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChatPage(
                                para: user,
                                idnameQuien: widget.idname,
                              )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              Colors.grey[100],
                              Colors.deepPurple[50]
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(),
                        title: Text(user['alias']),
                      ),
                    ),
                  );
                },
              );
            else
              return Center(
                  child: Text(
                'Ups!\n Nadie esta en MyChatApp aún',
                textAlign: TextAlign.center,
              ));

            break;

          default:
            return Center(child: Text('Algo salió mal, intente nuevamente'));
        }
      },
    ));
  }
}
