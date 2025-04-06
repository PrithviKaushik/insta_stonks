import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:insta_stonks/providers/providers.dart';
import 'package:insta_stonks/providers/username_provider.dart';
import 'package:insta_stonks/routes.dart';
import 'package:insta_stonks/theme.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UsernameProvider()),
      ],
      child: const InstaStonks(),
    ),
  );
}

class InstaStonks extends StatelessWidget {
  const InstaStonks({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viralyze',
      //home: authProvider.user != null ? HomeScreen() : SignInScreen(),
      routes: appRoutes,
      theme: appTheme,
    );
  }
}
