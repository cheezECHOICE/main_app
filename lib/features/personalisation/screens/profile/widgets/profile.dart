import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:cheezechoice/common/widgets/appbar/appbar.dart';
import 'package:cheezechoice/common/widgets/images/t_circular_image.dart';
import 'package:cheezechoice/common/widgets/texts/section_heading.dart';
import 'package:cheezechoice/features/personalisation/controllers/user_controller.dart';
import 'package:cheezechoice/features/personalisation/screens/profile/widgets/changeName.dart';
import 'package:cheezechoice/features/personalisation/screens/profile/widgets/profile_menu.dart';
import 'package:cheezechoice/utils/constants/image_strings.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:cheezechoice/utils/shimmers/shimmer.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedGender = 'Male'; // Default gender selection

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: const TAppBar(showBackArrow: true, title: Text('Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      final networkImage = controller.user.value.profilePicture;
                      final image =
                          networkImage.isNotEmpty ? networkImage : TImages.user;
                      return controller.imageUploading.value
                          ? const TShimmerEffect(width: 80, height: 80)
                          : TCircularImage(
                              image: image,
                              width: 80,
                              height: 80,
                              isNetworkImage: networkImage.isNotEmpty,
                            );
                    }),
                    TextButton(
                      onPressed: () => controller.uploadProfilePicture(),
                      child: const Text('Change Profile Picture'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(
                title: 'Profile Information',
                showActionButton: false,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              // TProfileMenu(
              //   title: 'Name',
              //   value: controller.user.value.fullName,
              //   icon: Iconsax.edit,
              //   onPressed: () => Get.to(() => const ChangeName()),
              // ),
              TProfileMenu(
                title: 'UserName',
                value: controller.user.value.username,
                icon: Iconsax.edit2,
                onPressed: () {},
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Heading Personal Info
              const TSectionHeading(
                title: 'Personal Information',
                showActionButton: false,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // User ID with copy functionality
              TProfileMenu(
                title: 'User ID',
                value: controller.user.value.id,
                icon: Iconsax.copy,
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                    text: controller.user.value.id,
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('User ID copied to clipboard')),
                  );
                },
              ),

              // E-mail and Phone number
              TProfileMenu(
                title: 'E-mail',
                value: controller.user.value.email,
                onPressed: () {},
              ),
              TProfileMenu(
                title: 'Ph.no',
                value: controller.user.value.phoneNumber,
                onPressed: () {},
              ),
              // TProfileMenu(
              //   title: 'Address',
              //   value: controller.user.value.address,
              //   onPressed: () {},
              // ),


              // Gender with dropdown
              // TProfileMenu(title: 'User', value: 'Student', onPressed: () {}),

              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              Center(
                child: TextButton(
                  onPressed: () => controller.deleteAccountWarningPopup(),
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
