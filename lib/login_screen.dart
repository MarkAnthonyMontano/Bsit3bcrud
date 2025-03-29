import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bsit3bcrud/main.dart';
import 'package:bsit3bcrud/register_screen.dart'; 



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showError("Please enter your email and password.");
      return;
    }

    final url = Uri.parse("http://192.168.1.8:5000/login");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserScreen()),
        );
        showSuccess("Login successful. Welcome, ${data['user']['username']}!");

      } else {
        showError("Invalid email or password.");
      }
    } catch (e) {
      showError("Error connecting to the server.");
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
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: const Text(
          "facebook",
          style: TextStyle(
            fontSize: 40,
            color: Color(0xFF1877F2),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Facebook Logo
            Image.asset(
              "assets/images/facebooklogo.png",
              height: 80,
            ),
            const SizedBox(height: 30),

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
                ),
              ),
              obscureText: !_isPasswordVisible,
            ),
            const SizedBox(height: 20),

            // ✅ Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1877F2),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                child: const Text(
                  "Log In",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Create an Account Hyperlink
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Create an Account",
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
    );
  }
}
