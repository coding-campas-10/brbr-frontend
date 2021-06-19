import 'dart:async';
import 'dart:typed_data';
import 'package:brbr/constants/colors.dart';
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
  int? _selectedStationId;
  List<StationLocation>? stationLocations;
  Station? _selectedStation;

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
              onTap: () async {
                _selectedStationId = stationLocation.stationId;
                _selectedStation = await BRBRService.getDetailStation(_selectedStationId!);
                print(_selectedStation!.stationName);
                setState(() {});
              },
              icon: BitmapDescriptor.fromBytes(_selectedStationId == stationLocation.stationId ? _selectedMarkerIcon : _markerIcon),
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
        Builder(
          builder: (context) {
            if (_selectedStation != null) {
              print('builder:' + _selectedStation!.stationName);
              return Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: StationFloatingCard(_selectedStation!),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}

class StationFloatingCard extends StatelessWidget {
  final Station station;
  StationFloatingCard(this.station);

  @override
  Widget build(BuildContext context) {
    print('card builded ${station.stationName}');
    return BRBRCard(
      padding: EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(station.stationName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 16),
              Text(station.description, style: TextStyle(color: BRBRColors.secondaryText)),
              SizedBox(height: 4),
              Text('매주 월, 목, 토 10:00 수거', style: TextStyle(color: BRBRColors.secondaryText)),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Text('68m', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: BRBRColors.highlight)),
          ),
        ],
      ),
    );
  }
}
