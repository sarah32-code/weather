import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      Get.snackbar('Login', 'Login successful!');
      Get.offNamed(Routes.HOME);

    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Failed', e.message!, snackPosition: SnackPosition.BOTTOM); 
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
