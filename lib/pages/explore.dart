import 'dart:async';
import 'dart:typed_data';
import 'package:brbr/models/brbr_station.dart';
import 'package:brbr/services/brbr_service.dart';
import 'package:brbr/widgets/brbr_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  Completer<GoogleMapController> _controller = Completer();
  late Uint8List _markerIcon, _selectedMarkerIcon;
  String? _selectedMarkerId;
  List<StationLocation>? stationLocations;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.20098932396427, 127.07942375504356),
    zoom: 14.4746,
  );

  Set<Marker> getMarkers() {
    if (stationLocations != null) {
      return stationLocations!
          .map(
            (stationLocation) => Marker(
              markerId: MarkerId(stationLocation.stationId.toString()),
              position: LatLng(stationLocation.latitude, stationLocation.longtitude),
              onTap: () {
                _selectedMarkerId = stationLocation.stationId.toString();
                setState(() {});
              },
              icon: BitmapDescriptor.fromBytes(_selectedMarkerId == stationLocation.stationId.toString() ? _selectedMarkerIcon : _markerIcon),
            ),
          )
          .toSet();
    } else {
      return Set();
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _markerIcon = await getBytesFromAsset('assets/brbr_map_marker.png', 200);
    _selectedMarkerIcon = await getBytesFromAsset('assets/brbr_map_marker_selected.png', 200);
    stationLocations = await BRBRService.getAllStations();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          mapToolbarEnabled: false,
          rotateGesturesEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          markers: getMarkers(),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        Positioned(
          bottom: 0,
          left: 16,
          right: 16,
          child: StationFloatingCard(),
        ),
      ],
    );
  }
}

class StationFloatingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BRBRCard(
      padding: EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('동탄'),
              Text('동탄'),
              Text('동탄'),
            ],
          ),
        ],
      ),
    );
  }
}
