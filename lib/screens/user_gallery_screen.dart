import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_health_reminders/providers/inspiration_provider.dart';
import 'package:todo_health_reminders/models/inspiration_image.dart';
import 'package:todo_health_reminders/utils/inspiration_colors.dart';

class UserGalleryScreen extends StatelessWidget {
  const UserGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Användargalleri',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: InspirationColors.lightOrange.withOpacity(0.3),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<InspirationProvider>(
        builder: (context, provider, child) {
          if (provider.userArtworks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Inga användarverk ännu',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Var den första att ladda upp!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.userArtworks.length,
            itemBuilder: (context, index) {
              final artwork = provider.userArtworks[index];
              return _buildArtworkCard(context, artwork, provider);
            },
          );
        },
      ),
    );
  }

  Widget _buildArtworkCard(
    BuildContext context,
    InspirationImage artwork,
    InspirationProvider provider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              artwork.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300,
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Info section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User info
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: InspirationColors.copper,
                      child: Text(
                        artwork.uploaderUsername?.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            artwork.uploaderUsername ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '${artwork.theme.displayName} • ${artwork.style.displayName}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await provider.saveImage(artwork);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Bild sparad!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text('Spara'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: InspirationColors.turquoise,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Comments section
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.comment, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      '${artwork.comments.length} kommentarer',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Display comments
                if (artwork.comments.isNotEmpty) ...[
                  ...artwork.comments.take(3).map((comment) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '• $comment',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  )),
                  if (artwork.comments.length > 3)
                    TextButton(
                      onPressed: () {
                        _showAllComments(context, artwork);
                      },
                      child: Text(
                        'Visa alla ${artwork.comments.length} kommentarer',
                        style: TextStyle(color: InspirationColors.orange),
                      ),
                    ),
                ],
                
                // Add comment button
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    _showAddCommentDialog(context, artwork, provider);
                  },
                  icon: const Icon(Icons.add_comment),
                  label: const Text('Lägg till kommentar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: InspirationColors.orange,
                    side: BorderSide(color: InspirationColors.orange),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAllComments(BuildContext context, InspirationImage artwork) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alla kommentarer'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: artwork.comments.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('• ${artwork.comments[index]}'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Stäng'),
            ),
          ],
        );
      },
    );
  }

  void _showAddCommentDialog(
    BuildContext context,
    InspirationImage artwork,
    InspirationProvider provider,
  ) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lägg till kommentar'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Skriv din kommentar här...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Avbryt'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  provider.addComment(artwork.id, controller.text.trim());
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kommentar tillagd!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: InspirationColors.orange,
              ),
              child: const Text('Skicka'),
            ),
          ],
        );
      },
    );
  }
}
