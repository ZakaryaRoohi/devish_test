import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class LocationEvent {}

class RequestLocationEvent extends LocationEvent {}

class LocationState {
  final List<GeoPoint> geoPoints;

  LocationState(this.geoPoints);
}

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final MapController controller = MapController(
    initPosition: GeoPoint(
      latitude: 47.4358055,
      longitude: 8.4737324,
    ),
  );

  final WebSocketChannel channel;

  LocationBloc(this.channel) : super(LocationState([]));

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    if (event is RequestLocationEvent) {
      await channel.ready;

      await for (var message in channel.stream) {
        double lat = double.parse(message.toString().split(',')[0]);
        double lon = double.parse(message.toString().split(',')[1]);
        controller.goToLocation(GeoPoint(latitude: lat, longitude: lon));
        controller.addMarker(GeoPoint(latitude: lat, longitude: lon), markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.location_on,
            color: Colors.red,
            size: 32,
          ),
        ));
        channel.sink.add('received!');
        channel.sink.close(status.goingAway);

        // Await the result of controller.geopoints
        List<GeoPoint> geoPoints = await controller.geopoints;

        int length = geoPoints.length;
        if (length < 3) {
          add(RequestLocationEvent());
        }

        // Yield the result
        yield LocationState(geoPoints);
      }
    }
  }
}

