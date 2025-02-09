import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TextEditingController searchController = TextEditingController();
  final List<Map<String, dynamic>> predefinedLocations = [
    {
      'id': '1',
      'name': 'KFC',
      'latitude': 16.4819,
      'longitude': 80.6186,
    },
    {
      'id': '2',
      'name': 'PIZZA HUT',
      'latitude': 16.4830,
      'longitude': 80.6184,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Map Page'),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.directions_car, color: Colors.green),
      //       onPressed: () {},
      //     ),
      //     IconButton(
      //       icon: Icon(Icons.directions_bus, color: Colors.red),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(16.4819, 80.6186),
          initialZoom: 14.5,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: predefinedLocations.map((location) {
              return Marker(
                point: LatLng(location['latitude'], location['longitude']),
                width: 100.0,
                height: 100.0,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(location['name']),
                        content: Text('Latitude: ${location['latitude']}\nLongitude: ${location['longitude']}'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Icon(Icons.location_on_sharp, color: Colors.red, size: 60),
                ),
              );
            }).toList(),
          ),
          Positioned(
            top: 70,
            left: 20,
            right: 20,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: TypeAheadField<Map<String, dynamic>>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Destination',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  return predefinedLocations.where((location) =>
                      location['name']
                          .toLowerCase()
                          .contains(pattern.toLowerCase())).toList();
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion['name']),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  // Move the map to the selected location
                  setState(() {
                    searchController.text = suggestion['name'];
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}