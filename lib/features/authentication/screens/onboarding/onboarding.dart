import 'package:flutter/material.dart';
import 'package:food/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:food/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:food/features/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:food/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:food/utils/constants/text_strings.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    final animationUrl1 =
        "https://lottie.host/434fe61b-6e2f-4e56-ae56-f640b31483b4/00lktESelP.json";
    final animationUrl2 =
        "https://lottie.host/c0e9ea28-5fcd-4ea0-9b91-d336e16b9674/teOwQDvP2z.json";
    final animationUrl3 =
        "https://lottie.host/2a20128d-0f35-49ef-b7a8-269cb2f4bb73/EtqsFbm1D0.json";

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnBoardingPage(
                animationUrl: animationUrl1,
                title: TTexts.onBoardingTitle1,
                subTitle: TTexts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                animationUrl: animationUrl2,
                title: TTexts.onBoardingTitle2,
                subTitle: TTexts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                animationUrl: animationUrl3,
                title: TTexts.onBoardingTitle3,
                subTitle: TTexts.onBoardingSubTitle3,
              ),
            ],
          ),
          const OnBoardingDotNavigation(),
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}
