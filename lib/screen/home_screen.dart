import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_proj/const/data.dart';


final List<PointLatLng> results = PolylinePoints().decodePolyline(
    '{wqcFov`dW??RFXHDBb@L????YbB????l@T????RF????AFu@xDSbB????DB????EC????RcBt@yD@G????SG????m@U????XcB????c@MECYISG??');
final List<LatLng> resultList = results.map((point) {
  return LatLng(point.latitude, point.longitude);
}).toList();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};

  @override
  void initState() {
    drawPolylines();
    drawMarkers();
    super.initState();
    print('출발지 좌표: ${resultList[0]}');
    print('도착지 좌표: ${resultList[resultList.length-1]}');
  }

  drawPolylines() async {
    polylines.add(
      Polyline(
        polylineId: PolylineId(
          resultList[0].toString(),
        ),
        visible: true,
        width: 5,
        points: resultList,
        color: Colors.blue,
      ),
    );
    setState(() {});
  }

  drawMarkers() async {
    markers.add(
      Marker(
        markerId: MarkerId("origin"),
        visible: true,
        icon: BitmapDescriptor.defaultMarker,
        position: resultList[0],
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId("destination"),
        icon: BitmapDescriptor.defaultMarker,
        position: resultList[resultList.length - 1],
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("구글 맵 테스트"),
        backgroundColor: Colors.white,
      ),
      body: GoogleMap(
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: resultList[0],
          zoom: 14.0,
        ),
        polylines: polylines,
        markers: markers,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          setState(
            () {
              mapController = controller;
            },
          );
        },
      ),
    );
  }
}
