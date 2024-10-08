import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/models/band.dart';


class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Héroes del Silencio', votes: 1),
    Band(id: '3', name: 'Queen', votes: 2),
    Band(id: '4', name: 'Bon Jovi', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BandNames', style: TextStyle( color: Colors.black87 ),),
        backgroundColor: Colors.white,
        elevation: 1,
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

  ListTile _bandTile( Band band ) {
    return ListTile(
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
      this.bands.add( new Band(id: DateTime.now.toString(), name: name, votes: 0 ) );
      setState(() {});
    }

    Navigator.pop(context);
  }

}