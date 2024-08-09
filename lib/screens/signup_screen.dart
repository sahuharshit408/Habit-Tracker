import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/helpers/wrapper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> signup() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text == _confirmPasswordController.text) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
          Get.offAll(const Wrapper());
        } catch (e) {
          Get.snackbar('Sign up failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('Password mismatch', 'Passwords do not match', snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(seconds: 1),
                child: Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_emailController, 'Email', Icons.email),
                    const SizedBox(height: 20),
                    _buildTextField(_passwordController, 'Password', Icons.lock, obscureText: true),
                    const SizedBox(height: 20),
                    _buildTextField(_confirmPasswordController, 'Confirm Password', Icons.lock, obscureText: true),
                    const SizedBox(height: 20),
                    AnimatedButton(
                      onPressed: () => signup(),
                      child: const Text('Sign Up' , style: TextStyle(fontSize: 16),),
                    ),
                    const SizedBox(height: 20),
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(seconds: 1),
                      child: TextButton(
                        onPressed: () => Get.toNamed('/login'),
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon, {bool obscureText = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.black54,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        style: const TextStyle(color: Colors.white),
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }
}

class AnimatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: child,
      ),
    );
  }
}
