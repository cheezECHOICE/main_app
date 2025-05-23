import 'package:cheezechoice/features/authentication/screens/login/login.dart';
import 'package:cheezechoice/features/authentication/screens/onboarding/onboarding.dart';
import 'package:cheezechoice/features/authentication/screens/password_configuration/forgot_password.dart';
import 'package:cheezechoice/features/authentication/screens/signup/signup.dart';
import 'package:cheezechoice/features/authentication/screens/signup/verify_email.dart';
import 'package:cheezechoice/features/personalisation/screens/address/address.dart';
import 'package:cheezechoice/features/personalisation/screens/profile/widgets/profile.dart';
import 'package:cheezechoice/features/personalisation/screens/settings/settings.dart';
import 'package:cheezechoice/features/shop/screens/cart/cart.dart';
import 'package:cheezechoice/features/shop/screens/checkout/checkout.dart';
import 'package:cheezechoice/features/shop/screens/home/home.dart';
import 'package:cheezechoice/features/shop/screens/orders/order.dart';
import 'package:cheezechoice/features/shop/screens/product_reviews/product_review.dart';
import 'package:cheezechoice/features/shop/screens/store/store.dart';
import 'package:cheezechoice/features/shop/screens/store/store_products.dart';
import 'package:cheezechoice/features/shop/screens/wishlist/wishlist.dart';
import 'package:cheezechoice/routes/routes.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: TRoutes.home, page: () => HomeScreen()),
    GetPage(name: TRoutes.store, page: () => const StoreScreen()),
    GetPage(
        name: TRoutes.storeProducts, page: () => const StoreProductsScreen()),
    GetPage(name: TRoutes.favourites, page: () => const FavouriteScreen()),
    GetPage(name: TRoutes.settings, page: () => const SettingScreen()),
    GetPage(
        name: TRoutes.productReviews, page: () => const ProductReviewScreen()),
    GetPage(name: TRoutes.order, page: () => const OrderScreen()),
    GetPage(name: TRoutes.checkout, page: () => const CheckOutScreen()),
    GetPage(name: TRoutes.cart, page: () => const CartScreen()),
    GetPage(name: TRoutes.userProfile, page: () => const ProfileScreen()),
    GetPage(name: TRoutes.userAddress, page: () => const UserAddressScreen()),
    GetPage(name: TRoutes.signup, page: () => const SignupScreen()),
    GetPage(name: TRoutes.verifyEmail, page: () => const VerifyEmailScreen()),
    GetPage(name: TRoutes.signIn, page: () => const LoginScreen()),
    GetPage(name: TRoutes.forgetPassword, page: () => const ForgotPassword()),
    GetPage(name: TRoutes.onBoarding, page: () => const OnBoardingScreen()),
  ];
}
