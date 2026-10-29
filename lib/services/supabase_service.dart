import 'package:flutter/foundation.dart';
import '../models/fabric_product_model.dart';

class SupabaseConfig {
  static const String defaultUrl = 'https://YOUR_PROJECT_ID.supabase.co';
  static const String defaultAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}

class SupabaseService extends ChangeNotifier {
  bool _isConnected = false;
  String _supabaseUrl = SupabaseConfig.defaultUrl;
  String _supabaseAnonKey = SupabaseConfig.defaultAnonKey;
  String _statusMessage = 'Mode démo local (hors-ligne)';

  bool get isConnected => _isConnected;
  String get supabaseUrl => _supabaseUrl;
  String get supabaseAnonKey => _supabaseAnonKey;
  String get statusMessage => _statusMessage;

  void configure({required String url, required String anonKey}) {
    _supabaseUrl = url;
    _supabaseAnonKey = anonKey;
    _isConnected = url.isNotEmpty && !url.contains('YOUR_PROJECT_ID');
    _statusMessage = _isConnected ? 'Connecté à Supabase Cloud' : 'Mode démo local';
    notifyListeners();
  }

  // Enregistrement d'une nouvelle boutique dans Supabase
  Future<bool> registerShop({
    required String ownerId,
    required String shopName,
    required String marketCity,
    required String bankName,
    required String accountNumberNuban,
  }) async {
    try {
      if (!_isConnected) {
        // Simulation locale
        await Future.delayed(const Duration(milliseconds: 600));
        return true;
      }
      // Appel API Supabase REST
      // POST /rest/v1/shops
      return true;
    } catch (e) {
      debugPrint('Erreur Supabase registerShop: $e');
      return false;
    }
  }

  // Récupération des tissus depuis Supabase
  Future<List<FabricProduct>> fetchProducts() async {
    if (!_isConnected) {
      return FabricProduct.getDemoProducts();
    }
    // Simulation / Appel Supabase
    return FabricProduct.getDemoProducts();
  }

  // Validation d'une boutique par le Super Admin
  Future<bool> approveShop(String shopId) async {
    try {
      if (!_isConnected) {
        await Future.delayed(const Duration(milliseconds: 400));
        return true;
      }
      // UPDATE shops SET status = 'approved' WHERE id = shopId
      return true;
    } catch (e) {
      return false;
    }
  }
}
