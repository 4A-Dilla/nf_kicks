import 'package:flutter/material.dart';

class NfkicksUser {
  NfkicksUser({
    @required this.uid,
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
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      image: data['image'] ?? '',
      has2FA: data['has2FA'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName.toString(),
      'email': email.toString(),
      'phoneNumber': phoneNumber.toString(),
      'image': image.toString(),
      'has2FA': has2FA,
    };
  }
}
