import 'package:flutter/cupertino.dart';
import 'package:food/features/authentication/screens/login/login.dart';
//import 'package:food/features/authentication/screens/login/login.dart';
// import 'package:food/features/authentication/screens/new_login/loginpage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  ///Update Current Index when page Scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  ///Jump to the specific dor selected page
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }

  ///Update Current Index and Jump to next Page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      final storage = GetStorage();
      storage.write('isFirstTime', false);
      Get.offAll(const LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  ///Update Current Index and Jump to the last Page
  void skipPage() {
    Get.offAll(const LoginScreen());
    //currentPageIndex.value = 2;
    //pageController.jumpTo(2);
  }
}
