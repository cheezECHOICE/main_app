import 'package:flutter/material.dart';

class StoreInfoCards extends StatelessWidget {
  const StoreInfoCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color iconColor = isDarkMode ? Colors.white : Colors.black;
    final TextStyle labelStyle = TextStyle(
      fontSize: 14,
      color: isDarkMode ? Colors.white70 : Colors.black87,
    );
    final TextStyle valueStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: isDarkMode ? Colors.white : Colors.black,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _buildInfoCard(
            icon: Icons.access_time,
            label: 'Min Order value',
            value: 'Rs. 200',
            iconColor: iconColor,
            labelStyle: labelStyle,
            valueStyle: valueStyle,
            isDarkMode: isDarkMode,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildInfoCard(
            icon: Icons.directions_walk,
            label: 'Delivery time',
            value: '25-35 min',
            iconColor: iconColor,
            labelStyle: labelStyle,
            valueStyle: valueStyle,
            isDarkMode: isDarkMode,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildInfoCard(
            icon: Icons.attach_money,
            label: 'Delivery price',
            value: 'Rs.60',
            iconColor: iconColor,
            labelStyle: labelStyle,
            valueStyle: valueStyle,
            isDarkMode: isDarkMode,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    required TextStyle labelStyle,
    required TextStyle valueStyle,
    required bool isDarkMode,
  }) {
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 8),
          Text(label, style: labelStyle),
          const SizedBox(height: 4),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}
