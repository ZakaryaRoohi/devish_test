import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:web_socket_channel/io.dart'; // Import 'io.dart' for WebSocket communication


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';

import 'location_bloc.dart'; // Import 'io.dart' for WebSocket communication


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Devish',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple ,),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Devish test App' ,),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final LocationBloc locationBloc = LocationBloc(IOWebSocketChannel.connect('ws://flutter-test.iran.liara.run/ws/locations'));

    return BlocProvider(
      create: (context) => locationBloc,
      child: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              // ... (unchanged code)
            ),
            body: Stack(
              children: [
              OSMFlutter(
              controller: locationBloc.controller,
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
            ),
            Column(
              children: [
                GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10 , top:20 ),
                    width: 50 , height: 50  ,
                    decoration: BoxDecoration( color: Colors.black, shape: BoxShape.circle , border: Border.all(color: Colors.white)),
                    child: const Icon(Icons.zoom_in , color: Colors.white,size: 30,),
                  ),
                  onTap: (){ locationBloc.controller.zoomIn();},
                ),
                GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10 , top:10 ),
                    width: 50 , height: 50  ,
                    decoration: BoxDecoration( color: Colors.black, shape: BoxShape.circle , border: Border.all(color: Colors.white)),
                    child: const Icon(Icons.zoom_out , color: Colors.white,size: 30,),
                  ),
                  onTap: (){ locationBloc.controller.zoomOut();},
                ),
                GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10 , top:10 ),
                    width: 50 , height: 50  ,
                    decoration: BoxDecoration( color: Colors.black, shape: BoxShape.circle , border: Border.all(color: Colors.white)),
                    child: const Icon(Icons.clear_all_outlined , color: Colors.white,size: 30,),
                  ),
                  onTap: (){ locationBloc.controller.geopoints.then((value) =>  locationBloc.controller.removeMarkers(value));},
                ),
              ],
            ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                locationBloc.add(RequestLocationEvent());
              },
              child: const Icon(Icons.add_location),
            ),
          );
        },
      ),
    );
  }
}

