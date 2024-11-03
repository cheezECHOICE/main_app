import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  String id;
  String name;
  String image;
  bool? isFeatured;
  bool? isOpen;

  BrandModel(
      {required this.id,
      required this.image,
      required this.name,
      this.isFeatured,
      this.isOpen});

  // Empty helper function
  static BrandModel empty() => BrandModel(id: '', image: '', name: '');

  //Convert model to JSON structure so that you can store data in Firebase
  toJson() {
    return {
      'id': id,
      'name': name,
      'imgurl': image,
      'isopen': isOpen,
      'isfeatured': isFeatured
    };
  }

  //Map Json oriented document snapshot from Firebase to usermodel
  factory BrandModel.fromJson(Map<String, dynamic> data) {
    if (data.isEmpty) return BrandModel.empty();
    return BrandModel(
      id: data['id'].toString(),
      image: data['imgurl'] ?? '',
      name: data['name'] ?? '',
      isFeatured: data['isFeatured'] ?? false,
      isOpen: data['isOpen'] ?? false,
    );
  }

  //Map Json oriented document snapshot from Firebase to UserModel
  factory BrandModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      // Map JSON Record to the Model
      return BrandModel(
        id: document.id,
        name: data['Name'] ?? '',
        image: data['Image'] ?? '',
        isOpen: data['isopen'] ?? '',
        isFeatured: data['IsFeatured'] ?? false,
      );
    } else {
      return BrandModel.empty();
    }
  }

  factory BrandModel.fromProduct(Map<String, dynamic> data) {
    return BrandModel(
      id: data['id'].toString(),
      image: data['imgurl'] ?? '',
      name: data['name'] ?? '',
      isFeatured: data['isFeatured'] ?? false,
      isOpen: data['isOpen'] ?? false,
    );
  }

  copyWith({required street}) {}
}
