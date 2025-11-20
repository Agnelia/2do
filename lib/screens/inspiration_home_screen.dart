import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_health_reminders/providers/inspiration_provider.dart';
import 'package:todo_health_reminders/screens/inspiration_search_screen.dart';
import 'package:todo_health_reminders/screens/saved_images_screen.dart';
import 'package:todo_health_reminders/screens/upload_artwork_screen.dart';
import 'package:todo_health_reminders/utils/inspiration_colors.dart';

class InspirationHomeScreen extends StatelessWidget {
  const InspirationHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              InspirationColors.lightOrange.withOpacity(0.3),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildBanner(context),
              Expanded(
                child: _buildDashboard(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            InspirationColors.gold.withOpacity(0.6),
            InspirationColors.red.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Smiling sun icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.wb_sunny,
              size: 80,
              color: InspirationColors.gold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Inspirationsappen',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Din kreativa inspirationskälla',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    return Consumer<InspirationProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Vad vill du göra?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 48),
              _buildDashboardButton(
                context,
                'Sök inspiration',
                'Hitta nya motiv och teman',
                Icons.search,
                InspirationColors.orange,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InspirationSearchScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildDashboardButton(
                context,
                'Valda bilder',
                'Se dina sparade bilder (${provider.savedImages.length})',
                Icons.image,
                InspirationColors.turquoise,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SavedImagesScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildDashboardButton(
                context,
                'Ladda upp konst',
                'Dela dina egna verk',
                Icons.upload,
                InspirationColors.copper,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadArtworkScreen(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDashboardButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: color,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
