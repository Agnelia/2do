import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_health_reminders/providers/inspiration_provider.dart';
import 'package:todo_health_reminders/models/inspiration_image.dart';
import 'package:todo_health_reminders/models/inspiration_theme.dart';
import 'package:todo_health_reminders/utils/inspiration_colors.dart';
import 'package:todo_health_reminders/widgets/responsive_layout.dart';
import 'package:todo_health_reminders/widgets/comment_badge.dart';
import 'package:intl/intl.dart';

class SavedImagesScreen extends StatelessWidget {
  const SavedImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Valda bilder',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: InspirationColors.lightOrange.withOpacity(0.3),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<InspirationProvider>(
        builder: (context, provider, child) {
          if (provider.savedImages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Inga sparade bilder',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Börja söka efter inspiration!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
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
              itemCount: provider.savedImages.length,
              itemBuilder: (context, index) {
                final savedImage = provider.savedImages[index];
                return _buildSavedImageCard(
                  context,
                  savedImage.id,
                  savedImage.image,
                  savedImage.savedAt,
                  provider,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSavedImageCard(
    BuildContext context,
    String savedImageId,
    InspirationImage image,
    DateTime savedAt,
    InspirationProvider provider,
  ) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    
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
                // Comment badge for user-uploaded images
                if (image.comments.isNotEmpty)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: CommentBadge(
                      commentCount: image.comments.length,
                      backgroundColor: InspirationColors.orange,
                      size: 28,
                    ),
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
                      icon: const Icon(
                        Icons.delete,
                        size: 16,
                        color: Colors.red,
                      ),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        _showDeleteDialog(
                          context,
                          savedImageId,
                          provider,
                        );
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
                Text(
                  'Sparad: ${dateFormat.format(savedAt)}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tema: ${image.theme.displayName}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    String savedImageId,
    InspirationProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ta bort bild?'),
          content: const Text('Är du säker på att du vill ta bort denna bild?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Avbryt'),
            ),
            TextButton(
              onPressed: () {
                provider.removeSavedImage(savedImageId);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Ta bort'),
            ),
          ],
        );
      },
    );
  }
}
