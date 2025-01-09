// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:leveleight/confirmation.dart';
import 'package:provider/provider.dart';
import 'auth.dart';
import 'firstpage.dart';
import 'signup.dart';
import 'login.dart';
import 'otpverification.dart';
import 'homepage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
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
      initialRoute: authProvider.isAuthenticated ? '/home' : '/',
      routes: {
        '/': (context) => FirstScreen(),
        '/signup': (context) => SignupScreen(),
        '/login': (context) => LoginScreen(),
        '/otp': (context) => OTPScreen(),
        '/home': (context) => HomeScreen(),
        '/verify': (context) => VerificationPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/register') {
          final email = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => RegisterPage(email: email),
          );
        }

        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => UnknownPage(),
        );
      },
    );
  }
}

class RegisterPage extends StatelessWidget {
  final String email;

  const RegisterPage({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Center(
        child: Text("Registering with email: $email"),
      ),
    );
  }
}

class UnknownPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page Not Found"),
      ),
      body: Center(
        child: Text("404 - Page not found!"),
      ),
    );
  }
}
