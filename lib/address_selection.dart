import 'package:cheezechoice/navigation_menu.dart';
import 'package:cheezechoice/nodelivery.dart';
import 'package:cheezechoice/utils/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocationSearchScreen extends StatefulWidget {
  @override
  _LocationSearchScreenState createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  LatLng? selectedLocation;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    _checkSavedLocation();
  }

  Future<void> _checkSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final latitude = prefs.getDouble('latitude');
    final longitude = prefs.getDouble('longitude');
    if (latitude != null && longitude != null) {
      // Check for restaurant availability
      _checkRestaurantAvailability(latitude, longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(16.4971, 80.4992),
              zoom: 8,
            ),
            onMapCreated: (controller) {
              mapController = controller;
            },
            onTap: _onMapTapped,
            markers: selectedLocation != null
                ? {
                    Marker(
                      markerId: MarkerId('selectedLocation'),
                      position: selectedLocation!,
                    ),
                  }
                : {},
          ),
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search for a place",
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: _searchLocation,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onMapTapped(LatLng location) async {
    setState(() {
      selectedLocation = location;
    });
    try {
      String address = await getAddressFromCoordinates(location.latitude, location.longitude);
      print("Selected Address: $address");
      // Check for restaurant availability
      _checkRestaurantAvailability(location.latitude, location.longitude);
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  Future<void> _searchLocation() async {
    if (_searchController.text.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(_searchController.text);
      if (locations.isNotEmpty) {
        final location = locations.first;
        mapController?.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(location.latitude, location.longitude),
          14,
        ));
      }
    } catch (e) {
      print("Error searching location: $e");
    }
  }

  Future<void> _checkRestaurantAvailability(double latitude, double longitude) async {
    final response = await http.get(Uri.parse('$dbLink/restaurant/location?lat=$latitude&long=$longitude'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        // Restaurants are available
        _navigateToNavigationMenu();
      } else {
        // No restaurants available
        _navigateToNoDeliveryAvailable();
      }
    } else {
      print("Error fetching restaurant data: ${response.statusCode}");
    }
  }

  void _navigateToNavigationMenu() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NavigationMenu()),
    );
  }

  void _navigateToNoDeliveryAvailable() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NoDeliveryAvailableScreen()),
    );
  }
}

Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
  if (placemarks.isNotEmpty) {
    return "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}";
  }
  return "No address found";
}