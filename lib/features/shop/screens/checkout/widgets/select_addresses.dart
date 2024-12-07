import 'package:flutter/material.dart';
import 'package:cheezechoice/features/shop/controllers/product/order_controller.dart';
import 'dart:ui';

class DeliveryAddressSection2 extends StatefulWidget {
  @override
  _DeliveryAddressSectionState createState() => _DeliveryAddressSectionState();
}

class _DeliveryAddressSectionState extends State<DeliveryAddressSection2> {
  String? selectedGender; // To hold selected gender
  String? selectedRoom; // To hold selected room

  final Map<String, List<String>> roomOptions = {
    "Men's": ["MH1", "MH2", "MH3", "MH4", "MH5", "MH6", "CB"],
    "Ladies": ["LH1", "LH2", "LH3"],
  };

  bool isAvailable() {
    final now = DateTime.now();
    final startAvailability = DateTime(
      now.year,
      now.month,
      now.day,
      16, // 4 PM
    );
    final endAvailability = DateTime(
      now.year,
      now.month,
      now.day,
      9, // 9 AM
    ).add(Duration(days: now.weekday == DateTime.monday ? 0 : 1));

    if (now.weekday == DateTime.saturday && now.isAfter(startAvailability)) {
      return true;
    } else if (now.weekday == DateTime.sunday) {
      return true;
    } else if (now.weekday == DateTime.monday &&
        now.isBefore(endAvailability)) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();

    // Set the default address to "Main Gate" when unavailable
    if (!isAvailable()) {
      OrderController.instance.setSelectedAddress("Main Gate");
    }
  }

  @override
  Widget build(BuildContext context) {
    final available = isAvailable();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Block:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text("Men's"),
                      leading: Radio<String>(
                        value: "Men's",
                        groupValue: selectedGender,
                        onChanged: available
                            ? (String? value) {
                                setState(() {
                                  selectedGender = value;
                                  selectedRoom = null;
                                });
                              }
                            : null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text("Ladies"),
                      leading: Radio<String>(
                        value: "Ladies",
                        groupValue: selectedGender,
                        onChanged: available
                            ? (String? value) {
                                setState(() {
                                  selectedGender = value;
                                  selectedRoom = null;
                                });
                              }
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              if (selectedGender != null) ...[
                Text(
                  "Select Address:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedRoom,
                  hint: Text("Choose a block"),
                  onChanged: available
                      ? (String? newValue) {
                          setState(() {
                            selectedRoom = newValue;
                            if (selectedRoom != null) {
                              OrderController.instance
                                  .setSelectedAddress(selectedRoom!);
                            }
                          });
                        }
                      : null,
                  items: roomOptions[selectedGender]?.map((String room) {
                    return DropdownMenuItem<String>(
                      value: room,
                      child: Text(room),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
          if (!available)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.56),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Cannot order today',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
