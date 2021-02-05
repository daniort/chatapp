import 'package:chatapp/services/services.dart';
import 'package:chatapp/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController inpuCon = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    final alto = MediaQuery.of(context).size.height - kToolbarHeight - 24;
    final _state = Provider.of<AppState>(context, listen: true);

    return Scaffold(
      backgroundColor: MyColors.primaryBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: alto * 0.4,
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.all(20),
              constraints: BoxConstraints(),
              child: Image.asset(
                'assets/images/image3.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: RichText(
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'MyChatApp',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\nBienvenido, adelante, te estamos esperando',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomRight,
                        colors: <Color>[Colors.pink[400], Colors.pink[600]],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: TextField(
                              controller: inpuCon,
                              decoration: InputDecoration(
                                hintText: 'Entra con tu id',
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            if (inpuCon.text.isNotEmpty)
                              _state.signup(inpuCon.text);
                              
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Center(
                              child: Icon(Icons.login, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _state.newUser(),
                    child: Container(
                      width: ancho,
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.white,
                            Colors.grey[100],
                            Colors.grey[200],
                            Colors.grey[100]
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: _state.loading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Flexible(
                                child: Text(
                                  'Soy nuevo',
                                  //'Ingresa como Anónimo',
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
