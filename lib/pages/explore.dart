import 'dart:async';
import 'dart:typed_data';
import 'package:brbr/constants/colors.dart';
import 'package:brbr/models/brbr_station.dart';
import 'package:brbr/models/location_provider.dart';
import 'package:brbr/services/brbr_service.dart';
import 'package:brbr/widgets/brbr_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:location/location.dart';
import 'package:provider/provider.dart';

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
    target: LatLng(37.34194, 126.831327),
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
    _markerIcon = await getBytesFromAsset('assets/brbr_map_marker.png', 240);
    _selectedMarkerIcon = await getBytesFromAsset('assets/brbr_map_marker_selected.png', 240);
    stationLocations = await BRBRService.getAllStations();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onTap: (argument) {
            setState(() {
              _selectedStation = null;
              _selectedStationId = null;
            });
          },
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          mapToolbarEnabled: false,
          rotateGesturesEnabled: false,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          markers: getMarkers(),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          myLocationEnabled: true,
        ),
        Builder(
          builder: (context) {
            if (_selectedStation != null) {
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

  String _formatDistance(double distacne) {
    if (distacne < 1000) {
      return distacne.toInt().toString() + 'm';
    }
    if (1000 <= distacne && distacne < 10000) {
      return (distacne ~/ 100 / 10).toString() + 'km';
    } else {
      return (distacne ~/ 1000).toString() + 'km';
    }
  }

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
            child: Consumer<LocationProvider>(
              builder: (context, locationProvider, child) {
                LocationData? locationData = locationProvider.locationData;
                String text;
                if (locationData != null) {
                  text = _formatDistance(station.distanceFrom(locationData.latitude!, locationData.longitude!));
                } else {
                  text = '--m';
                }
                return Text(text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: BRBRColors.highlight));
              },
            ),
          ),
        ],
      ),
    );
  }
}
