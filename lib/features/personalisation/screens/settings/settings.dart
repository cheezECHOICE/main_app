import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food/common/widgets/appbar/appbar.dart';
import 'package:food/common/widgets/custom_shapes/container/primary_header_container.dart';
import 'package:food/common/widgets/layouts/listTiltes/setting_menu_tile.dart';
import 'package:food/common/widgets/layouts/listTiltes/user_profile.dart';
import 'package:food/common/widgets/texts/section_heading.dart';
import 'package:food/features/personalisation/screens/address/address.dart';
import 'package:food/features/personalisation/screens/profile/widgets/profile.dart';
import 'package:food/features/personalisation/screens/settings/utils/logout.dart';
import 'package:food/features/shop/screens/cart/cart.dart';
import 'package:food/features/shop/screens/orders/order.dart';
import 'package:food/features/shop/screens/wishlist/wishlist.dart';
import 'package:food/utils/constants/colors.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:url_launcher/url_launcher.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late String localPrivacyPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocalFiles();
  }

  // Asynchronously load the local files from assets to the temporary directory
  Future<void> _loadLocalFiles() async {
    try {
      final directory = await getTemporaryDirectory();

      // Load Privacy Policy
      final privacyPolicyData =
          await rootBundle.load('assets/docs/all policies.pdf');
      final privacyPolicyFile = File('${directory.path}/all policies.pdf');
      await privacyPolicyFile
          .writeAsBytes(privacyPolicyData.buffer.asUint8List());
      localPrivacyPath = privacyPolicyFile.path;

      setState(() {
        isLoading = false; // Files are loaded
      });
    } catch (e) {
      print('Error loading local files: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  // AppBar
                  TAppBar(
                    title: Text('Account',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .apply(color: TColors.white)),
                  ),
                  // User Profile card
                  TUserProfileTile(
                      onPressed: () => Get.to(() => const ProfileScreen())),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  const TSectionHeading(
                    title: 'Account Settings',
                    showActionButton: false,
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.bag_tick,
                    title: 'My Orders',
                    subtitle: 'In-progress and completed orders',
                    onTap: () => Get.to(() => const OrderScreen()),
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.shopping_cart,
                    title: 'My Cart',
                    subtitle: 'Add, remove products and move to checkout',
                    onTap: () =>
                        Get.to(() => const CartScreen(fromProfile: true)),
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.heart,
                    title: 'My Wishlist',
                    subtitle: 'Home to your favourite items',
                    onTap: () => Get.to(() => const FavouriteScreen()),
                  ),
                  //Divider(color: TColors.grey),
                  // TSettingsMenuTile(
                  //   icon: Iconsax.safe_home,
                  //   title: 'My Address',
                  //   subtitle: 'Set Ordering delivery Address',
                  //   onTap: () {
                  //     _showUnderDevelopmentSnap(
                  //         context); // Show "Under Development" Snap
                  //   },
                  // ),
                  // TSettingsMenuTile(
                  //   icon: Iconsax.heart,
                  //   title: 'My Notifications',
                  //   subtitle: 'Set any kind of notification message',
                  //   onTap: () {},
                  // ),
                  Divider(color: TColors.grey),
                  TSettingsMenuTile(
                    icon: Iconsax.security,
                    title: 'Privacy Policy',
                    subtitle: 'Know about our policies',
                    onTap: () {
                      if (!isLoading) {
                        _showFullScreenDocument(context, localPrivacyPath);
                      }
                    },
                  ),
                  TSettingsMenuTile(
  icon: Iconsax.building,
  title: 'About Us',
  subtitle: 'Get more info about our team APPE NEXUS',
  onTap: () async {
    const url = 'https://appenexus.tech';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  },
),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  SizedBox(
                    height: 55,
                    width: 130,
                    child: ElevatedButton(
                      onPressed: () async {
                        await logout();
                      },
                      child: const Text('Logout'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Center(
                    child: Text(
                      "Powered By Appe Nexus PVT LTD",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to open the document in a full-screen view
  void _showFullScreenDocument(BuildContext context, String filePath) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black54,
            automaticallyImplyLeading: false,
            title: const Text('Policies'),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          body: PDFView(
            filePath: filePath,
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: anim1,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Function to show "Under Development" Snap
  void _showUnderDevelopmentSnap(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(0), // To cover the entire screen
          backgroundColor: Colors.black54,
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'This feature will be available in the next update',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
