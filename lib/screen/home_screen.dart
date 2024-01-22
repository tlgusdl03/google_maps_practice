import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_proj/const/data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = MyAppKey;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<PointLatLng> results = PolylinePoints().decodePolyline(
        '{wqcFov`dW??RFXHDBb@L????YbB????l@T????RF????AFu@xDSbB????DB????EC????RcBt@yD@G????SG????m@U????XcB????c@MECYISG??');

    Set<Marker> MarkerRender() {
      setState(() {
        _addMarker(LatLng(results[0].latitude, results[0].longitude), "origin",
            BitmapDescriptor.defaultMarker);
        _addMarker(
            LatLng(results[results.length - 1].latitude,
                results[results.length - 1].longitude),
            "destination",
            BitmapDescriptor.defaultMarker);
      });
      return Set<Marker>.of(markers.values);
    }

    Set<Polyline> PolylineRender() {
      setState(() {
        for (int i = 0; i < results.length - 1; i++) {
          _getPolyline(results[i].latitude, results[i].latitude,
              results[i + 1].latitude, results[i + 1].latitude);
        }
      });
      return Set<Polyline>.of(polylines.values);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Center(
              child: Container(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(results[0].latitude, results[0].longitude),
                    zoom: 16.00,
                  ),
                  myLocationEnabled: true,
                  tiltGesturesEnabled: true,
                  compassEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: _onMapCreated,
                  markers: MarkerRender(),
                  polylines: PolylineRender(),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                child: Text('${results}'),
              ))
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    //setState(() {});
  }

  _getPolyline(double originlat, double originlng, double destlat,
      double destlng) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(originlat, originlng),
      PointLatLng(destlat, destlng),
      travelMode: TravelMode.walking,
    );
    _addPolyLine();
  }
}
