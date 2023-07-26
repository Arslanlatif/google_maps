import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

List<Placemark> addresses = [];

class _GoogleMapsState extends State<GoogleMaps> {
  late Completer<GoogleMapController> googleController =
      Completer<GoogleMapController>();

  Placemark first = Placemark();

// Markers for position
  List<Marker> list = [
    const Marker(
        infoWindow: InfoWindow(title: 'Initial Location'),
        position: LatLng(33.70140894534099, 73.04071618947549),
        markerId: MarkerId('1')),
  ];

// To get Current Location of user
  Future<Position?> getCurentPosition() async {
    try {
      await Geolocator.requestPermission()
          .then((value) {})
          .onError((error, stackTrace) async {
        await Geolocator.requestPermission();
      });
      return Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepOrange,
        appBar: AppBar(
            backgroundColor: Colors.deepOrangeAccent,
            title: const Text('Google Maps')),
        body: Stack(children: [
          GoogleMap(
            // To add the initial value if you want
            initialCameraPosition: const CameraPosition(
                target: LatLng(33.70140, 73.04071), zoom: 15),
            onMapCreated: (controllerr) {
              googleController.complete(controllerr);
            },
            myLocationEnabled: true,
            mapType: MapType.hybrid,
            markers: Set<Marker>.of(list),
          ),
          Positioned(
            top: 550,
            left: 10,
            child: FloatingActionButton(
                backgroundColor: Colors.deepOrange,
                onPressed: () {
                  getCurentPosition().then((value) async {
                    // To add Current Marker and move the camera
                    list.add(Marker(
                        position: LatLng(value!.latitude, value.longitude),
                        infoWindow: const InfoWindow(title: 'Current Location'),
                        markerId: const MarkerId("2")));

                    final GoogleMapController controller =
                        await googleController.future;
                    controller.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: LatLng(value.latitude, value.longitude),
                            zoom: 20)));

                    // TO get the address of current Location
                    addresses = await placemarkFromCoordinates(
                        value.latitude, value.longitude);

                    first = addresses.first;

                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "${first.street}, ${first.postalCode}, ${first.subLocality}, ${first.locality}, ${first.administrativeArea}, ${first.country}")));

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, first);
                    setState(() {});
                  });
                },
                child: const Icon(Icons.location_on)),
          ),
        ]),
      ),
    );
  }
}
