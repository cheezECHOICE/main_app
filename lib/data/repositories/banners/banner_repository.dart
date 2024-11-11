import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cheezechoice/features/shop/models/banner_model.dart';
import 'package:cheezechoice/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:cheezechoice/utils/exceptions/firebase_exception.dart';
import 'package:cheezechoice/utils/exceptions/format_exception.dart';
import 'package:cheezechoice/utils/exceptions/paltform_exception.dart';
import 'package:get/get.dart';

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  // Variables

  final _db = FirebaseFirestore.instance;

  // Get all order related to current User
  Future<List<BannerModel>> fetchBanners() async {
    try {
      final result = await _db
          .collection('Banners')
          .where('active', isEqualTo: true)
          .get();
      return result.docs
          .map((documentSnapshot) => BannerModel.fromSnapShot(documentSnapshot))
          .toList();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

// Upload Banners to cloud Firebase
}
