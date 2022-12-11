import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const double _defaultLat = 8.85577417427599;
  static const double _defaultLng = 38.81151398296511;
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(_defaultLat, _defaultLng), zoom: 15);

  late final GoogleMapController _googleMapController;
  MapType _currentMapType = MapType.normal;

  final Set<Marker> _markers = {};

  void _changeMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _addMarker() {
    setState(() {
      _markers.add(Marker(
          markerId: const MarkerId('default Location'),
          position: _initialCameraPosition.target,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(
            title: '',
            snippet: '',
          )));
    });
  }

  Future<void> _moveToNewLocation() async {
    const _newPosition = LatLng(40.7128, -74.0060);
    _googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(_newPosition, 15));
    setState(() {
      const marker = Marker(
        markerId: MarkerId('newLocation'),
        position: _newPosition,
        infoWindow: InfoWindow(title: 'New York', snippet: 'best place'),
      );
      _markers
        ..clear()
        ..add(marker);
    });
  }

  Future<void> _goToDefaultLocation() async {
    const _defaultPositon = LatLng(_defaultLat, _defaultLng);
    _googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(_defaultPositon, 15));
    setState(() {
      const marker = Marker(
          markerId: MarkerId('location(default)'),
          position: _defaultPositon,
          infoWindow: InfoWindow(title: 'Home', snippet: 'place'));

      _markers
        ..clear()
        ..add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GOOGLE MAP'),
        centerTitle: true,
      ),
      body: Stack(children: <Widget>[
        GoogleMap(
          onMapCreated: (controller) => _googleMapController = controller,
          initialCameraPosition: _initialCameraPosition,
          mapType: _currentMapType,
          markers: _markers,
        ),
        Container(
          padding: EdgeInsets.only(right: 12, left: 24),
          alignment: Alignment.topRight,
          child: Column(
            children: <Widget>[
              FloatingActionButton(
                  backgroundColor: Colors.green,
                  child: const Icon(
                    Icons.map,
                    size: 30,
                  ),
                  onPressed: _changeMapType),
              const SizedBox(
                height: 20,
              ),
              FloatingActionButton(
                onPressed: _addMarker,
                backgroundColor: Colors.deepPurple,
                child: Icon(
                  Icons.add_location,
                  size: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FloatingActionButton(
                onPressed: _moveToNewLocation,
                backgroundColor: Colors.indigo,
                child: Icon(
                  Icons.location_city,
                  size: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FloatingActionButton(
                onPressed: _goToDefaultLocation,
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.home_rounded,
                  size: 30,
                ),
              ),
            ],
          ),
        )
      ]),
     );
  }
}
