import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> markers = {};
  Set<Marker> _markers = {};
  Set<Polyline> polylines = {};
  List<BitmapDescriptor> locationIcon = List<BitmapDescriptor>(3); // 현재 위치 표시하는 icon list
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  Widget build(BuildContext context) {
    var test = ModalRoute.of(context).settings.arguments;
    print("자녀: "+test);
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
            panelBuilder: (ScrollController sc) => _scrollingList(sc),
          ),
        ],
      ),
    );
  }
}


Widget _scrollingList(ScrollController sc){
  return ListView.separated(
    separatorBuilder: (context, index) => Divider(
      height: 10.0,
      color: Color(0xfff3b92b),
    ),
    controller: sc,
    itemCount: 50,
    itemBuilder: (BuildContext context, int i){
      return GestureDetector(
        onTap: (){},
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('17:40 오후 ~ 19:40 오후 (2h)',style: TextStyle(fontFamily: 'BMJUA'),),
                  Text('부산광역시 금정구 금강로 355번길',style: TextStyle(fontFamily: 'BMJUA',),),
                ],
              ),
              SizedBox(width: 20,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: Color(0xfff3b92b),
                    width: 2.0,
                  ),
                  color: Colors.white,
                ),
                child: IconButton(icon:Icon(Icons.room,color: Color(0xfff3b92b),),),
              ),
            ],
          ),
        ),
      );
    },
  );
}