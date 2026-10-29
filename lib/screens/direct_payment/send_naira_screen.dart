import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../models/quote_model.dart';
import '../../services/currency_service.dart';
import '../../services/escrow_order_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/countdown_timer_badge.dart';
import '../receipts/transaction_receipt_screen.dart';

class SendNairaScreen extends StatefulWidget {
  const SendNairaScreen({Key? key}) : super(key: key);

  @override
  State<SendNairaScreen> createState() => _SendNairaScreenState();
}

class _SendNairaScreenState extends State<SendNairaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountNgnController = TextEditingController(text: '100000');
  final _accountNumberController = TextEditingController(text: '0123456789');
  
  Map<String, String> _selectedBank = AppConstants.nigerianBanks[1]; // GTBank par défaut
  String? _resolvedAccountName = 'ADEYEMI BROTHERS NIGERIA LTD';
  bool _isResolvingAccount = false;
  String _selectedOperator = 'MTN MoMo Bénin';
  QuoteModel? _currentQuote;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateQuote();
    });
  }

  void _calculateQuote() {
    final amount = double.tryParse(_amountNgnController.text.replaceAll(' ', '')) ?? 0;
    if (amount > 0) {
      final currency = Provider.of<CurrencyService>(context, listen: false);
      final quote = currency.createLockedQuote(
        amountNgn: amount,
        bankCode: _selectedBank['code'],
        bankName: _selectedBank['name'],
        accountNumber: _accountNumberController.text,
        accountName: _resolvedAccountName,
      );
      setState(() {
        _currentQuote = quote;
      });
    }
  }

  Future<void> _verifyAccount() async {
    final currency = Provider.of<CurrencyService>(context, listen: false);
    setState(() {
      _isResolvingAccount = true;
      _resolvedAccountName = null;
    });

    final res = await currency.resolveNigerianBankAccount(
      bankCode: _selectedBank['code']!,
      accountNumber: _accountNumberController.text.trim(),
    );

    setState(() {
      _isResolvingAccount = false;
      if (res['success'] == true) {
        _resolvedAccountName = res['accountName'];
        _calculateQuote();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Compte introuvable'), backgroundColor: AppTheme.error),
        );
      }
    });
  }

  void _processPayment() async {
    if (_resolvedAccountName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez vérifier le nom du titulaire du compte avant de continuer.'),
          backgroundColor: AppTheme.warning,
        ),
      );
      return;
    }

    if (_currentQuote == null || _currentQuote!.isExpired) {
      _calculateQuote();
    }

    final escrowService = Provider.of<EscrowOrderService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    final order = await escrowService.createDirectTransferOrder(
      quote: _currentQuote!,
      paymentOperator: _selectedOperator,
      buyerPhone: authService.currentUser?.phone ?? '+229 97 00 00 00',
    );

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionReceiptScreen(order: order),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<CurrencyService>(context);
    final currencyFormatter = NumberFormat('#,###', 'fr_FR');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payer un Fournisseur au Nigeria'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser le taux',
            onPressed: () {
              currency.refreshExchangeRate();
              _calculateQuote();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicateur Taux Direct
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.nigeriaGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.nigeriaGreen.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.currency_exchange, color: AppTheme.nigeriaGreen, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Taux Marché Référence XOF / NGN',
                            style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '1 XOF = ${currency.rateXofToNgn.toStringAsFixed(2)} NGN  (1 NGN ≈ ${(currency.rateNgnToXof).toStringAsFixed(4)} XOF)',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
              const Text(
                '1. Coordonnées Bancaires Nigérianes',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 10),

              // Sélection Banque Nigériane
              DropdownButtonFormField<Map<String, String>>(
                value: _selectedBank,
                decoration: const InputDecoration(
                  labelText: 'Banque nigériane du commerçant',
                  prefixIcon: Icon(Icons.account_balance, color: AppTheme.primary),
                ),
                items: AppConstants.nigerianBanks.map((bank) {
                  return DropdownMenuItem(
                    value: bank,
                    child: Text(bank['name']!, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedBank = val;
                      _resolvedAccountName = null;
                    });
                  }
                },
              ),

              const SizedBox(height: 12),

              // Numéro de compte NUBAN + bouton vérifier
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _accountNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        labelText: 'N° de compte NUBAN (10 chiffres)',
                        prefixIcon: Icon(Icons.numbers, color: AppTheme.primary),
                        counterText: '',
                      ),
                      onChanged: (_) {
                        setState(() {
                          _resolvedAccountName = null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isResolvingAccount ? null : _verifyAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondary,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: _isResolvingAccount
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Vérifier', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),

              // Affichage du nom résolu automatiquement
              if (_resolvedAccountName != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.success.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppTheme.success, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Titulaire certifié du compte :', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                            Text(
                              _resolvedAccountName!,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.success),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),
              const Text(
                '2. Montant en Naira (NGN) à virer',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _amountNgnController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Montant réclamé par le commerçant en Naira',
                  prefixText: '₦ ',
                  prefixStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  suffixText: 'NGN',
                ),
                onChanged: (_) => _calculateQuote(),
              ),

              // Raccourcis montants
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Wrap(
                  spacing: 8,
                  children: [50000, 100000, 250000, 500000].map((amt) {
                    return ActionChip(
                      label: Text('₦ ${currencyFormatter.format(amt)}', style: const TextStyle(fontSize: 11)),
                      onPressed: () {
                        _amountNgnController.text = amt.toString();
                        _calculateQuote();
                      },
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // Box de Cotation Verrouillée avec Minuteur
              if (_currentQuote != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryLight.withOpacity(0.3), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Cotation Verrouillée',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primary),
                          ),
                          CountdownTimerBadge(secondsRemaining: currency.quoteSecondsRemaining),
                        ],
                      ),
                      const Divider(height: 24),

                      _buildQuoteRow('Montant net reçu par le vendeur', '₦ ${currencyFormatter.format(_currentQuote!.amountNgn)} NGN'),
                      const SizedBox(height: 6),
                      _buildQuoteRow('Équivalent brut en FCFA', '${currencyFormatter.format(_currentQuote!.rawAmountXof)} XOF'),
                      const SizedBox(height: 6),
                      _buildQuoteRow('Frais de change & couverture (1.8%)', '+${currencyFormatter.format(_currentQuote!.platformFeeXof)} XOF'),
                      const SizedBox(height: 6),
                      _buildQuoteRow('Frais d\'encaissement Kkiapay (1.2%)', '+${currencyFormatter.format(_currentQuote!.kkiapayFeeXof)} XOF'),
                      
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total à débiter en FCFA :',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          ),
                          Text(
                            '${currencyFormatter.format(_currentQuote!.totalXof)} XOF',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),
              const Text(
                '3. Mode de Paiement Mobile Money Bénin',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 10),

              // Choix opérateur Kkiapay
              Column(
                children: AppConstants.mobileMoneyOperators.map((op) {
                  final isSelected = _selectedOperator == op['name'];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppTheme.primary : AppTheme.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: RadioListTile<String>(
                      value: op['name']!,
                      groupValue: _selectedOperator,
                      activeColor: AppTheme.primary,
                      title: Text(op['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      subtitle: Text('Paiement instantané sécurisé par Kkiapay (${op['code']})', style: const TextStyle(fontSize: 11)),
                      secondary: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Color(int.parse(op['logoColor']!)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.phone_android, color: Colors.white, size: 18),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _selectedOperator = val!;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Bouton Payer
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _currentQuote == null ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Confirmer & Payer par Mobile Money',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
      ],
    );
  }

  @override
  void dispose() {
    _amountNgnController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }
}
