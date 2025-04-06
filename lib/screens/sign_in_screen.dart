import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:insta_stonks/providers/providers.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(
      context,
    ); //It uses context to look up provider instance from the widget tree.
    final usernameProvider = Provider.of<UsernameProvider>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign In',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              TextField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(height: 24),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  await authProvider.signInWithEmailAndPassword(
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
                child: Text('Sign in'),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Text('OR'),
              SizedBox(height: 32),
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
