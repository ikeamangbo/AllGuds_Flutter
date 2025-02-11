import 'package:flutter/material.dart';
import 'package:multivendorapp/changepassword.dart';
import 'changepassword.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color primaryColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle('Account Settings'),
            _buildListTile(context, 'Shipping Address', Icons.location_on, '/shipping-address'),
            _buildListTile(context, 'Payment Method', Icons.payment, '/payment-method'),
            _buildListTile(context, 'Order History', Icons.history, '/order-history'),

            const SizedBox(height: 20),
            _buildSectionTitle('Support & Information'),
            _buildListTile(context, 'Privacy Policy', Icons.privacy_tip, '/privacy-policy'),
            _buildListTile(context, 'Terms and Conditions', Icons.description, '/terms-conditions'),
            _buildListTile(context, 'FAQs', Icons.help, '/faqs'),

            const SizedBox(height: 20),
            _buildSectionTitle('Account Management'),
            ListTile(
              leading: const Icon(Icons.lock, color: primaryColor),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                );
              },
            ),

            const SizedBox(height: 20),
            _buildSectionTitle('Logout'),
            _buildListTile(context, 'Log Out', Icons.logout, '/logout', isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, IconData icon, String route, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        if (isLogout) {
          _showLogoutDialog(context);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
      ),
    );
  }

  void _performLogout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout(context);
              },
              child: const Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
