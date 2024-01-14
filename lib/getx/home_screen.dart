import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeController getController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Devish Test App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          GetBuilder(builder: (HomeController controller){
            return OSMFlutter(
              controller: getController.mapController,
              mapIsLoading: const Center(
                child: CircularProgressIndicator(),
              ),
              osmOption: const OSMOption(
                enableRotationByGesture: true,
                zoomOption: ZoomOption(
                  initZoom: 14,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
                ),
                showContributorBadgeForOSM: true,
                showDefaultInfoWindow: false,
              ),
            );
          }),
          Column(
            children: [
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.only(left: 10, top: 20),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white)),
                  child: const Icon(
                    Icons.zoom_in,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                onTap: () {
                  getController.mapController.zoomIn();
                },
              ),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white)),
                  child: const Icon(
                    Icons.zoom_out,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                onTap: () {
                  getController.mapController.zoomOut();
                },
              ),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white)),
                  child: const Icon(
                    Icons.clear_all_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                onTap: () {
                  getController.mapController.geopoints.then((value) =>
                      getController.mapController.removeMarkers(value));
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getController.requestForLocation();
        },
        child: const Icon(Icons.add_location),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
