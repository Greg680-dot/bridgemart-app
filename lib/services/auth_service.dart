import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isAuthenticated = true; // Auto-connecté par défaut
  bool _isLoading = false;

  AuthService() {
    _currentUser = UserModel.demoBuyer();
  }

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String get currentRole => _currentUser?.role ?? 'buyer';

  // Connexion rapide avec un profil de démonstration spécifique
  void loginAs(UserModel user) {
    _currentUser = user;
    _isAuthenticated = true;
    notifyListeners();
  }

  // Changer de rôle instantanément (Acheteur, Vendeur, Agent, Admin)
  void switchRole(String role) {
    if (role == 'seller') {
      _currentUser = UserModel.demoSeller();
    } else if (role == 'agent_relais') {
      _currentUser = UserModel.demoAgent();
    } else if (role == 'admin') {
      _currentUser = UserModel.demoAdmin();
    } else {
      _currentUser = UserModel.demoBuyer();
    }
    _isAuthenticated = true;
    notifyListeners();
  }

  // Envoi code OTP par SMS
  Future<bool> sendOtp(String phone) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Vérification code OTP avec attribution automatique du rôle
  Future<bool> verifyOtp(String phone, String otp) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));

    final cleanPhone = phone.replaceAll(' ', '').trim();
    if (cleanPhone.contains('80123456') || cleanPhone.contains('+234')) {
      _currentUser = UserModel.demoSeller();
    } else if (cleanPhone.contains('97001122')) {
      _currentUser = UserModel.demoAgent();
    } else if (cleanPhone.contains('90000001')) {
      _currentUser = UserModel.demoAdmin();
    } else {
      _currentUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        phone: phone,
        fullName: 'Acheteur Béninois',
        city: 'Cotonou',
        role: 'buyer',
        kycStatus: 'unverified',
        dailyLimitXof: 100000,
        createdAt: DateTime.now(),
      );
    }

    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Demande de création de boutique par un acheteur
  Future<void> registerShop({
    required String shopName,
    required String shopMarket,
    required String bankName,
    required String bankAccountNuban,
  }) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));

    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        shopName: shopName,
        shopMarket: shopMarket,
        bankName: bankName,
        bankAccountNuban: bankAccountNuban,
        shopStatus: 'pending_approval',
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  // Validation administrative de la boutique par le Super Admin
  void approveShop() {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        shopStatus: 'approved',
        role: 'seller',
      );
      notifyListeners();
    }
  }

  // Soumission KYC Niveau 1 (Pièce + Selfie)
  Future<bool> submitKycLevel1({
    required String fullName,
    required String documentType,
    required String idNumber,
  }) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));

    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        fullName: fullName,
        kycStatus: 'level_1',
        dailyLimitXof: 500000,
        kycDocumentType: documentType,
        kycIdNumber: idNumber,
      );
    }
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
