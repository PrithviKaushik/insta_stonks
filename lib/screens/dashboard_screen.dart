import 'package:flutter/material.dart';
import 'package:insta_stonks/screens/post_chart_screen.dart';
import 'package:insta_stonks/shared/left_drawer.dart';
import 'package:provider/provider.dart';
import 'package:insta_stonks/providers/providers.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UsernameProvider>(context).username;
    final biography = Provider.of<UsernameProvider>(context).biography;
    final profilePicUrlHd =
        Provider.of<UsernameProvider>(context).profilePicUrlHd;

    return Scaffold(
      appBar: AppBar(
        title: Text('VIRALYZE', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 12.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child:
                            profilePicUrlHd != null
                                ? Image.network(
                                  '${profilePicUrlHd}@2x.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) => Icon(
                                        Icons.account_circle,
                                        size: 60,
                                        color: Colors.grey.shade400,
                                      ),
                                )
                                : Icon(
                                  Icons.account_circle,
                                  size: 60,
                                  color: Colors.grey.shade400,
                                ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '@${username ?? 'Unknown'}',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Tooltip(
                              message: biography ?? 'No bio available',
                              child: Text(
                                (biography != null && biography.length > 80)
                                    ? '${biography.substring(0, 80)}...'
                                    : (biography ?? 'No bio available'),
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Use Expanded so the chart fits remaining space
            if (username != null)
              Expanded(child: PostChartScreen(username: username))
            else
              const Expanded(child: Center(child: CircularProgressIndicator())),
          ],
        ),
      ),

      drawer: LeftDrawer(),
    );
  }
}
