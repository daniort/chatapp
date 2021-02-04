import 'package:chatapp/pages/pages.dart';
import 'package:chatapp/services/services.dart';
import 'package:chatapp/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
        create: (BuildContext context) => AppState(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ChatApp',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          routes: {
            "/": (BuildContext context) {
              final _state = Provider.of<AppState>(context, listen: true);
              if (_state.login) {
                return MyHomePage();
              } else {
                return LoginPage();
              }
            }
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final alto = MediaQuery.of(context).size.height - kToolbarHeight - 24;
    final _state = Provider.of<AppState>(context, listen: true);

    return Scaffold(
      backgroundColor: MyColors.primaryBackground,
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: MyColors.primaryBackground,
            bottom: TabBar(
              tabs: [
                Tab(child: Text('CHATS')),
                Tab(child: Text('CONTACTS')),
              ],
            ),
            elevation: 0.0,
            title: Text('MyChatApp'),
            actions: [
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  print('hola');
                },
              ),
            ],
          ),
          body: TabBarView(
            children: [
              ChatsPage(),
              ContactsPage(idname: _state.idname),
            ],
          ),
        ),
      ),
    );
  }
}
