import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:weather_app/app/components/custom_button.dart';
import '../../login/views/authentication_service.dart';

class RegistrationPage extends StatelessWidget {
  final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        backgroundColor: Color.fromARGB(255, 138, 141, 130),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Green and White Simple Watercolor Background Instagram Story.png'), // Change to your background image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: RegistrationForm(authService: _auth),
          ),
        ),
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  final AuthenticationService authService;

  RegistrationForm({required this.authService});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Add form key

  @override
  Widget build(BuildContext context) {
    return Form( // Wrap with Form widget
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Username is required';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
          ),
          SizedBox(height: 32.0),
          CustomButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) { // Validate form
                String username = _usernameController.text;
                String email = _emailController.text;
                String password = _passwordController.text;
                bool success = await widget.authService.register(username, email, password);
                if (success) {
                  // Navigate to the next screen upon successful registration
                  Get.toNamed('/login'); // Using GetX for navigation
                } else {
                  // Handle registration failure
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Registration failed. Please try again.'),
                    ),
                  );
                }
              }
            },
            text: 'Register', // Change button text
            fontSize: 18.sp,
            backgroundColor: Color.fromARGB(255, 138, 141, 130),
            foregroundColor: Colors.black,
            width: 265.w,
            radius: 30.r,
            verticalPadding: 20.h,
          ).animate().fade().slideY(
            duration: 300.ms,
            begin: 1,
            curve: Curves.easeInSine,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
