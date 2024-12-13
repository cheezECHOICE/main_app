// ignore: file_names
import 'package:flutter/material.dart';

class ExclusiveCard extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  const ExclusiveCard(
      {Key? key, required this.imagePath, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 350.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Positioned(
          //   bottom: 20.0,
          //   left: 20.0,
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       foregroundColor: Colors.white, // black
          //       backgroundColor: Colors.teal, //white
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10.0),
          //       ),
          //     ),
          //     onPressed: () {},
          //     child: const Text(
          //       'Explore',
          //       style: TextStyle(
          //         fontSize: 15,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
