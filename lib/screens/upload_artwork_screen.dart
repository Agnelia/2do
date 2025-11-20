import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_health_reminders/providers/inspiration_provider.dart';
import 'package:todo_health_reminders/models/inspiration_theme.dart';
import 'package:todo_health_reminders/models/image_style.dart';
import 'package:todo_health_reminders/utils/inspiration_colors.dart';

class UploadArtworkScreen extends StatefulWidget {
  const UploadArtworkScreen({super.key});

  @override
  State<UploadArtworkScreen> createState() => _UploadArtworkScreenState();
}

class _UploadArtworkScreenState extends State<UploadArtworkScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  InspirationTheme? _selectedTheme;
  ImageStyle? _selectedStyle;
  
  @override
  void dispose() {
    _usernameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ladda upp konst',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: InspirationColors.lightOrange.withOpacity(0.3),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(),
              const SizedBox(height: 24),
              
              _buildSectionTitle('Ditt användarnamn'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Ange ditt namn',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ange ett användarnamn';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              _buildSectionTitle('Bild URL'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  hintText: 'https://example.com/image.jpg',
                  prefixIcon: const Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ange en bild URL';
                  }
                  if (!value.startsWith('http')) {
                    return 'URL måste börja med http eller https';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              _buildSectionTitle('Välj tema'),
              const SizedBox(height: 12),
              _buildThemeDropdown(),
              const SizedBox(height: 24),
              
              _buildSectionTitle('Välj stil'),
              const SizedBox(height: 12),
              _buildStyleDropdown(),
              const SizedBox(height: 32),
              
              Center(
                child: ElevatedButton(
                  onPressed: _uploadArtwork,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: InspirationColors.copper,
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
                      Icon(Icons.upload, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        'Ladda upp',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: InspirationColors.lightOrange.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: InspirationColors.orange,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Dela dina konstverk med andra användare. Ditt namn kommer att visas på bilden.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildThemeDropdown() {
    return DropdownButtonFormField<InspirationTheme>(
      value: _selectedTheme,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.palette),
      ),
      hint: const Text('Välj ett tema'),
      items: InspirationTheme.values.map((theme) {
        return DropdownMenuItem(
          value: theme,
          child: Row(
            children: [
              Icon(theme.icon, size: 20),
              const SizedBox(width: 12),
              Text(theme.displayName),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedTheme = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Välj ett tema';
        }
        return null;
      },
    );
  }

  Widget _buildStyleDropdown() {
    return DropdownButtonFormField<ImageStyle>(
      value: _selectedStyle,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.brush),
      ),
      hint: const Text('Välj en stil'),
      items: ImageStyle.values.map((style) {
        return DropdownMenuItem(
          value: style,
          child: Text(
            style.displayName,
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedStyle = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Välj en stil';
        }
        return null;
      },
    );
  }

  void _uploadArtwork() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_selectedTheme == null || _selectedStyle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Välj både tema och stil'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final provider = Provider.of<InspirationProvider>(
      context,
      listen: false,
    );
    
    // Set the theme and style in provider before uploading
    provider.setTheme(_selectedTheme!);
    provider.setStyle(_selectedStyle!);
    
    await provider.uploadArtwork(
      _imageUrlController.text,
      _usernameController.text,
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konstverk uppladdat!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context);
    }
  }
}
