import 'package:flutter/material.dart';

import '../db/DB.dart';
// import '../models/Parents.dart';
// import '../models/ParentsKids.dart';
import '../models/KidsPolygon.dart';

class DBpage extends StatefulWidget {
  @override
  _DBpageState createState() => _DBpageState();
}

class _DBpageState extends State<DBpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text('디비 목록 결과') ),
      // body: FutureBuilder<List<Parents>>(
//       body: FutureBuilder<List<ParentsKids>>(
      body: FutureBuilder<List<KidsPolygon>>(
        // future: DB.instance.getParents(),
//         future: DB.instance.getParentsKids(),
        future: DB.instance.getKidsPolygon(),
        builder: (context, snapshot) {
          if( snapshot.hasData ) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  // title: Text( snapshot.data[index].parentsId.toString() ),
                    title: Text( snapshot.data[index].polygon.toString() ),
//                  title: Text( snapshot.data[index].kidsId.toString() ),
                  // subtitle: Text( snapshot.data[index].key.toString() ),
                  // subtitle: Text( snapshot.data[index].name.toString() ),
//                  subtitle: Text( snapshot.data[index].parentsId.toString() ),
                  trailing: 
                    IconButton(
                      alignment: Alignment.center,
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        // _deleteParents();
                        _deleteParentsKids( snapshot.data[index].id );
                        setState(() {});
                      },
                    ),
                );
              }
            );
          }

          else if( snapshot.hasError ) return Text('error');
          else return Center( child: CircularProgressIndicator() );
        },
      ),
    );
  }
}

// _deleteParents() { DB.instance.deleteParentsId(); }
_deleteParentsKids( int id ) { DB.instance.deleteParentsKidsId(id); }