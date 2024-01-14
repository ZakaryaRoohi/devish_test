import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class HomeController extends GetxController {
  late MapController mapController;

  @override
  Future<void> onInit() async {
    super.onInit();
    mapController = MapController(
      initPosition: GeoPoint(
        latitude: 47.4358055,
        longitude: 8.4737324,
      ),
    );

    Future.delayed(const Duration(seconds: 2)).then((value) => requestForLocation());
  }

  requestForLocation() async {
    final wsUrl = Uri.parse('ws://flutter-test.iran.liara.run/ws/locations');
    final channel = WebSocketChannel.connect(wsUrl);

    await channel.ready;

    channel.stream.listen((message) {
      double lat = double.parse(message.toString().split(',')[0]);
      double lon = double.parse(message.toString().split(',')[1]);
      mapController.goToLocation(GeoPoint(latitude: lat, longitude: lon));
      mapController.addMarker(GeoPoint(latitude: lat, longitude: lon),
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 32,
            ),
          ));
      update();
      channel.sink.add('received!');
      channel.sink.close(status.goingAway);
      mapController.geopoints.then((List<GeoPoint> geoPoints) {
        int length = geoPoints.length;
        if (length < 3) {
          requestForLocation();
        }
      });
    });
  }
}
