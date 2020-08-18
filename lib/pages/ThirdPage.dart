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
  PanelController panelController = PanelController();
  Set<Marker> _markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> points =[];
  List<BitmapDescriptor> locationIcon = List<BitmapDescriptor>(3); // 현재 위치 표시하는 icon list

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    print(data);
    if(data==null){
      print("ThirdPage: 아이 현재 위치 없지롱.");
      //snackbar 하거나 3초 정도의 alert 박스를 넣는것이 좋을 것 같다고 생각함.
    }else{
      _markers.add(Marker(
        markerId: MarkerId( _markers.length.toString() ),
        position: LatLng( data['lat'], data['lon'] ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    }

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
            controller: panelController,
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
                          Text( snapshot.data[index].date, style: TextStyle(fontFamily: 'BMJUA') ),
                          Text( snapshot.data[index].source + "->" +snapshot.data[index].destination, style: TextStyle(fontFamily: 'BMJUA') )//snapshot.data[index].destination
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
                onTap: () async{
                  //print( snapshot.data[index].polygon );
                  polylines.clear();
                  points.clear();
                  List<String> a = snapshot.data[index].polygon.split(',');
                  for(int i=0; i<(a.length)/2; i=i+2){
                    points.add(LatLng(double.parse(a[i]),double.parse(a[i+1])));
                  }

                  polylines.add(Polyline(
                    polylineId: PolylineId(polylines.length.toString()),
                    points: points,
                    color: Colors.blue,
                  ));
                  final GoogleMapController controller = await _mapController.future;
                  controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                    target: LatLng(points[0].latitude,points[0].longitude),
                    zoom: 16.0,
                  )));
                  panelController.close();
                  setState(() {});
                }
              );
            },
          );
        }
        else{
          return Text("nodata");
        }
      }
    );
  }
}
