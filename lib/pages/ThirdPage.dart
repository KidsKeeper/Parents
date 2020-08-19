import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../Server.dart';
import '../db/DB.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class MapPage extends StatefulWidget {
  int kidsId = 0;
  MapPage(this.kidsId);
  @override
  _MapPageState createState() => _MapPageState(kidsId);
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _mapController = Completer();
  PanelController panelController = PanelController();
  Set<Marker> _markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> points =[];
  List<BitmapDescriptor> locationIcon = List<BitmapDescriptor>(3); // 현재 위치 표시하는 icon list
  int kidsId = 0;
  Timer timer;
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );


  // cctv
  List<LatLng> cctvLocation = [];
  bool visableCCTV = false;
  Image cctvButtonImage;
  BitmapDescriptor cctvMarkerImage;
  BitmapDescriptor kidLocationMarkerImage;

  _MapPageState(this.kidsId);

  @override
  void initState() {
    super.initState();
    getCCTV();
    cctvButtonImage = Image.asset('image/CCTVButton.png');
    getBytesFromAsset('image/CCTV.png', 70).then((BitmapDescriptor value) => cctvMarkerImage = value);
    getBytesFromAsset('image/kidLocation.png', 80).then((BitmapDescriptor value) => kidLocationMarkerImage = value);

    Map<String, dynamic> data;
    timer = Timer.periodic(Duration(seconds : 3), (Timer t) async {
      data = await kidsLocationGet( 0, kidsId );
        try{
          if(data['status'] == false )
            t.cancel();
          else{
            if(data==null){
                print("ThirdPage: 아이 현재 위치 없지롱."); //snackbar 하거나 3초 정도의 alert 박스를 넣는것이 좋을 것 같다고 생각함.
            }
            else{
              _markers.removeWhere( (m) => m.markerId.value == 'kidslocation');
              _markers.add(Marker(
                markerId: MarkerId('kidslocation'),
                position: LatLng( data['lat'], data['lon'] ),
                icon: kidLocationMarkerImage,
              ));
              setState(() {       });
              }     
            }
          }
          catch(e){}
    });
  }

  @override
  Widget build(BuildContext context) {
    //int kidsId = ModalRoute.of(context).settings.arguments;
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
            minHeight: 110,
            color: Color(0xfffefad1),
            borderRadius: radius,
            panelBuilder: (ScrollController sc) => _scrollingList(sc, context),
            controller: panelController,
          ),
          Container(
            alignment: Alignment.bottomRight,
            width : MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.7,
            child : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  //width : MediaQuery.of(context).size.width * 0.1,
                  child : FloatingActionButton(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child:cctvButtonImage ),
                    backgroundColor: Color(0xfffefad1),
                    onPressed: () async {
                      if(visableCCTV)
                        _markers.removeWhere((m) => m.markerId.value.contains('cctvLocation'));
                      else
                        for(var iter in cctvLocation)
                          _markers.add(Marker(
                          markerId: MarkerId('cctvLocation '+ _markers.length.toString()),
                          position: iter,
                          icon: cctvMarkerImage));
                      visableCCTV = !visableCCTV;
                      setState(() { });
                    }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose(){
    super.dispose();
    timer.cancel();
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
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text( "      "+snapshot.data[index].date, style: TextStyle(fontFamily: 'BMJUA',color: Color(0xffe09a4f),fontWeight: FontWeight.bold)),
                    SizedBox(height: 7,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(width: 15,),
                            Column(
                              children: <Widget>[
                                Icon(Icons.account_circle,color: Color(0xfff3b92b),size: 10,),
                                Icon(Icons.more_vert,color: Color(0xfff3b92b),),
                                Icon(Icons.room,color: Color(0xfff3b92b),size: 10,),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text( snapshot.data[index].source , style: TextStyle(fontFamily: 'BMJUA',color: Colors.black54) ),
                                SizedBox(height: 15,),
                                Text( snapshot.data[index].destination, style: TextStyle(fontFamily: 'BMJUA',color: Colors.black54)),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all( Radius.circular(15) ),
                                border: Border.all(
                                  color: Color(0xfff3b92b),
                                  width: 2.0,
                                ),
                                color: Colors.white,
                              ),
                              child: Icon(Icons.room, color: Color(0xfff3b92b), size: 35,),
                            ),
                            SizedBox(width: 15,)
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                onTap: () async{
                  //print( snapshot.data[index].polygon );
                  polylines.clear();
                  points.clear();
                  List<String> a = snapshot.data[index].polygon.split(',');
                  for(int i=0; i<(a.length+1)/2; i=i+2){
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
                    zoom: 16.9,
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

    Future<BitmapDescriptor> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    Uint8List result = (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
    return BitmapDescriptor.fromBytes(result);
  }

  Future<void> getCCTV() async {
    http.Response response = await http.get("http://3.34.194.177:8088/secret/api/cctv");
    Map responseJson = jsonDecode(response.body);
    for (var iter in responseJson["data"])
      cctvLocation.add(LatLng(double.parse(iter["lat"]), double.parse(iter["lon"])));
  }
}
