import 'dart:io';

class ProfileCompletePostModel {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String pin;
  final String cPin;
  final String agree;
  final String? address;
  final String? state;
  final String? zip;
  final String? city;
  final File? image; // optional

  ProfileCompletePostModel({
    required this.pin,
    required this.cPin,
    required this.agree,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.address,
    this.state,
    this.zip,
    this.city,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'password': pin,
      'password_confirmation': cPin,
      'agree': agree,
      'username': username,
      'email': email,
      'firstname': firstName,
      'lastname': lastName,
      // 'address': address,
      // 'state': state,
      // 'zip': zip,
      // 'city': city,
      // Convert image to a suitable format (e.g., base64 string) if needed.
      // 'image': image?.path,
    };
  }
}
