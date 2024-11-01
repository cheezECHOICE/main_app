import 'package:flutter/material.dart';
import 'package:food/common/widgets/appbar/appbar.dart';
import 'package:food/features/personalisation/controllers/address_controller.dart';
import 'package:food/features/personalisation/screens/address/widgets/add_new_address_screen.dart';
import 'package:food/features/personalisation/screens/address/widgets/single_address.dart';
import 'package:food/utils/constants/colors.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:food/utils/helpers/cloud_helper_function.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title:
            Text('Address', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Obx(
            () => FutureBuilder(
              key: Key(controller.refreshData.value.toString()),
              future: controller.getallUserAddress(),
              builder: (context, snapshot) {
                final responce = TCloudHelperFunctions.checkMultiRecordState(
                    snapshot: snapshot);
                if (responce != null) return responce;
                final addresses = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: addresses.length,
                  itemBuilder: (_, index) => TSingleAddress(
                    address: addresses[index],
                    onTap: () => controller.selectAddress(addresses[index]),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddNewAddressScreen()),
        backgroundColor: TColors.primary,
        child: const Icon(Iconsax.add, color: TColors.white),
      ),
    );
  }
}
