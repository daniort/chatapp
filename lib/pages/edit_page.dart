import 'package:chatapp/services/services.dart';
import 'package:chatapp/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController inpuCon = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final alto = MediaQuery.of(context).size.height - kToolbarHeight - 24;
    final _state = Provider.of<AppState>(context, listen: true);

    return Scaffold(
      appBar: AppBar(title: Text('Editar alias')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('Tu ID es: ' + _state.idname,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('Tu Alias es: ' + _state.dataUser[0]['alias'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: inpuCon,
              decoration: InputDecoration(
                hintText: 'Escribe un alias bonito',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                ),
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (inpuCon.text.isNotEmpty)
                UserServices()
                    .changeAlias(inpuCon.text, _state.dataUser[0]['key']);
                    _state.actualizarDatos(_state.dataUser[0]['key']);
              Navigator.of(context).pop();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 10),
              width: ancho * 0.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300]),
              child: Center(
                child: Text(
                  'Guardar',
                  style: TextStyle(color: Colors.grey[900], fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
