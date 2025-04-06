import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:insta_stonks/providers/providers.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final usernameProvider = Provider.of<UsernameProvider>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Sign Up',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  await authProvider.signUpWithEmailAndPassword(
                    name: _name.text,
                    email: _email.text,
                    password: _password.text,
                  );
                  await usernameProvider.checkUsername();

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  ); //coz our /signup isnt mentioned inside the auth_wrapper, we need to send it to the authwrapper manually! Also pushnamedandremoveduntil so that user doesnt see a "back" button.
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signin');
                    },
                    child: const Text('Sign In'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text('OR', textAlign: TextAlign.center),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  await authProvider.signInWithGoogle();

                  await usernameProvider.checkUsername();

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  ); //coz our /signup isnt mentioned inside the auth_wrapper, we need to send it to the authwrapper manually! Also pushnamedandremoveduntil so that user doesnt see a "back" button.
                },
                child: const Text('Continue with Google'),
              ),

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  await authProvider.signInWithFacebook();
                  await usernameProvider.checkUsername();

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  ); //coz our /signup isnt mentioned inside the auth_wrapper, we need to send it to the authwrapper manually! Also pushnamedandremoveduntil so that user doesnt see a "back" button.
                },
                child: const Text('Continue with Facebook'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
