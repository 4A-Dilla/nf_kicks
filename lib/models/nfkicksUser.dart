import 'package:flutter/material.dart';
import 'package:nf_kicks/utils/end_to_end_encryption.dart';

class NfkicksUser {
  NfkicksUser({
    this.uid,
    @required this.fullName,
    @required this.email,
    @required this.phoneNumber,
    @required this.image,
    @required this.has2FA,
  });

  String uid;
  String fullName;
  String email;
  String phoneNumber;
  String image;
  bool has2FA;

  factory NfkicksUser.fromMap(Map<String, dynamic> data, String userUid) {
    if (data == null) {
      return null;
    }

    return new NfkicksUser(
      uid: userUid,
      fullName: EndToEndEncryption.decrypt(data: data['fullName'] ?? ''),
      email: EndToEndEncryption.decrypt(data: data['email'] ?? ''),
      phoneNumber: EndToEndEncryption.decrypt(data: data['phoneNumber'] ?? ''),
      image: EndToEndEncryption.decrypt(data: data['image'] ?? ''),
      has2FA: data['has2FA'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': EndToEndEncryption.encrypt(data: email.toString()),
      'fullName': EndToEndEncryption.encrypt(data: fullName.toString()),
      'image': EndToEndEncryption.encrypt(data: image.toString()),
      'phoneNumber': EndToEndEncryption.encrypt(data: phoneNumber.toString()),
      'has2FA': false,
    };
  }

  Map<String, dynamic> toMapNoImage() {
    return {
      'email': EndToEndEncryption.encrypt(data: email.toString()),
      'fullName': EndToEndEncryption.encrypt(data: fullName.toString()),
      'phoneNumber': EndToEndEncryption.encrypt(data: phoneNumber.toString()),
      'has2FA': false,
    };
  }
}
