import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bsit3bcrud/login_screen.dart'; // Import LoginScreen for navigation

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // ✅ State variable to control password visibility
  bool _isPasswordVisible = false;

  Future<void> register() async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      showError("Please fill in all fields.");
      return;
    }

    final url = Uri.parse("http://192.168.1.8:5000/register"); // Replace with your API URL
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 201) {
        showSuccess("🎉 Registration successful! Please log in.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else if (response.statusCode == 409) {
        showError("⚠️ Email already exists. Try another one.");
      } else {
        showError("❌ Failed to register. Please try again.");
      }
    } catch (e) {
      showError("🔌 Error connecting to the server.");
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Facebook AppBar
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: const Text(
          "facebook",
          style: TextStyle(
            fontSize: 40,
            color: Color(0xFF1877F2), // Facebook Blue
            fontWeight: FontWeight.bold,
            fontFamily: 'Klavika', // Simulate Klavika font
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ Facebook Logo from Asset
              Image.asset(
                "assets/images/facebooklogo.png",
                height: 80,
              ),
              const SizedBox(height: 30),

              // ✅ Username Input
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),

              // ✅ Email Input
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // ✅ Password Input with Eye Icon
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: !_isPasswordVisible, // Toggle password visibility
              ),
              const SizedBox(height: 20),

              // ✅ Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2), // Facebook Blue
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                     ),
              ),
              const SizedBox(height: 20),

              // ✅ Hyperlink: Already have an account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                        color: Color(0xFF1877F2),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
