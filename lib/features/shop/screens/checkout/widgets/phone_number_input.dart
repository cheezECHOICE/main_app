import 'package:flutter/material.dart';

class PhoneNumberSection extends StatefulWidget {
  @override
  _PhoneNumberSectionState createState() => _PhoneNumberSectionState();
}

class _PhoneNumberSectionState extends State<PhoneNumberSection> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isConfirmed = false; // Track if the user confirmed the number

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showFinalConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text(
            'The delivery person will contact you at this number: ${_phoneController.text}.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _confirmPhoneNumber() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Phone Number'),
        content: Text(
            'Are you sure this is your correct number: ${_phoneController.text}?'),
        actions: [
          TextButton(
            onPressed: () {
              _clearPhoneNumber();
              Navigator.pop(context); // Close confirmation dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isConfirmed = true;
              });
              Navigator.pop(context); // Close confirmation dialog
              _showFinalConfirmation(); // Show final message
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearPhoneNumber() {
    _phoneController.clear();
    setState(() {
      _isConfirmed = false;
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
            "Enter Your Phone Number:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.number,
            maxLength: 10,
            enabled: !_isConfirmed, // Disable editing after confirmation
            decoration: InputDecoration(
              hintText: "10-digit phone number",
              counterText: "${_phoneController.text.length}/10",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: (value) {
              if (value.length == 10 && !_isConfirmed) {
                _confirmPhoneNumber();
              }
              setState(() {}); // Update the UI for the counter
            },
          ),
          if (_isConfirmed)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Phone number confirmed.',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
