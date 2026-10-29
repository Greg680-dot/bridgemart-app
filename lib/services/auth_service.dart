import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isAuthenticated = true; // Auto-connecté pour tester l'application directement
  bool _isLoading = false;

  AuthService() {
    _currentUser = UserModel.demoBuyer();
  }

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  // Envoi code OTP par SMS
  Future<bool> sendOtp(String phone) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 900));
    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Vérification code OTP
  Future<bool> verifyOtp(String phone, String otp) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1000));
    _currentUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      phone: phone,
      fullName: 'Acheteur Béninois',
      city: 'Cotonou',
      kycStatus: 'unverified',
      dailyLimitXof: 100000,
      createdAt: DateTime.now(),
    );
    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
    return true;
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
        dailyLimitXof: 500000, // Plafond KYC 1 validé
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
