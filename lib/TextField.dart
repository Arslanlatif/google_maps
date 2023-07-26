import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'googleMaps.dart';

class TextFields extends StatefulWidget {
  const TextFields({super.key});

  @override
  State<TextFields> createState() => _TextFieldsState();
}

class _TextFieldsState extends State<TextFields> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Location'),
        ),
        body: Material(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: TextFormField(
                decoration: InputDecoration(
                    label: const Text('Location'),
                    suffixIcon: IconButton(
                        onPressed: () async {
                          Placemark placemark = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GoogleMaps(),
                              ));
                          controller.text =
                              "${placemark.street}, ${placemark.postalCode}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
                          setState(() {});
                        },
                        icon: const Icon(Icons.location_on)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40))),
                controller: controller,
              ),
            ),
          ),
        ));
  }
}
