import 'package:flutter/material.dart';
import 'package:leveleight/confirmation.dart';
import 'package:provider/provider.dart';
import 'auth.dart';
import 'firstpage.dart';
import 'signup.dart';
import 'login.dart';
import 'otpverification.dart';
import 'homepage.dart'; // HomePage for authenticated users

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              AuthProvider(), // Implement AuthProvider logic for auth flow
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth Flow',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: authProvider.isAuthenticated
          ? '/home'
          : '/', // Dynamically set based on auth status
      routes: {
        '/': (context) =>
            FirstScreen(), // Initial screen (could be splash or intro)
        '/signup': (context) => SignupScreen(), // Sign-up page
        '/login': (context) => LoginScreen(), // Login page
        '/otp': (context) => OTPScreen(), // OTP verification page
        '/home': (context) => HomeScreen(), // Home page for authenticated users
        '/verify': (context) => VerificationPage(), // Email verification page
      },
      // Add onGenerateRoute to handle dynamic routes
      onGenerateRoute: (settings) {
        if (settings.name == '/register') {
          final email =
              settings.arguments as String; // Receive the email argument
          return MaterialPageRoute(
            builder: (context) => RegisterPage(email: email), // Pass the email
          );
        }
        // Add more routes with dynamic arguments if needed
        return null; // Fallback to default behavior if route not found
      },
      // Optional: Handle undefined routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) =>
              UnknownPage(), // Display a 404 page or error page
        );
      },
    );
  }
}

// Example RegisterPage implementation to accept email
class RegisterPage extends StatelessWidget {
  final String email;

  RegisterPage({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Center(
        child: Text(
            "Registering with email: $email"), // Display email or handle registration
      ),
    );
  }
}

// Optional: Handle unknown routes
class UnknownPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page Not Found"),
      ),
      body: Center(
        child: Text("404 - Page not found!"),
      ),
    );
  }
}
