import 'package:flutter/material.dart';
import 'package:food/utils/constants/image_strings.dart';
//import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class Developer {
  final String name;
  final String photoAsset;
  final String role;
  final String instagramHandle;
  final String linkedinHandle;
  final String instagramUrl;
  final String linkedinUrl;

  Developer({
    required this.name,
    required this.photoAsset,
    required this.role,
    required this.instagramHandle,
    required this.linkedinHandle,
    required this.instagramUrl,
    required this.linkedinUrl,
  });
}

class CustomBottomSheet {
  static void show(
      BuildContext context, String title, List<Developer> developers) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$title - ${developers.isNotEmpty ? developers.first.name : ""}',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        // Close the bottom sheet
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                for (Developer developer in developers)
                  _buildDeveloperInfo(developer),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildDeveloperInfo(Developer developer) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(developer.photoAsset),
        ),
        const SizedBox(height: 8),
        Text(
          developer.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          developer.role,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildButton('Instagram', developer.instagramUrl, TImages.paypal),
            _buildButton('LinkedIn', developer.linkedinUrl, TImages.paytm),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  static Widget _buildButton(String label, String url, String iconAsset) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 26.0),
      child: ElevatedButton(
        onPressed: () => _launchUrl(url),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 177, 87, 184),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              iconAsset,
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _launchUrl(String url) async {
    try {
      // ignore: deprecated_member_use
      await launch(url);
    } catch (e) {
      // ignore: deprecated_member_use
      await launch(url, forceSafariVC: false);
    }
  }
}
