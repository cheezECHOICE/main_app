import 'package:cheezechoice/utils/local_storage/storage_utility.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_storage/get_storage.dart';

class LocationSearchScreen extends StatefulWidget {
  @override
  _LocationSearchScreenState createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _manualAddressController = TextEditingController();
  final TLocalStorage localStorage = TLocalStorage.instance();
  LatLng? selectedLocation;
  String? selectedAddress;
  List<String> savedAddresses = [];
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
  }

  Future<void> _loadSavedAddresses() async {
    final addresses = localStorage.readData<List<String>>('savedAddresses') ?? [];
    setState(() {
      savedAddresses = addresses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(16.4971,80.4992),
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
          Positioned(
            bottom: 140,
            left: 20,
            right: 20,
            child: TextField(
              controller: _manualAddressController,
              decoration: InputDecoration(
                hintText: "Specify Block no/Street name",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _saveAddress,
              child: Text("Save Address"),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _showSavedAddresses,
              child: Text("Show My Addresses"),
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
      setState(() {
        selectedAddress = address;
      });
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

  Future<void> _saveAddress() async {
    if (selectedAddress != null) {
      String fullAddress = '${_manualAddressController.text}, $selectedAddress';
      savedAddresses.add(fullAddress);
      await localStorage.saveData('savedAddresses', savedAddresses);
      setState(() {});
      print("Address saved: $fullAddress");
    } else {
      print("No address selected to save");
    }
  }

  void _showSavedAddresses() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "Saved Addresses",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: savedAddresses.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(savedAddresses[index]),
                          onDismissed: (direction) {
                            setState(() {
                              savedAddresses.removeAt(index);
                              localStorage.saveData('savedAddresses', savedAddresses);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Address deleted")),
                            );
                          },
                          background: Container(color: Colors.red),
                          child: Card(
                            child: ListTile(
                              title: Text(savedAddresses[index]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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