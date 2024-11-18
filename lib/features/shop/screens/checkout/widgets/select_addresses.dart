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

  // Sample data for rooms
  final Map<String, List<String>> roomOptions = {
    "Men's": ["MH1", "MH2", "MH3", "MH4", "MH5", "MH6", "CB"],
    "Ladies": ["LH1", "LH2", "LH3"],
  };

  // Function to determine if the section should be available
  bool isAvailable() {
    final now = DateTime.now();
    final startAvailability =
        DateTime(now.year, now.month, now.day, 1); // Saturday 5:00 PM
    final endAvailability =
        DateTime(now.year, now.month, now.day, 23); // Monday 8:00 PM

    // Check if today is between Saturday 5:00 PM and Monday 8:00 PM
    final dayOfWeek = now.weekday;
    final isSaturdayEvening =
        dayOfWeek == DateTime.sunday && now.isAfter(startAvailability);
    //final isSunday = dayOfWeek == DateTime.thursday;
    final isMondayMorning =
        dayOfWeek == DateTime.saturday && now.isBefore(endAvailability);

    return isSaturdayEvening  || isMondayMorning;
    
  }

  @override
  Widget build(BuildContext context) {
    final available = isAvailable(); // Check availability for the section

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2), // Adding border
        borderRadius:
            BorderRadius.circular(12), // Rounded corners for the border
      ),
      padding: const EdgeInsets.all(16.0), // Padding around the content
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gender Selection
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
                                  selectedRoom = null; // Reset room selection
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
                                  selectedRoom = null; // Reset room selection
                                });
                              }
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              // Room Selection based on Gender
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
                            // Save the selected address to OrderController
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
          // Overlay for "Collect Your Order" message with blur effect
          if (!available)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0), // Rounded edges
                child: BackdropFilter(
                  filter:
                      ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Blur effect
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(0.56), // Dark transparent overlay
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Collect your order from main gate',
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
