import 'package:flutter/material.dart';

class NfkicksUser {
  NfkicksUser({
    this.uid,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.image,
    this.has2FA,
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
      'phoneNumber': phoneNumber.toString(),
    };
  }
}
