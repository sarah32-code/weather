import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/app/components/custom_button.dart';
import 'package:weather_app/app/routes/app_pages.dart';
import 'authentication_service.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Color.fromARGB(255, 138, 141, 130),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Green and White Simple Watercolor Background Instagram Story.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: LoginForm(authService: _auth),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final AuthenticationService authService;

  LoginForm({required this.authService});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); 
  @override
  Widget build(BuildContext context) {
    return Form( 
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
              if (_formKey.currentState!.validate()) { 
                String username = _usernameController.text;
                String password = _passwordController.text;

              
                bool success = await widget.authService.login(username, password);
                if (success) {
                  
                  Get.toNamed(Routes.HOME); 
                } else {
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Login failed. Please try again.'),
                    ),
                  );
                }
              }
            },
            text: 'Login', 
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
    _passwordController.dispose();
    super.dispose();
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}
