// import 'package:flutter/material.dart';
// import 'package:cheezechoice/utils/constants/image_strings.dart';
// import 'package:cheezechoice/utils/constants/sizes.dart';
// import 'package:cheezechoice/utils/constants/text_strings.dart';
// import 'package:cheezechoice/utils/helpers/helper_functions.dart';

// class TLoginHeader extends StatelessWidget {
//   const TLoginHeader({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final dark = THelperFunctions.isDarkMode(context);
//     return Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//    Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Image(
//           height: 200,
//           width: 370,
//           image: AssetImage(dark ? TImages.AppLogo : TImages.AppLogo),
//         ),
//         Text(
//           TTexts.appName,
//           style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//             color: dark ? Colors.white : Colors.black,
//           ),
//         ),
//       ],
//     ),
//   ],
// ),

// const SizedBox(height: TSizes.appBarHeight),

//           Text(
//             TTexts.loginTitle,
//             style: Theme.of(context).textTheme.headlineMedium,
//           ),
//           const SizedBox(height: TSizes.sm),
//           Text(
//             TTexts.loginSubTitle,
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//           // const SizedBox(height: TSizes.lg),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cheezechoice/utils/constants/image_strings.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        // Image covering less than half the screen height
        Container(
          height:
              MediaQuery.of(context).size.height * 0.4, // 40% of screen height
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(dark ? TImages.banner3 : TImages.banner2),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
