import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:restaurant_app/global_components/components.dart';
import 'package:restaurant_app/models/restaurant.dart';

class RestaurantMapScreen extends StatefulWidget {
  const RestaurantMapScreen({Key? key, required this.restaurants}) : super(key: key);
  final List<Restaurant> restaurants;

  @override
  State<RestaurantMapScreen> createState() => _RestaurantMapScreenState();
}

class _RestaurantMapScreenState extends State<RestaurantMapScreen> {
  MapController controller = MapController(
      location: LatLng(
    55.81,
    30.45,
  ));

  late Position _myPosition = Position(
      latitude: 45.32,
      longitude: 24.24,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

  List<LatLng> markers = [];

  void _gotoDefault() {
    controller.center = LatLng(_myPosition.latitude, _myPosition.longitude);
    setState(() {});
  }

  void _onDoubleTap() {
    controller.zoom += 0.5;
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  Widget _buildRestaurantMarkerWidget(Offset pos, Color color, Restaurant restaurant) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      width: 30,
      height: 30,
      child: GestureDetector(
        child: Icon(Icons.location_on, color: color),
        onTap: () {
          showAlert(context, restaurant);
        },
      ),
    );
  }

  Widget _buildMarkerWidget(Offset pos, Color color) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      width: 30,
      height: 30,
      child: Icon(Icons.location_on, color: color),
    );
  }

  @override
  void initState() {
    getMyLocation();

    for (Restaurant res in widget.restaurants) {
      markers.add(LatLng(
        double.parse(res.location == null ? "0" : res.location!.latitude!.toString()),
        double.parse(res.location == null ? "0" : res.location!.longitude!.toString()),
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
      ),
      body: MapLayoutBuilder(
        controller: controller,
        builder: (context, transformer) {
          final markerPositions = markers.map(transformer.fromLatLngToXYCoords).toList();

          List<Widget> markerWidgets = [];
          for (int i = 0; i < widget.restaurants.length; i++) {
            markerWidgets.add(_buildRestaurantMarkerWidget(
                markerPositions[i], Colors.red, widget.restaurants[i]));
          }

          final homeLocation =
              transformer.fromLatLngToXYCoords(LatLng(_myPosition.latitude, _myPosition.longitude));

          final homeMarkerWidget = _buildMarkerWidget(
            homeLocation,
            Colors.black,
          );

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: _onDoubleTap,
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final delta = event.scrollDelta;

                  controller.zoom -= delta.dy / 1000.0;
                  setState(() {});
                }
              },
              child: Stack(
                children: [
                  Map(
                    controller: controller,
                    builder: (context, x, y, z) {
                      final url =
                          'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';
                      return CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  homeMarkerWidget,
                  ...markerWidgets,
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoDefault,
        tooltip: 'My Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }

  void getMyLocation() async {
    _myPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      controller = MapController(
        location: LatLng(_myPosition.latitude, _myPosition.longitude),
      );
    });
  }
}
