import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../db/DB.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _mapController = Completer();

  Set<Marker> _markers = {};
  Set<Polyline> polylines = {};

  List<LatLng> points =[];
  List<dynamic> tempList = [];
  // List<dynamic> timeList = [];
  List<BitmapDescriptor> locationIcon = List<BitmapDescriptor>(3); // 현재 위치 표시하는 icon list

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;

    _markers.add(Marker(
      markerId: MarkerId( _markers.length.toString() ),
      position: LatLng( data['lat'], data['lon'] ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ));

    // print(data);
    // tempList.add(data['polygon']);
    // timeList.add(data['date']);

    // for(int i=0; i<tempList[0].length; i++) {
    //   points.add(LatLng(tempList[0][i][0], tempList[0][i][1]));
    // }

    // markers.add(Marker(
    //   markerId: MarkerId(markers.length.toString()),
    //   position: LatLng(data['start'][0],data['start'][1]),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    // ));

    // markers.add(Marker(
    //   markerId: MarkerId(markers.length.toString()),
    //   position: LatLng(data['end'][0],data['end'][1]),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    // ));

    // polylines.add(Polyline(
    //   polylineId: PolylineId(polylines.length.toString()),
    //   points:points,
    //   color:Colors.blue,
    // ));

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(35.229647, 129.089208),
              zoom: 15.0,
            ),
            zoomControlsEnabled: false,
            markers: _markers,
            polylines: polylines,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
          ),
          SlidingUpPanel(
            color: Color(0xfffefad1),
            borderRadius: radius,
            panelBuilder: (ScrollController sc) => _scrollingList(sc, context),
          ),
        ],
      ),
    );
  }


  Widget _scrollingList(ScrollController sc, context) {

    return FutureBuilder(
      future: DB.instance.getKidsPolygon(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if( snapshot.hasData ) {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              height: 10.0,
              color: Color(0xfff3b92b),
            ),
            controller: sc,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text( snapshot.data[index].date, style: TextStyle(fontFamily: 'BMJUA') )
                        ],
                      ),
                      SizedBox( width: 20 ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all( Radius.circular(10) ),
                          border: Border.all(
                            color: Color(0xfff3b92b),
                            width: 2.0,
                          ),
                          color: Colors.white,
                        ),
                        child: IconButton( icon: Icon(Icons.room, color: Color(0xfff3b92b), ), onPressed: () {} ),
                      ),
                    ],
                  ),
                ),
                onTap: () { print( snapshot.data[index] ); }
              );
            },
          );
        }
      }
    );

    // return ListView.separated(
    //   separatorBuilder: (context, index) => Divider(
    //     height: 10.0,
    //     color: Color(0xfff3b92b),
    //   ),
    //   controller: sc,
    //   itemCount: tempList.length,
    //   itemBuilder: (BuildContext context, int i){
    //     return GestureDetector(
    //       child: Container(
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: <Widget>[
    //             Column(
    //               children: <Widget>[
    //                 Text(timeList[i],style: TextStyle(fontFamily: 'BMJUA'),),
    //               ],
    //             ),
    //             SizedBox(width: 20,),
    //             Container(
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.all(Radius.circular(10)),
    //                 border: Border.all(
    //                   color: Color(0xfff3b92b),
    //                   width: 2.0,
    //                 ),
    //                 color: Colors.white,
    //               ),
    //               child: IconButton(icon:Icon(Icons.room,color: Color(0xfff3b92b),), onPressed: () {} ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       onTap: (){
    //         print(tempList[i]); // 이 좌표가 있는곳으로 지도 이동까지 만드는 것 해야함.
    //       },
    //     );
    //   },
    // );
  }

}

//_getParentsKidsId( int index ) async {
//  int kidsId = -1;
//  try { kidsId = await DB.instance.getParentsKidsId(index); }
//  catch(e) { print(e); }
//  return kidsId;
//}