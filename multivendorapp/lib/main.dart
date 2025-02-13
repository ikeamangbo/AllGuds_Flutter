import 'package:flutter/material.dart';

import '/changepassword.dart';
import '/email_verification_page.dart';
import '/faqs.dart';
import '/forgot_password_confirmation_page.dart';
import '/forgot_password_page.dart';
import '/login_page.dart';
import '/new_password_page.dart';
import '/onboarding_screen.dart';
import '/order_history.dart';
import '/password_created_page.dart';
import '/paymentmethod.dart';
import '/privacypolicy.dart';
import '/profilepage.dart';
import '/shippingaddress.dart';
import '/signup_page.dart';
import '/splash_screen.dart';
import '/termsandconditions.dart';
import '/homepage.dart'; // Changed from home_page.dart to homepage.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AllGuds',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF029fae),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF029fae)),
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => LoginPage(),
        '/onboarding': (context) => OnboardingScreen(),
        '/signup': (context) => SignupPage(),
        '/email_verification': (context) => EmailVerificationPage(),
        '/login': (context) => LoginPage(),
        '/forgot_password': (context) => ForgotPasswordPage(),
        '/forgot_password_confirmation': (context) =>
            ForgotPasswordConfirmationPage(),
        '/new_password': (context) => NewPasswordPage(),
        '/password_created': (context) => PasswordCreatedPage(),
        '/profile': (context) => ProfilePage(),
        '/shipping-address': (context) => const ShippingAddressPage(),
        '/payment-method': (context) => const PaymentMethodPage(),
        '/privacy-policy': (context) => const PrivacyPolicyPage(),
        '/terms-conditions': (context) => const TermsConditionsPage(),
        '/faqs': (context) => const FAQsPage(),
        '/change-password': (context) => const ChangePasswordPage(),
        '/order-history': (context) => OrderHistoryPage(),
        '/home': (context) =>
            const HomePage(), // Changed to use existing HomePage
      },
    );
  }
}
