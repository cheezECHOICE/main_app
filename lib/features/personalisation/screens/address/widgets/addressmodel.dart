import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food/utils/formatters/formatter.dart';

class AddressModel {
  String id;
  final String name;
  final String phonenumber;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final DateTime? datetime;
  bool selectedAddress;

  AddressModel(
      {required this.name,
      required this.phonenumber,
      required this.street,
      required this.city,
      required this.state,
      required this.postalCode,
      required this.country,
      this.selectedAddress = true,
      this.datetime,
      required this.id});

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phonenumber);

  static AddressModel empty() => AddressModel(
      name: '',
      phonenumber: '',
      street: '',
      city: '',
      state: '',
      postalCode: '',
      country: '',
      id: '');

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'PhoneNumber': phonenumber,
      'Street': street,
      'City': city,
      'State': state,
      'PostalCode': postalCode,
      'Country': country,
      'DateTime': DateTime.now(),
      'SelectedAddress': selectedAddress,
    };
  }

  AddressModel copyWith({
    String? id,
    String? name,
    String? phonenumber,
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    DateTime? datetime,
    bool? selectedAddress,
  }) {
    return AddressModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phonenumber: phonenumber ?? this.phonenumber,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      datetime: datetime ?? this.datetime,
      selectedAddress: selectedAddress ?? this.selectedAddress,
    );
  }

  factory AddressModel.fromMap(Map<String, dynamic> data) {
    return AddressModel(
        id: data['Id'] as String,
        name: data['Name'] as String,
        phonenumber: data['PhoneNumber'] as String,
        street: data['Street'] as String,
        city: data['City'] as String,
        state: data['State'] as String,
        postalCode: data['PostalCode'] as String,
        country: data['Country'] as String,
        selectedAddress: data['SelectedAddress'] as bool,
        datetime: (data['DataTime'] as Timestamp).toDate());
  }

  // Factory contructor to create an AddressModel from a DocumentSnapshot
  factory AddressModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return AddressModel(
      id: snapshot.id,
      name: data['Name'] ?? '',
      phonenumber: data['PhoneNumber'] ?? '',
      street: data['Street'] ?? '',
      city: data['City'] ?? '',
      state: data['State'] ?? '',
      postalCode: data['PostalCode'] ?? '',
      country: data['Country'] ?? '',
      datetime: (data['DateTime'] as Timestamp).toDate(),
      selectedAddress: data['SelectedAddress'] as bool,
    );
  }

  @override
  String toString() {
    return '$street, $city, $state, $state, $postalCode, $country';
  }
}
