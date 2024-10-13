import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';


class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    // Band(id: '1', name: 'Metallica', votes: 5),
    // Band(id: '2', name: 'Héroes del Silencio', votes: 1),
    // Band(id: '3', name: 'Queen', votes: 2),
    // Band(id: '4', name: 'Bon Jovi', votes: 5),
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', ( payload ){
      
      bands = (payload as List)
      .map( (band) => Band.fromMap(band))
      .toList();

      setState(() { });

    });

    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);


    return Scaffold(
      appBar: AppBar(
        title: const Text('BandNames', style: TextStyle( color: Colors.black87 ),),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only( right: 10 ),
            child: (socketService.serverStatus == ServerStatus.online) ?
              Icon( Icons.check_circle, color: Colors.blue[400] ) :
              Icon( Icons.offline_bolt, color: Colors.red[400] ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: ( context, i) => _bandTile( bands[i] )
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon( Icons.add ),
      ),
   );
  }

  Widget _bandTile( Band band ) {
    return Dismissible(
      key: Key( band.id ),
      direction: DismissDirection.startToEnd,
      onDismissed: ( direction ) {
        // TODO: llamar el borrado en el server
      },
      background: Container(
        padding: const EdgeInsets.only( left: 8.0 ),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band')
        )
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text( band.name.substring(0, 2) ),
        ),
        title: Text( band.name ),
        trailing: Text('${ band.votes }', style: const TextStyle( fontSize: 20 ),),
        onTap: () {
          // Add your navigation code here
          print('Tapped on ${ band.name }');
        },
      ),
    );
  }

  addNewBand() {

    final textController = new TextEditingController();

    if( Platform.isAndroid ) {
      // Android
      return showDialog(
        context: context, 
        builder: ( context ) {
          return AlertDialog(
            title: Text('New band name:'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                child: const Text('Add'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => addBandToList( textController.text ),
              )
            ],
          );
        }
      );
    }

    showCupertinoDialog(
      context: context, 
      builder: ( _ ) {
        return CupertinoAlertDialog(
          title: const Text('New band name:'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Add'),
              onPressed: () => addBandToList(textController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Dismiss'),
              onPressed: () => Navigator.pop( context ),
            )
          ],
        );
      }
    );

  }

  void addBandToList( String name ) {
    print(name);

    if( name.length > 1 ) {
      bands.add( Band(id: DateTime.now.toString(), name: name, votes: 0 ) );
      setState(() {});
    }

    Navigator.pop(context);
  }

}