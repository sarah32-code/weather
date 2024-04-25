import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart'; 

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    String email = emailController.text;
    String password = passwordController.text;


    const String validEmail = 'user@example.com';
    const String validPassword = 'password';

    if (email == validEmail && password == validPassword) {
      // Login successful
      Get.snackbar('Login', 'Login successful!');
      Get.offNamed(Routes.HOME); 
    } else {
      Get.snackbar('Login', 'Invalid email or password!', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
