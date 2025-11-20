import 'package:flutter/material.dart';
import 'package:todo_health_reminders/models/app_mode.dart';
import 'package:todo_health_reminders/screens/home_screen.dart';
import 'package:todo_health_reminders/screens/inspiration_home_screen.dart';
import 'package:todo_health_reminders/widgets/responsive_layout.dart';

class AppModeSelectionScreen extends StatelessWidget {
  const AppModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppHeader(context),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: ResponsiveLayout(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveBreakpoints.getHorizontalPadding(context),
                          vertical: 24.0,
                        ),
                        child: _buildCardLayout(context),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.shade400,
            Colors.deepOrange.shade300,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        children: [
          Text(
            '2do',
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Välj din app',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardLayout(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);
    
    if (isMobile) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildModeCard(
            context,
            AppMode.health,
            Icons.favorite,
            Colors.red.shade400,
            () => _navigateToMode(context, AppMode.health),
          ),
          const SizedBox(height: 24),
          _buildModeCard(
            context,
            AppMode.inspiration,
            Icons.palette,
            Colors.orange.shade400,
            () => _navigateToMode(context, AppMode.inspiration),
          ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildModeCard(
              context,
              AppMode.health,
              Icons.favorite,
              Colors.red.shade400,
              () => _navigateToMode(context, AppMode.health),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: _buildModeCard(
              context,
              AppMode.inspiration,
              Icons.palette,
              Colors.orange.shade400,
              () => _navigateToMode(context, AppMode.inspiration),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildModeCard(
    BuildContext context,
    AppMode mode,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: color,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                mode.displayName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                mode.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Öppna',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToMode(BuildContext context, AppMode mode) {
    Widget destination;
    
    switch (mode) {
      case AppMode.health:
        destination = const HomeScreen();
        break;
      case AppMode.inspiration:
        destination = const InspirationHomeScreen();
        break;
    }
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}
