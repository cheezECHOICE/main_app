import 'package:flutter/material.dart';

class PhoneNumberSection extends StatefulWidget {
  @override
  _PhoneNumberSectionState createState() => _PhoneNumberSectionState();
}

class _PhoneNumberSectionState extends State<PhoneNumberSection> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();
  bool _isConfirmed = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _registrationController.dispose();
    super.dispose();
  }

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
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
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isConfirmed = true;
              });
              Navigator.pop(context);
              _showFinalConfirmation();
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
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Enter Your Phone Number:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () => _showInfoDialog(
                  "Phone Number",
                  "We need your phone number so that the delivery person can contact you.",
                ),
                tooltip: "Why we need your phone number",
              ),
            ],
          ),
          SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.number,
            maxLength: 10,
            enabled: !_isConfirmed,
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
              setState(() {});
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
          SizedBox(height: 0),
          Row(
            children: [
              Text(
                "Registration Number:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () => _showInfoDialog(
                  "Registration Number",
                  "To enter your details in the register at the main gate, so that the security will let your delivery person in.",
                ),
                tooltip: "Why we need your registration number",
              ),
            ],
          ),
          SizedBox(height: 8),
          TextField(
            controller: _registrationController,
            decoration: InputDecoration(
              hintText: "Ex: 21BCE7...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
