import 'package:chatapp/services/services.dart';
import 'package:chatapp/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final alto = MediaQuery.of(context).size.height - kToolbarHeight - 24;
    final _state = Provider.of<AppState>(context, listen: true);

    return Scaffold(
      backgroundColor: MyColors.primaryBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: ancho,
            margin: EdgeInsets.symmetric(horizontal: 30),
            padding: EdgeInsets.all(20),
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(20),
            // ),
            child: Center(
              child: Flexible(
                child: Text(
                  'Bienvenido, adelante, te estamos esperando',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              //nuevo usarios
              _state.newUser();
            },
            child: Container(
              width: ancho,
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: _state.loading
                    ? SizedBox(
                      width: 20,
                      height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2,),
                      )
                    : Flexible(
                        child: Text(
                          'Ingresa como Anónimo',
                          overflow: TextOverflow.fade,
                          style: TextStyle(),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
