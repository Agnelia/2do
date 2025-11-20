import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProvider with ChangeNotifier {
  bool _isAdminMode = false;
  bool _isLoaded = false;

  bool get isAdminMode => _isAdminMode;

  AdminProvider() {
    _loadAdminMode();
  }

  Future<void> _loadAdminMode() async {
    if (_isLoaded) return;
    
    final prefs = await SharedPreferences.getInstance();
    _isAdminMode = prefs.getBool('admin_mode') ?? false;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setAdminMode(bool enabled) async {
    _isAdminMode = enabled;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('admin_mode', enabled);
    
    notifyListeners();
  }
}
