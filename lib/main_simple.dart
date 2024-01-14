import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MapController controller = MapController(
    initPosition: GeoPoint(
      latitude: 47.4358055,
      longitude: 8.4737324,
    ),
  );

  requestForLocation() async {

    final wsUrl = Uri.parse('ws://flutter-test.iran.liara.run/ws/locations');
    final channel = WebSocketChannel.connect(wsUrl);

    await channel.ready;

    channel.stream.listen((message) {
      double lat = double.parse(message.toString().split(',')[0]);
      double lon = double.parse(message.toString().split(',')[1]);
      controller.goToLocation(GeoPoint(latitude: lat,longitude: lon));
      controller.addMarker(GeoPoint(latitude: lat,longitude: lon),markerIcon: const MarkerIcon(
        icon: Icon(
          Icons.location_on,
          color: Colors.red,
          size: 32,
        ),
      ));
      channel.sink.add('received!');
      channel.sink.close(status.goingAway);
      controller.geopoints.then((List<GeoPoint> geoPoints) {
        int length = geoPoints.length;
        if(length<3) {
          requestForLocation();
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title , style: const TextStyle( fontWeight: FontWeight.bold),),
      ),
      body:Stack(
        children: [


          OSMFlutter(
            controller: controller,
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
                onTap: (){controller.zoomIn();},
              ),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.only(left: 10 , top:10 ),
                  width: 50 , height: 50  ,
                  decoration: BoxDecoration( color: Colors.black, shape: BoxShape.circle , border: Border.all(color: Colors.white)),
                  child: const Icon(Icons.zoom_out , color: Colors.white,size: 30,),
                ),
                onTap: (){controller.zoomOut();},
              ),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.only(left: 10 , top:10 ),
                  width: 50 , height: 50  ,
                  decoration: BoxDecoration( color: Colors.black, shape: BoxShape.circle , border: Border.all(color: Colors.white)),
                  child: const Icon(Icons.clear_all_outlined , color: Colors.white,size: 30,),
                ),
                onTap: (){controller.geopoints.then((value) => controller.removeMarkers(value));},
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        requestForLocation();
      }, child: const Icon(Icons.add_location),),
      // This trailing comma makes auto-formatting nicer for build methods.
    );

  }
}
