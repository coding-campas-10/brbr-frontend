import 'package:brbr/constants/colors.dart';
import 'package:brbr/models/brbr_station.dart';
import 'package:brbr/models/location_provider.dart';
import 'package:brbr/services/brbr_service.dart';
import 'package:brbr/widgets/brbr_card.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class NearestStation extends StatelessWidget {
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
    context.read<LocationProvider>().requestPermissionAndService();
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        print('locationProvider Consumer build');
        return FutureBuilder(
          future: locationProvider.isLocationAvailable(),
          builder: (context, locationServiceStatus) {
            return Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: BRBRCard(
                  onTab: () async {
                    if (locationServiceStatus.data == LocationServiceStatus.GPSDisabled) {
                      await locationProvider.requestPermissionAndService();
                    }
                    if (locationServiceStatus.data == LocationServiceStatus.PermissionNotAllowd) {
                      await locationProvider.requestPermissionAndService();
                    }
                  },
                  child: Stack(
                    children: [
                      Stack(
                        fit: StackFit.expand,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('내 주변 스테이션', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(height: 16),
                              Builder(
                                builder: (context) {
                                  LocationData? locationData = locationProvider.locationData;
                                  LocationServiceStatus? status = locationServiceStatus.data as LocationServiceStatus?;
                                  if (status == null) {
                                    return Text('--');
                                  }
                                  if (locationData == null) {
                                    String text;
                                    if (status == LocationServiceStatus.GPSDisabled || status == LocationServiceStatus.Disabled) {
                                      text = 'GPS를 켜주세요';
                                    } else {
                                      text = '정확한 위치 권한을 허용해주세요';
                                    }
                                    return Text(text);
                                  } else {
                                    return FutureBuilder(
                                      future: BRBRService.getNearestStation(locationProvider.locationData!.longitude!, locationProvider.locationData!.latitude!),
                                      builder: (context, snapshot) {
                                        print('future builder builded');
                                        Station? station = snapshot.data as Station?;
                                        if (station != null) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _formatDistance(station.distanceFrom(locationProvider.locationData!.latitude!, locationProvider.locationData!.longitude!)),
                                                style: TextStyle(color: BRBRColors.highlight, fontSize: 34, fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(height: 2),
                                              Text(station.stationName, style: TextStyle(fontSize: 12)),
                                            ],
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          Positioned(child: Icon(Icons.arrow_forward_ios, size: 18), right: 0, bottom: 0),
                        ],
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
