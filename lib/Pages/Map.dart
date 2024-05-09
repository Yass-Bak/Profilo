import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapScreenState();
}

class _MapScreenState extends State<Map> {
  GoogleMapController? mapController;
  final Set<Marker> markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addMarker() {
    final marker = Marker(
      markerId: const MarkerId("new-marker"),
      position: const LatLng(43.6500, -79.3800), // Toronto, Canada
      infoWindow: const InfoWindow(
        title: 'New Marker',
        snippet: 'Interesting place',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    );

    setState(() {
      markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore the Map'),
        backgroundColor: Colors.black12,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(43.6476246, -79.3954849),
          zoom: 10.0,
        ),
        markers:
        {
        Marker(
        markerId: MarkerId(
        'Shopify'),
        infoWindow: InfoWindow(title: 'Shopify'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueAzure),
        position: LatLng(43.6476246,-79.3954849),
        ),
        Marker(
        markerId: MarkerId('Top Hat'),
        infoWindow: InfoWindow(title: 'Top Hat'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueAzure),
        position: LatLng(43.6700798,-79.3892593),
        ),
        Marker(
        markerId: MarkerId('Kira Systems'),
        infoWindow: InfoWindow(title: 'Kira Systems'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueAzure),
        position: LatLng(43.6485557,-79.3892822),
        ),
        Marker(
        markerId: MarkerId('Ritual Technologies'),
        infoWindow: InfoWindow(title: 'Ritual Technologies'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueAzure),
        position: LatLng(43.6525269,-79.3819428),
        ),
        Marker(
        markerId: MarkerId('A3Logics'),
        infoWindow: InfoWindow(title: 'A3Logics'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueAzure),
        position: LatLng(26.9124336,75.7872709 ),
        ),
        Marker(
        markerId: MarkerId('Datarockets'),
        infoWindow: InfoWindow(title: '750 Lexington Ave #12-125, New York City'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueAzure),
        position: LatLng(40.7580277,-73.9855547),
        ),
        Marker(
        markerId: MarkerId('Datarockets'),
        infoWindow: InfoWindow(title: '80 Queens Wharf Rd #1015, Toronto'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueAzure),
        position: LatLng(43.6629295,-79.3957348),
        )
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMarker,
        tooltip: 'Add Marker',
        child: Icon(Icons.add_location_alt_rounded),
        backgroundColor: Colors.white,
      ),
    );
  }
}