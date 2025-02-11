import 'package:cheezechoice/location_selection.dart';
import 'package:cheezechoice/utils/local_storage/storage_utility.dart';
import 'package:flutter/material.dart';
import 'package:cheezechoice/features/shop/controllers/product/order_controller.dart';
import 'package:get_storage/get_storage.dart';

class DeliveryAddressSection extends StatefulWidget {
  @override
  _DeliveryAddressSectionState createState() => _DeliveryAddressSectionState();
}

class _DeliveryAddressSectionState extends State<DeliveryAddressSection> {
  String? selectedAddress;
  bool isCustomAddress = false;
  TextEditingController customAddressController = TextEditingController();
  final TLocalStorage localStorage = TLocalStorage.instance();
  List<String> addresses = ["Select Address"]; // Initial option to open map

  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
  }

  Future<void> _loadSavedAddresses() async {
    final savedAddresses = localStorage.readData<List<String>>('savedAddresses') ?? [];
    setState(() {
      addresses.addAll(savedAddresses);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Location to deliver:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: selectedAddress,
            hint: Text("Choose an address"),
            onChanged: (String? newValue) {
              if (newValue == "Select Address") {
                _openMapScreen();
              } else {
                setState(() {
                  selectedAddress = newValue;
                  isCustomAddress = selectedAddress == "Other (Enter manually)";
                  if (!isCustomAddress && selectedAddress != null) {
                    OrderController.instance.setSelectedAddress(selectedAddress!);
                  }
                });
              }
            },
            items: addresses.map((String address) {
              return DropdownMenuItem<String>(
                value: address,
                child: Text(
                  address.length > 20 ? "${address.substring(0, 20)}..." : address,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
          if (isCustomAddress)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextField(
                controller: customAddressController,
                decoration: InputDecoration(
                  labelText: "Enter your address",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  OrderController.instance.setSelectedAddress(value);
                },
              ),
            ),
        ],
      ),
    );
  }

  void _openMapScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationSearchScreen()),
    );

    if (result != null && result is String) {
      setState(() {
        addresses.add(result);
        selectedAddress = result;
        OrderController.instance.setSelectedAddress(result);
      });
    }
  }
}