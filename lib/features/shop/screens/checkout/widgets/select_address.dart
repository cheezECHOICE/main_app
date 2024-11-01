import 'package:flutter/material.dart';
import 'package:food/common/styles/TRoundedContainer.dart';
import 'package:food/utils/constants/colors.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:food/utils/helpers/helper_functions.dart';
import 'dart:ui';

class DeliveryAddressSection extends StatefulWidget {
  const DeliveryAddressSection({Key? key}) : super(key: key);

  @override
  _DeliveryAddressSectionState createState() => _DeliveryAddressSectionState();
}

class _DeliveryAddressSectionState extends State<DeliveryAddressSection> {
  String selectedHostelType = 'Mens Hostel';
  String? selectedRoom;
  final List<String> mensHostelRooms = [
    'MH-2',
    'MH-3',
    'MH-4',
    'MH-5',
    'MH-6',
    'CB'
  ];
  final List<String> ladiesHostelRooms = ['LH-1', 'LH-2', 'LH-3'];

  // Function to determine if the section should be available
  bool isAvailable() {
    final now = DateTime.now();
    final startAvailability =
        DateTime(now.year, now.month, now.day, 17); // Saturday 5:00 PM
    final endAvailability =
        DateTime(now.year, now.month, now.day, 20); // Monday 8:00 PM

    // Check if today is between Saturday 5:00 PM and Monday 8:00 PM
    final dayOfWeek = now.weekday;
    final isSaturdayEvening =
        dayOfWeek == DateTime.saturday && now.isAfter(startAvailability);
    final isSunday = dayOfWeek == DateTime.sunday;
    final isMondayMorning =
        dayOfWeek == DateTime.monday && now.isBefore(endAvailability);

    return isSaturdayEvening || isSunday || isMondayMorning;
  }

  List<String> get roomOptions {
    return selectedHostelType == 'Mens Hostel'
        ? mensHostelRooms
        : ladiesHostelRooms;
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final available = isAvailable();

    return TRoundedContainer(
      showBorder: true,
      backgroundColor: dark ? TColors.dark : TColors.white,
      padding: const EdgeInsets.symmetric(
          horizontal: TSizes.md, vertical: TSizes.sm),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Delivery Address:',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: TSizes.sm),

              // Hostel Type Dropdown
              Row(
                children: [
                  DropdownButton<String>(
                    value: selectedHostelType,
                    icon: const Icon(Icons.arrow_downward_rounded),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: TColors.primary,
                    ),
                    onChanged: available
                        ? (String? newValue) {
                            setState(() {
                              selectedHostelType = newValue!;
                              selectedRoom = null;
                            });
                          }
                        : null,
                    items: ['Mens Hostel', 'Ladies Hostel']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 45),

                  // Room Selection Dropdown
                  DropdownButton<String>(
                    value: selectedRoom,
                    hint: const Text('Select Block'),
                    icon: const Icon(Icons.arrow_downward_rounded),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: TColors.primary,
                    ),
                    onChanged: available
                        ? (String? newValue) {
                            setState(() {
                              selectedRoom = newValue;
                            });
                          }
                        : null,
                    items: roomOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
          // Overlay and Info Message
          if (!available)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0), // Rounded edges
                child: BackdropFilter(
                  filter:
                      ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Blur effect
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(0.56), // Dark transparent overlay
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Collect your order from main gate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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
