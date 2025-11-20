import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_health_reminders/providers/inspiration_provider.dart';
import 'package:todo_health_reminders/models/inspiration_theme.dart';
import 'package:todo_health_reminders/models/image_style.dart';
import 'package:todo_health_reminders/models/inspiration_image.dart';
import 'package:todo_health_reminders/screens/image_results_screen.dart';
import 'package:todo_health_reminders/utils/inspiration_colors.dart';

class InspirationSearchScreen extends StatefulWidget {
  const InspirationSearchScreen({super.key});

  @override
  State<InspirationSearchScreen> createState() => _InspirationSearchScreenState();
}

class _InspirationSearchScreenState extends State<InspirationSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sök inspiration',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: InspirationColors.lightOrange.withOpacity(0.3),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<InspirationProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('1. Välj källa'),
                  const SizedBox(height: 12),
                  _buildSourceToggle(provider),
                  const SizedBox(height: 32),
                  
                  _buildSectionTitle('2. Välj tema'),
                  const SizedBox(height: 12),
                  _buildThemeGrid(provider),
                  const SizedBox(height: 32),
                  
                  _buildSectionTitle('3. Välj stil'),
                  const SizedBox(height: 12),
                  _buildStyleList(provider),
                  const SizedBox(height: 32),
                  
                  if (provider.selectedTheme != null && 
                      provider.selectedStyle != null)
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          provider.generateSuggestions();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ImageResultsScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: InspirationColors.orange,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search, color: Colors.white),
                            SizedBox(width: 12),
                            Text(
                              'Visa inspiration',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSourceToggle(InspirationProvider provider) {
    return Row(
      children: [
        Expanded(
          child: _buildSourceCard(
            'Internet bilder',
            Icons.public,
            ImageSource.internet,
            provider.selectedSource == ImageSource.internet,
            () => provider.setSource(ImageSource.internet),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSourceCard(
            'Användare bilder',
            Icons.people,
            ImageSource.userUploaded,
            provider.selectedSource == ImageSource.userUploaded,
            () => provider.setSource(ImageSource.userUploaded),
          ),
        ),
      ],
    );
  }

  Widget _buildSourceCard(
    String title,
    IconData icon,
    ImageSource source,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected 
          ? InspirationColors.turquoise.withOpacity(0.2)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected 
              ? InspirationColors.turquoise
              : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
                color: isSelected 
                    ? InspirationColors.turquoise
                    : Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeGrid(InspirationProvider provider) {
    final themes = InspirationTheme.values;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final theme = themes[index];
        final isSelected = provider.selectedTheme == theme;
        
        return _buildThemeCard(theme, isSelected, () {
          provider.setTheme(theme);
        });
      },
    );
  }

  Widget _buildThemeCard(
    InspirationTheme theme,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final colors = [
      InspirationColors.orange,
      InspirationColors.darkGreen,
      InspirationColors.copper,
      InspirationColors.turquoise,
      InspirationColors.yellow,
      InspirationColors.lightGreen,
    ];
    final color = colors[theme.index % colors.length];
    
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? color.withOpacity(0.2) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? color : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              theme.icon,
              size: 36,
              color: isSelected ? color : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              theme.displayName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleList(InspirationProvider provider) {
    final styles = ImageStyle.values;
    
    return Column(
      children: styles.map((style) {
        final isSelected = provider.selectedStyle == style;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildStyleCard(style, isSelected, () {
            provider.setStyle(style);
          }),
        );
      }).toList(),
    );
  }

  Widget _buildStyleCard(
    ImageStyle style,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected 
          ? InspirationColors.orange.withOpacity(0.2)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected 
              ? InspirationColors.orange
              : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected 
                    ? InspirationColors.orange
                    : Colors.grey,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      style.displayName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      style.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
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
}
