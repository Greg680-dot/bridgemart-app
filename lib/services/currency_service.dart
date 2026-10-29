import 'dart:async';
import 'package:flutter/foundation.dart';
import '../config/constants.dart';
import '../models/quote_model.dart';

class CurrencyService extends ChangeNotifier {
  double _rateXofToNgn = AppConstants.defaultXofToNgnRate;
  double _rateNgnToXof = AppConstants.defaultNgnToXofRate;
  double _spreadPercent = AppConstants.defaultPlatformSpreadPercent;
  DateTime _lastRateUpdate = DateTime.now();
  bool _isLoading = false;

  QuoteModel? _activeQuote;
  Timer? _quoteTimer;
  int _quoteSecondsRemaining = 0;

  double get rateXofToNgn => _rateXofToNgn;
  double get rateNgnToXof => _rateNgnToXof;
  double get spreadPercent => _spreadPercent;
  DateTime get lastRateUpdate => _lastRateUpdate;
  bool get isLoading => _isLoading;
  QuoteModel? get activeQuote => _activeQuote;
  int get quoteSecondsRemaining => _quoteSecondsRemaining;

  // Calcul d'une cotation verrouillée pendant 5 minutes
  QuoteModel createLockedQuote({
    required double amountNgn,
    String? bankCode,
    String? bankName,
    String? accountNumber,
    String? accountName,
  }) {
    _quoteTimer?.cancel();

    _activeQuote = QuoteModel.calculate(
      amountNgn: amountNgn,
      rateNgnToXof: _rateNgnToXof,
      rateXofToNgn: _rateXofToNgn,
      spreadPercent: _spreadPercent,
      bankCode: bankCode,
      bankName: bankName,
      accountNumber: accountNumber,
      accountName: accountName,
    );

    _quoteSecondsRemaining = AppConstants.quoteLockDurationSeconds;

    _quoteTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_quoteSecondsRemaining > 0) {
        _quoteSecondsRemaining--;
        notifyListeners();
      } else {
        timer.cancel();
        notifyListeners();
      }
    });

    notifyListeners();
    return _activeQuote!;
  }

  void cancelActiveQuote() {
    _quoteTimer?.cancel();
    _activeQuote = null;
    _quoteSecondsRemaining = 0;
    notifyListeners();
  }

  // Simulation de vérification du compte bancaire nigérian (Paystack/Flutterwave account resolve)
  Future<Map<String, dynamic>> resolveNigerianBankAccount({
    required String bankCode,
    required String accountNumber,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Simulation d'appel réseau API Paystack / Flutterwave
    await Future.delayed(const Duration(milliseconds: 900));
    _isLoading = false;

    if (accountNumber.length != 10) {
      notifyListeners();
      return {
        'success': false,
        'message': 'Le numéro de compte doit comporter exactement 10 chiffres (format NUBAN nigérian).',
      };
    }

    // Mock des noms réels selon les derniers chiffres pour un rendu ultra-réaliste
    String resolvedName;
    if (accountNumber.endsWith('01') || accountNumber.endsWith('11')) {
      resolvedName = 'FOLAKE ADESHINA TEXTILES NIG ENT';
    } else if (accountNumber.endsWith('22') || accountNumber.endsWith('89')) {
      resolvedName = 'CHINEDU OKONKWO FABRICS INT\'L';
    } else if (accountNumber.endsWith('77')) {
      resolvedName = 'KUDIRAT TRADING & CO. (BALOGUN)';
    } else {
      resolvedName = 'ALHAJI BASHIRU TEXTILES & LACE VENTURES';
    }

    notifyListeners();
    return {
      'success': true,
      'accountName': resolvedName,
      'accountNumber': accountNumber,
      'bankCode': bankCode,
    };
  }

  // Rafraîchir le taux de référence
  Future<void> refreshExchangeRate() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));
    // Légère variation réaliste du marché parallèle NGN/XOF
    _rateXofToNgn = 2.43 + (DateTime.now().second % 4) * 0.01;
    _rateNgnToXof = 1.0 / _rateXofToNgn;
    _lastRateUpdate = DateTime.now();

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _quoteTimer?.cancel();
    super.dispose();
  }
}
