import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password  
      );
      print("User registered successfully");
    
    } on FirebaseAuthException catch (e) {
      print("Registration error: $e");
    }
  }

}
