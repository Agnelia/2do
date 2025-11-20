import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_health_reminders/providers/inspiration_provider.dart';
import 'package:todo_health_reminders/models/inspiration_image.dart';
import 'package:todo_health_reminders/utils/inspiration_colors.dart';
import 'package:todo_health_reminders/widgets/responsive_layout.dart';

class ImageResultsScreen extends StatelessWidget {
  const ImageResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Välj inspiration',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: InspirationColors.lightOrange.withOpacity(0.3),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final provider = Provider.of<InspirationProvider>(
                context,
                listen: false,
              );
              provider.generateSuggestions();
            },
            tooltip: 'Nytt motiv',
          ),
        ],
      ),
      body: Consumer<InspirationProvider>(
        builder: (context, provider, child) {
          if (provider.currentSuggestions.isEmpty) {
            return const Center(
              child: Text('Inga förslag tillgängliga'),
            );
          }
          
          final crossAxisCount = ResponsiveBreakpoints.isMobile(context) ? 2 :
                                 ResponsiveBreakpoints.isTablet(context) ? 3 : 4;
          
          return ResponsiveLayout(
            child: GridView.builder(
              padding: EdgeInsets.all(
                ResponsiveBreakpoints.getHorizontalPadding(context),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: provider.currentSuggestions.length,
              itemBuilder: (context, index) {
                final image = provider.currentSuggestions[index];
                return _buildImageCard(context, image, provider);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageCard(
    BuildContext context,
    InspirationImage image,
    InspirationProvider provider,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  image.imageUrl,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                  cacheWidth: 400,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey.shade200,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        provider.removeAndReplaceSuggestion(image.id);
                      },
                      tooltip: 'Ta bort',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (image.source == ImageSource.userUploaded &&
                    image.uploaderUsername != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 12,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            image.uploaderUsername!,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await provider.saveImage(image);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Bild sparad!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.download, size: 14),
                    label: const Text(
                      'Spara',
                      style: TextStyle(fontSize: 11),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: InspirationColors.turquoise,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
