import 'dart:io';

class RegisterPostModel {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String confirmPassword;
  final String agree;
  final String? address;
  final String? state;
  final String? zip;
  final String? city;
  final File? image;

  RegisterPostModel({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.confirmPassword,
    required this.agree,
    this.address,
    this.state,
    this.zip,
    this.city,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'password': password,
      'password_confirmation': confirmPassword,
      'agree': agree,
      'username': username,
      'email': email,
      'firstname': firstName,
      'lastname': lastName,
    };
  }
}
