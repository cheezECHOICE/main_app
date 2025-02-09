import 'package:cheezechoice/utils/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class LocationSearchScreen extends StatefulWidget {
  @override
  _LocationSearchScreenState createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 18),
            const Text(
              "Find restaurants near you",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Please enter your location or allow access to your location to find restaurants near you.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                // Implement current location logic
              },
              icon: const Icon(Icons.my_location, color: Colors.purple),
              label: const Text("Use current location"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.purple, backgroundColor: Colors.white,
                side: BorderSide(color: Colors.purple),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size.fromHeight(50), // Match the height
              ),
            ),
            const SizedBox(height: 20),
            GooglePlaceAutoCompleteTextField(
              textEditingController: _controller,
              googleAPIKey:'${MAP_API}',
              inputDecoration: InputDecoration(
                hintText: "Enter a new address",
                prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              debounceTime: 400,
              isLatLngRequired: false,
              getPlaceDetailWithLatLng: (prediction) {
                print("Selected Place: ${prediction.description}");
              },
            ),
          ],
        ),
      ),
    );
  }
}