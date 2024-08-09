import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> reset() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
        Get.snackbar('Success', 'Password reset link sent', snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text('Forgot Password', style: TextStyle(color: Colors.blueAccent)),
        iconTheme: const IconThemeData(color: Colors.blueAccent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter your email address to receive a password reset link.',
                  style: TextStyle(fontSize: 16.0, color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email, color: Colors.blueAccent),
                            labelText: 'Email',
                            labelStyle: const TextStyle(color: Colors.blueAccent),
                            filled: true,
                            fillColor: Colors.black54,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      AnimatedButton(
                        onPressed: () => reset(),
                        child: const Text('Send Reset Link' , style: TextStyle(fontSize: 16),),
                      ),
                      const SizedBox(height: 20.0),
                      AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(seconds: 1),
                        child: TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Back to Login', style: TextStyle(fontSize: 16 , color: Colors.blueAccent)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
          foregroundColor: Colors.white, backgroundColor: Colors.blueAccent, // Text color
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
