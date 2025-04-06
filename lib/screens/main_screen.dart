import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:insta_stonks/screens/screens.dart';
import 'package:insta_stonks/shared/shared.dart';
import 'package:insta_stonks/providers/providers.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _dialogShown = false;

  final List<Widget> _screens = const [
    DashboardScreen(),
    SearchScreen(),
    AnalyticsScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final usernameProvider = Provider.of<UsernameProvider>(
      context,
      listen: false,
    );
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (!_dialogShown && uid != null) {
      _dialogShown = true;

      usernameProvider.checkUsername().then((_) {
        if (usernameProvider.username == null) {
          _showUsernameDialog(usernameProvider);
        }
      });
    }
  }

  Future<void> _showUsernameDialog(UsernameProvider usernameProvider) async {
    final controller = TextEditingController();

    final entered = await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => UsernameDialog(controller: controller),
    );

    if (entered != null && entered.isNotEmpty) {
      await usernameProvider.setUsername(entered);
      await usernameProvider.checkUsername();
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}
