import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100), // Adjust to shift content down
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Changed text color to black
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  "Already have an account? Log In",
                  style: TextStyle(
                      color: Colors.black), // Changed text color to black
                ),
              ),
              const SizedBox(height: 30),

              // Full Name
              _buildTextField(label: "Full Name", icon: Icons.person),
              const SizedBox(height: 15),

              // Email
              _buildTextField(label: "Email", icon: Icons.email),
              const SizedBox(height: 15),

              // Password
              _buildTextField(
                  label: "Password", icon: Icons.lock, obscureText: true),
              const SizedBox(height: 15),

              // Confirm Password
              _buildTextField(
                  label: "Confirm Password",
                  icon: Icons.lock,
                  obscureText: true),
              const SizedBox(height: 30),

              // Sign Up Button
              ElevatedButton(
                onPressed: () {
                  // Handle sign up logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  Color(0xFF029fae)
                      , // Changed button color to light blue
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text("Sign Up"),
              ),
              const SizedBox(height: 20),

              // Sign Up with Google
              ElevatedButton.icon(
                onPressed: () {
                  // Handle sign up with Google logic
                },
                icon: Image.asset('assets/images/google_logo.png',
                    height: 24, width: 24), // Ensure correct path
                label: const Text("Sign Up with Google"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 50), // Adjust to shift content down
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String label,
      required IconData icon,
      bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }
}
