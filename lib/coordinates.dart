// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
//   final apiKey = "AIzaSyBTT0AM4Kw53oiOccAhzMDS41DZwOC0IcY";
//   final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

//   final response = await http.get(Uri.parse(url));

//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     if (data['results'].isNotEmpty) {
//       return data['results'][0]['formatted_address'];
//     } else {
//       return 'No address found';
//     }
//   } else {
//     throw Exception('Failed to load address');
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
  final apiKey = "AIzaSyBTT0AM4Kw53oiOccAhzMDS41DZwOC0IcY";
  final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['results'].isNotEmpty) {
      final result = data['results'][0];
      final addressComponents = result['address_components'];

      // Construct a more complete address using address components
      String street = '';
      String city = '';
      String country = '';

      for (var component in addressComponents) {
        if (component['types'].contains('route')) {
          street = component['long_name'];
        } else if (component['types'].contains('locality')) {
          city = component['long_name'];
        } else if (component['types'].contains('country')) {
          country = component['long_name'];
        }
      }

      return '$street, $city, $country';
    } else {
      return 'No address found';
    }
  } else {
    throw Exception('Failed to load address');
  }
}